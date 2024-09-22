return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd[[colorscheme tokyonight]]
            -- vim.cmd[[colorscheme tokyonight-night]]
            -- vim.cmd[[colorscheme tokyonight-storm]]
            -- vim.cmd[[colorscheme tokyonight-day]]
            -- https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
            vim.o.termguicolors = true
            vim.cmd([[colorscheme tokyonight-moon]])
        end,
    },
}
