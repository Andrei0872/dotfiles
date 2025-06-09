local dap = require("dap")
local dapui = require("dapui")
local utils = require("dap.utils")

require("overseer").setup()

-- Set logging levels to debug why adapters are not working
-- logs are saved in ~.cache/nvim/dap.log.
dap.set_log_level("DEBUG")

dap.adapters = {
  ["pwa-node"] = {
    type = "server",
    port = "${port}",
    executable = {
      command = "js-debug-adapter",
      args = {
        "${port}",
      },
    },
  },
  ["codelldb"] = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
      args = { "--port", "${port}" },
    },
  },
  ["nlua"] = function(callback, conf)
    local adapter = {
      type = "server",
      host = conf.host or "127.0.0.1",
      port = conf.port or 8086,
    }
    if conf.start_neovim then
      local dap_run = dap.run
      dap.run = function(c)
        adapter.port = c.port
        adapter.host = c.host
      end
      require("osv").run_this()
      dap.run = dap_run
    end
    callback(adapter)
  end,
  ["go"] = function(callback, conf)
    if conf.request == "attach" and (conf.mode == "remote" or conf.mode == "exec") then
      local port = conf.port
      callback({
        type = "server",
        port = assert(port, "`connect.port` is required"),
        host = conf.host or "127.0.0.1",
      })
    else
      callback({
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      })
    end
  end,
}

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to process ID",
      processId = utils.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch & Debug Chrome",
      url = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({
            prompt = "Enter URL: ",
            default = "http://localhost:3000",
          }, function(url)
            if url == nil or url == "" then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end,
      webRoot = vim.fn.getcwd(),
      protocol = "inspector",
      sourceMaps = true,
      userDataDir = false,
    },
    {
      name = "----- ↓ launch.json configs ↓ -----",
      type = "",
      request = "launch",
    },
  }
end
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Run this file",
    start_neovim = {},
  },
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance (port = 8086)",
    port = 8086,
  },
}

dap.configurations.rust = {
  {
    type = "codelldb",
    request = "launch",
    name = "Launch file",
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
  },
}

