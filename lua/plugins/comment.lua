return {
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {
      signs = false,
      keywords = {
        NEXT_ACTION = {
          color = "#c84cf3",
          alt = { "NA" },
        },
      },
    },
  },
}
