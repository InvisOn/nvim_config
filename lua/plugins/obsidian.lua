return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    "bufreadpre " .. vim.fn.expand("~") .. "/Vault/*.md",
    "bufnewfile " .. vim.fn.expand("~") .. "/Vault/*.md",
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

    disable_frontmatter = true, -- Otherwise it rearranges the frontmatter.
  },
}