dap.configurations.go = {
  {
    type = "go",
    name = "Debug file",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "[Docker] Attach to debug server",
    request = "attach",
    host = "127.0.0.1",
    port = "2345",
    mode = "remote",
    cwd = vim.fn.getcwd(),
    substitutePath = {
      {
        from = "/home/andu/go/src/github.com/docker/docker",
        to = "/go/src/github.com/docker/docker",
      },
    },
  },
  {
    type = "go",
    name = "Attach to debug server",
    request = "attach",
    processId = utils.pick_process,
    mode = "local",
    cwd = vim.fn.getcwd(),
    custom = "foo",
  },
  {
    type = "go",
    name = "[kube-apiserver] Debug executable",
    request = "launch",
    mode = "exec",
    port = 31234,
    cwd = vim.fn.getcwd(),
    program = "_output/bin/kube-apiserver",
    outputMode = "remote",
    args = {
      "--authorization-mode=Node,RBAC",
      "--authorization-webhook-config-file=",
      "--authentication-token-webhook-config-file=",
      "--v=3",
      "--vmodule=",
      "--audit-policy-file=/tmp/local-up-cluster.sh.ijIL8C/kube-audit-policy-file",
      "--audit-log-path=/tmp/kube-apiserver-audit.log",
      "--cert-dir=/var/run/kubernetes",
      "--egress-selector-config-file=/tmp/local-up-cluster.sh.ijIL8C/kube_egress_selector_configuration.yaml",
      "--client-ca-file=/var/run/kubernetes/client-ca.crt",
      "--kubelet-client-certificate=/var/run/kubernetes/client-kube-apiserver.crt",
      "--kubelet-client-key=/var/run/kubernetes/client-kube-apiserver.key",
      "--service-account-key-file=/tmp/local-up-cluster.sh.ijIL8C/kube-serviceaccount.key",
      "--service-account-lookup=true",
      "--service-account-issuer=https://kubernetes.default.svc",
      "--service-account-jwks-uri=https://kubernetes.default.svc/openid/v1/jwks",
      "--service-account-signing-key-file=/tmp/local-up-cluster.sh.ijIL8C/kube-serviceaccount.key",
      "--enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,Priority,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,NodeRestriction",
      "--disable-admission-plugins=",
      "--admission-control-config-file=",
      "--bind-address=0.0.0.0",
      "--secure-port=6443",
      "--tls-cert-file=/var/run/kubernetes/serving-kube-apiserver.crt",
      "--tls-private-key-file=/var/run/kubernetes/serving-kube-apiserver.key",
      "--storage-backend=etcd3",
      "--storage-media-type=application/vnd.kubernetes.protobuf",
      "--etcd-servers=http://127.0.0.1:2379",
      "--service-cluster-ip-range=10.0.0.0/24",
      "--feature-gates=AllAlpha=false",
      "--emulated-version=",
      "--external-hostname=localhost",
      "--requestheader-username-headers=X-Remote-User",
      "--requestheader-group-headers=X-Remote-Group",
      "--requestheader-extra-headers-prefix=X-Remote-Extra-",
      "--requestheader-client-ca-file=/var/run/kubernetes/request-header-ca.crt",
      "--requestheader-allowed-names=system:auth-proxy",
      "--proxy-client-cert-file=/var/run/kubernetes/client-auth-proxy.crt",
      "--proxy-client-key-file=/var/run/kubernetes/client-auth-proxy.key",
      "--cors-allowed-origins=//127.0.0.1(:[0-9]+)?$,//localhost(:[0-9]+)?$",
    },
  },
  {
    type = "go",
    name = "[kube-controller-manager] Debug executable",
    request = "launch",
    mode = "exec",
    port = 31235,
    cwd = vim.fn.getcwd(),
    program = "_output/bin/kube-controller-manager",
    outputMode = "remote",
    args = {
      "--v=3",
      "--vmodule=",
      "--service-account-private-key-file=/tmp/local-up-cluster.sh.dMp5uY/kube-serviceaccount.key",
      "--service-cluster-ip-range=10.0.0.0/24",
      "--root-ca-file=/var/run/kubernetes/server-ca.crt",
      "--cluster-signing-cert-file=/var/run/kubernetes/client-ca.crt",
      "--cluster-signing-key-file=/var/run/kubernetes/client-ca.key",
      "--enable-hostpath-provisioner=false",
      "--pvclaimbinder-sync-period=15s",
      "--feature-gates=AllAlpha=false",
      "--emulated-version=",
      "--cloud-provider=",
      "--cloud-config=",
      "--configure-cloud-routes=true",
      "--authentication-kubeconfig",
      "/var/run/kubernetes/controller.kubeconfig",
      "--authorization-kubeconfig",
      "/var/run/kubernetes/controller.kubeconfig",
      "--kubeconfig",
      "/var/run/kubernetes/controller.kubeconfig",
      "--use-service-account-credentials",
      "--controllers=*",
      "--leader-elect=false",
      "--cert-dir=/var/run/kubernetes",
      "--master=https://localhost:6443",
    },
  },
  {
    type = "go",
    name = "[kube-scheduler] Debug executable",
    request = "launch",
    mode = "exec",
    port = 31236,
    cwd = vim.fn.getcwd(),
    program = "_output/bin/kube-scheduler",
    outputMode = "remote",
    args = {
      "--v=3",
      "--config=/tmp/local-up-cluster.sh.Ihd2CJ/kube-scheduler.yaml",
      "--feature-gates=AllAlpha=false",
      "--emulated-version=",
      "--authentication-kubeconfig",
      "/var/run/kubernetes/scheduler.kubeconfig",
      "--authorization-kubeconfig",
      "/var/run/kubernetes/scheduler.kubeconfig",
      "--master=https://localhost:6443",
    },
  },
  {
    type = "go",
    name = "[kubelet] Debug executable",
    request = "launch",
    mode = "exec",
    port = 31237,
    cwd = vim.fn.getcwd(),
    program = "_output/bin/kubelet",
    outputMode = "remote",
    args = {
      "--v=3",
      "--vmodule=",
      "--hostname-override=127.0.0.1",
      "--cloud-provider=",
      "--bootstrap-kubeconfig=/var/run/kubernetes/kubelet.kubeconfig",
      "--kubeconfig=/var/run/kubernetes/kubelet-rotated.kubeconfig",
      "--config=/tmp/local-up-cluster.sh.ttwG44/kubelet.yaml",
    },
  },
  {
    type = "go",
    name = "Debug test",
    request = "attach",
    mode = "remote",
    cwd = vim.fn.getcwd(),
    outputMode = "remote",
    port = 31239,
  },
}

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
  controls = {
    icons = {
      pause = "⏸",
      play = "▶",
      step_into = "⏎",
      step_over = "⏭",
      step_out = "⏮",
      step_back = "b",
      run_last = "▶▶",
      terminate = "⏹",
      disconnect = "⏏",
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

local map = function(keys, func, desc)
  if desc then
    desc = "[D]ebugger: " .. desc
  end
  if keys then
    keys = "<leader>d" .. keys
  end
  vim.keymap.set("n", keys, func, { desc = desc })
end

map("c", dap.continue, "[C]ontinue")
-- TODO: is this really needed?
-- map("a", function()
--   require("dap").continue({ before = get_args })
-- end, "Run with [A]rgs")
map("i", dap.step_into, "Step [I]nto")
map("O", dap.step_out, "Step [O]ut")
map("o", dap.step_over, "Step Over")
map("C", function()
  require("dap").run_to_cursor()
end, "Run to [C]ursor")
map("g", function()
  require("dap").goto_()
end, "[G]o to line (no execute)")
map("b", dap.toggle_breakpoint, "Toggle [B]reakpoint")
map("B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Set [B]reakpoint")
map("j", dap.down, "Down")
map("k", dap.up, "Up")
map("l", dap.run_last, "Run [L]ast")
map("p", dap.pause, "Pause")
map("r", function()
  dap.repl.toggle()
end, "Toggle REPL")
map("s", dap.session, "Session")
map("t", dap.terminate, "Terminate")
map("w", function()
  require("dap.ui.widgets").hover()
end, "Widgets")

map("u", function()
  dapui.toggle({
    -- Always open the nvim dap ui in the default sizes
    reset = true,
  })
end, "Toggle [U]I")
map("e", function()
  dapui.eval()
end, "Eval")

vim.api.nvim_set_keymap(
  "n",
  "<F5>",
  [[:lua require"osv".launch({port = 8086})<CR>]],
  { noremap = true }
)
