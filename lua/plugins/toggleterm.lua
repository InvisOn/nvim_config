return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                direction = "float",
                open_mapping = [[<c-\>]],
            })

            vim.keymap.set("n", "<C-\\>", function()
                vim.cmd(":ToggleTerm")
            end)
            vim.keymap.set("t", "<C-\\>", function()
                vim.cmd(":ToggleTerm")
            end)
        end,
    },
    -- {
    --     "ryanmsnyder/toggleterm-manager.nvim",
    --     dependencies = {
    --         "akinsho/toggleterm.nvim",
    --         "nvim-telescope/telescope.nvim",
    --         "nvim-lua/plenary.nvim",
    --     },
    --     config = function()
    --         local toggleterm_manager = require("toggleterm-manager")
    --         local actions = toggleterm_manager.actions
    --
    -- vim.keymap.set('n', '`', ':Telescope toggleterm_manager<CR>')
    --         toggleterm_manager.setup {
    --             mappings = {
    --                 i = {
    --                     ["<CR>"] = { action = actions.toggle_term, exit_on_action = true },
    --                     ["<Del>"] = { action = actions.delete_term, exit_on_action = false },
    --                     ["<C-r>"] = { action = actions.rename_term, exit_on_action = false },
    --                     ["<C-n>"] = { action = actions.create_and_name_term, exit_on_action = false }
    --                 },
    --             },
    --         }
    --     end
    -- }
}
