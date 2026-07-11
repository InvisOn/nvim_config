return {
  {
    "rmagatti/auto-session",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("auto-session").setup({
        suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        log_level = "error",
        post_restore_cmds = {
          function()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                vim.fn.bufload(bufnr)
              end
            end
          end,
        },
      })

      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

      vim.keymap.set("n", "<leader>ss", ":Telescope session-lens<CR>", { desc = "Session Lens" })
      vim.keymap.set("n", "<leader>sd", ":Autosession delete<CR>", { desc = "Delete Session Lens" })
    end,
  },
}
