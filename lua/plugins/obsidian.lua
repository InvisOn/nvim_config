return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    -- if you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- e.g. "bufreadpre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "bufreadpre /home/aj/Vault/*.md",
    "bufnewfile /home/aj/Vault/*.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    ui = {
      enable = false,
    },
    workspaces = {
      {
        name = "personal",
        path = "/home/aj/Vault",
      },
    },

    -- see below for full list of options 👇
  },
}
