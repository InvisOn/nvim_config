return {
  "stevearc/oil.nvim",
  lazy = false,
  config = function()
    require("oil").setup({
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
    })
    vim.keymap.set("n", "<leader>b", ":Oil<CR>", { desc = "Open Oilbuffer picker" })
  end,
}
