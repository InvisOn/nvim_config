return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
        local highlight = { "light" }
        local hooks = require "ibl.hooks"
        hooks.register(
            hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "light", { fg = "#4E567E" })
            end
        )
        require("ibl").setup(
            {
                scope = {
                    highlight = highlight,
                    show_start = false,
                    show_end = false
                },
                indent = {
                    char = "▏"

                }
            }
        )
    end
}
