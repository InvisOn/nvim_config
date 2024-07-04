return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function()
        vim.keymap.set("n", "<leader>xx", function()
            require("trouble").toggle("diagnostics")
        end, { desc = "Trouble toggle" })

        vim.keymap.set("n", "<leader>xq", function()
            require("trouble").toggle("quickfix")
        end, { desc = "Trouble toggle quickfix" })

        vim.keymap.set("n", "<leader>xl", function()
            require("trouble").toggle("loclist")
        end, { desc = "Trouble toggle loclist" })

        vim.keymap.set("n", "gR", function()
            require("trouble").toggle("lsp_references")
        end, { desc = "Trouble toggle LSP references" })
    end,
}
