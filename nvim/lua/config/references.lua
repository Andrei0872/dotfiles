-- LSP references annotated with *how* each location uses the symbol.
--
-- `textDocument/references` only returns bare locations, so each one is
-- classified with treesitter:
--   new   -> `Foo{...}`, `&pkg.Foo{...}`, `Gen[T]{...}`, `new(Foo)`, `var x Foo`
--   write -> `x = ...`, `x := ...`, `var x = ...`, `obj.Field = ...`, `Foo{Field: ...}`, `x++`
-- Tagged entries are sorted first; type `^new` / `^write` in the picker to filter.
local M = {}

local tags = {
  new = { text = "new  ", hl = "DiagnosticWarn", rank = 0 },
  write = { text = "write", hl = "DiagnosticHint", rank = 1 },
}
local untagged = { text = "     ", rank = 2 }

local function is(a, b)
  return a ~= nil and b ~= nil and a:equal(b)
end

local function contains(nodes, node)
  for _, n in ipairs(nodes) do
    if is(n, node) then
      return true
    end
  end
  return false
end

local function classify_go(node, src)
  local p = node:parent()
  if not p then
    return
  end

  -- `pkg.Foo` and `Foo[T]`: the reference points at `Foo`
  if p:type() == "qualified_type" or p:type() == "generic_type" then
    node, p = p, p:parent()
    if not p then
      return
    end
  end

  local pt = p:type()
  if pt == "composite_literal" and is(p:field("type")[1], node) then
    return "new"
  end
  if pt == "argument_list" and is(p:named_child(0), node) then
    local fn = p:parent() and p:parent():field("function")[1]
    if fn and vim.treesitter.get_node_text(fn, src) == "new" then
      return "new"
    end
  end
  if pt == "var_spec" then
    local has_value = #p:field("value") > 0
    if not has_value and is(p:field("type")[1], node) then
      return "new" -- zero value
    end
    if has_value and contains(p:field("name"), node) then
      return "write"
    end
  end
  -- `Foo{Field: ...}`
  if pt == "literal_element" then
    local kv = p:parent()
    if kv and kv:type() == "keyed_element" and is(kv:named_child(0), p) then
      return "write"
    end
  end

  -- `obj.Field = ...`, `obj.Field++`
  if pt == "selector_expression" and is(p:field("field")[1], node) then
    node, p = p, p:parent()
    if not p then
      return
    end
  end
  if p:type() == "inc_statement" or p:type() == "dec_statement" then
    return "write"
  end
  if p:type() == "expression_list" then
    local stmt = p:parent()
    if
      stmt
      and (stmt:type() == "assignment_statement" or stmt:type() == "short_var_declaration")
      and is(stmt:field("left")[1], p)
    then
      return "write"
    end
  end
end

-- Returns a function(filename, row, col) -> kind, parsing each file once.
local function make_classifier(lang, classify)
  local cache = {}

  local function tree(filename)
    if cache[filename] == nil then
      cache[filename] = false
      local buf = vim.fn.bufnr(filename)
      local ok, root, src
      if buf > 0 and vim.api.nvim_buf_is_loaded(buf) then
        -- loaded buffers may have unsaved changes
        ok, root = pcall(function()
          return vim.treesitter.get_parser(buf, lang):parse()[1]:root()
        end)
        src = buf
      else
        local f = io.open(filename, "r")
        if f then
          src = f:read("*a")
          f:close()
          ok, root = pcall(function()
            return vim.treesitter.get_string_parser(src, lang):parse()[1]:root()
          end)
        end
      end
      if ok and root then
        cache[filename] = { root = root, src = src }
      end
    end
    return cache[filename]
  end

  return function(filename, row, col)
    local t = tree(filename)
    if not t then
      return
    end
    local node = t.root:named_descendant_for_range(row, col, row, col)
    return node and classify(node, t.src)
  end
end

local classifiers = {
  go = { lang = "go", classify = classify_go },
}

function M.references()
  local tele = require("telescope.builtin")
  local spec = classifiers[vim.bo.filetype]
  if not spec then
    return tele.lsp_references()
  end

  local opts = {}
  local classify = make_classifier(spec.lang, spec.classify)
  local base = require("telescope.make_entry").gen_from_quickfix(opts)

  opts.entry_maker = function(item)
    local entry = base(item)
    if not entry then
      return
    end
    local kind = classify(item.filename, item.lnum - 1, item.col - 1)
    local tag = tags[kind] or untagged
    entry.ref_rank = tag.rank
    if kind then
      entry.ordinal = kind .. " " .. entry.ordinal
    end

    local display = entry.display
    entry.display = function(e)
      local str, hls = display(e)
      local prefix = tag.text .. " "
      local out = {}
      if tag.hl then
        table.insert(out, { { 0, #tag.text }, tag.hl })
      end
      for _, hl in ipairs(hls or {}) do
        table.insert(out, { { hl[1][1] + #prefix, hl[1][2] + #prefix }, hl[2] })
      end
      return prefix .. str, out
    end
    return entry
  end

  -- equal scores (e.g. empty prompt): tagged entries first, otherwise keep LSP order
  opts.tiebreak = function(current, existing)
    return (current.ref_rank or 2) < (existing.ref_rank or 2)
  end

  tele.lsp_references(opts)
end

return M
