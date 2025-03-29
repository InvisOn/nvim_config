return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- {
      -- 	"nvim-telescope/telescope-live-grep-args.nvim",
      -- 	version = "^1.0.0",
      -- },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
      local builtin = require("telescope.builtin")

      -- vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set(
        "n",
        "<Leader>ff",
        ':lua require"telescope.builtin".find_files({ hidden = true })<CR>',
        { desc = "Telescope find files" }
      )

      vim.keymap.set("n", "<Leader>lg", builtin.live_grep, { desc = "Telescope live grep" })

      vim.keymap.set("n", "<Leader><Tab>", function()
        builtin.buffers({ show_all_buffers = false, sort_mru = true })
      end, { desc = "Telescope buffers" })

      vim.keymap.set("n", "<Leader>mm", builtin.keymaps, { desc = "Telescope keymaps" })

      vim.keymap.set("n", "<Leader>yy", builtin.registers, { desc = "Telescope yank history" })

      vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help tags" })

      local telescope = require("telescope")

      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            ".git/",
          },
        },
      })

      telescope.load_extension("ui-select")
    end,
  },
  -- {
  -- 	"nvim-telescope/telescope-live-grep-args.nvim",
  -- 	version = "^1.0.0",
  -- 	dependencies = {
  -- 		"nvim-telescope/telescope.nvim",
  -- 	},
  -- 	config = function()
  -- 		local telescope = require("telescope")
  -- 		local lga_actions = require("telescope-live-grep-args.actions")
  --
  -- 		telescope.setup({
  -- 			extensions = {
  -- 				-- ["ui-select"] = {
  -- 				--   require("telescope.themes").get_dropdown({}),
  -- 				-- },
  -- 				live_grep_args = {
  -- 					auto_quoting = true,
  -- 					mappings = {
  -- 						i = {
  -- 							["<C-k>"] = lga_actions.quote_prompt(),
  -- 							["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
  -- 							-- freeze the current list and start a fuzzy search in the frozen list
  -- 							["<C-space>"] = lga_actions.to_fuzzy_refine,
  -- 						},
  -- 					},
  -- 				},
  -- 			},
  -- 		})
  --
  -- 		-- telescope.load_extension("ui-select")
  -- 		telescope.load_extension("live_grep_args")
  -- 	end,
  -- },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    config = function()
      require("telescope").setup({
        extensions = {
          ["fzf"] = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
    end,
  },
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local undotree = require("undotree")

      undotree.setup({
        float_diff = true,  -- using float window previews diff, set this `true` will disable layout option
        layout = "left_bottom", -- "left_bottom", "left_left_bottom"
        position = "left",  -- "right", "bottom"
        ignore_filetype = {
          "undotree",
          "undotreeDiff",
          "qf",
          "TelescopePrompt",
          "spectre_panel",
          "tsplayground",
        },
        window = {
          winblend = 0,
        },
        keymaps = {
          ["j"] = "move_next",
          ["k"] = "move_prev",
          ["gj"] = "move2parent",
          ["J"] = "move_change_next",
          ["K"] = "move_change_prev",
          ["<cr>"] = "action_enter",
          ["p"] = "enter_diffbuf",
          ["q"] = "quit",
        },
      })
    end,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },
}
