# AGENTS.md

Personal Neovim config, written in Lua and managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Layout

- `init.lua`: bootstraps lazy.nvim, then loads `keymaps`, the plugins, `nvim-options` and `commands`, in that order. Keymaps load before plugins so the leader key is set first.
- `lua/keymaps.lua`: global keymaps. Leader and localleader are both `<Space>`.
- `lua/nvim-options.lua`: editor options.
- `lua/commands.lua`: user commands and autocommands.
- `lua/plugins/*.lua`: one plugin spec per file. lazy.nvim loads every file in this folder through `require("lazy").setup("plugins")`.
- `lua/plugins/*.lua.old`: disabled plugins. lazy.nvim skips them. Leave them alone unless asked.
- `ftplugin/*.lua`: settings for each filetype.
- `lazy-lock.json`: pinned plugin versions. Only lazy.nvim should change it, so don't edit it by hand.

## Conventions

- Each plugin file returns a lazy.nvim spec table. Do the setup inside `config = function() ... end`.
- Give every keymap a `desc` so it shows up in Telescope's keymap search (`<leader>mm`).
- Keymaps that belong to a plugin go in that plugin's file. Buffer-local maps go in the plugin's `on_attach`, as in `lua/plugins/git.lua`.
- Before adding a keymap, grep for the key to make sure it isn't already taken, for example `grep -rn '<leader>gr' lua`.
- Current `<leader>` groups:
  - `g`: git and grep
  - `f`: find
  - `q`: closing buffers
  - `t`: Telescope extras
- Indentation is mixed: most files use tabs, but `git.lua` uses 4 spaces. Match the file you're editing.
- Formatting runs on save through conform.nvim and falls back to the LSP formatter.

## Checking changes

There are no tests. After editing, check that the config still loads without errors:

```sh
nvim --headless "+qa"
```

Ask the user before running `:Lazy sync` or `:Lazy update`, because those change `lazy-lock.json`.

## Git

Commit messages are short and in the imperative, e.g. "Add Telescope git keymaps". Commit only when the user asks.
