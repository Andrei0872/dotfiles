# Neovim plugin changes

- Never run a global/full plugin update (`:Lazy sync`, `:Lazy update`, `:Lazy! sync`, or equivalent) to install or verify a single new plugin. This silently bumps every plugin in `nvim/lazy-lock.json` to its latest commit as a side effect, which has previously broken the user's Neovim startup (e.g. `nvim-treesitter` mid-rewrite) and required deleting the plugin cache and reinstalling everything to recover.
- To add a new plugin, add its spec and only install that plugin: `:Lazy install <plugin-name>` (or headless: `nvim --headless -u nvim/init.lua "+Lazy! install <plugin-name>" "+qa"`). This does not touch already-installed plugins.
- Never modify `nvim/lazy-lock.json` for plugins you did not intentionally add/update. If it changes unexpectedly after any operation, check `git diff -- nvim/lazy-lock.json` before proceeding and revert unrelated entries.
- If a genuine full update is ever wanted, that is a deliberate, user-requested action — confirm with the user first since it's hard to reverse and can break the working config.
