return {
    -- disables hungry features for files larger than 1MB
    {
        "LunarVim/bigfile.nvim",
        opts = {
            filesize = 1, -- MiB
            -- keep LSP and treesitter so big source files still get zls and highlighting
            features = { "indent_blankline", "illuminate", "matchparen" },
        },
    },
}
