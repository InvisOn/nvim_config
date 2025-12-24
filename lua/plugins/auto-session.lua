return {
  {
    "rmagatti/auto-session",
    dependencies = {
      "nvim-telescope/telescope.nvim", -- Only needed if you want to use sesssion lens
    },
    config = function()
      require("auto-session").setup({
        enabled = vim.env.KITTY_SCROLLBACK_NVIM ~= 'true',
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/", "/tmp" },
        -- log_level = "error",
        cwd_change_handling = {
          restore_upcoming_session = true,   -- Disabled by default, set to true to enable
          post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
            require("lualine").refresh()     -- refresh lualine so the new session name is displayed in the status bar
          end,
        },
      })

      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

      vim.keymap.set("n", "<leader>ss", ":Telescope session-lens<CR>", { desc = "Session Lens" })
      vim.keymap.set("n", "<leader>sd", ":Autosession delete<CR>", { desc = "Delete Session Lens" })
    end,
  },
}
