return {
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gs = require("gitsigns")
                    local function map(lhs, rhs, desc)
                        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
                    end

                    -- jump between hunks; in diff mode keep the built-in ]c / [c
                    map("]c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gs.nav_hunk("next")
                        end
                    end, "Next git hunk")
                    map("[c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gs.nav_hunk("prev")
                        end
                    end, "Previous git hunk")

                    map("<leader>gp", gs.preview_hunk_inline, "Preview git hunk inline")

                    -- reset hunk under cursor; in visual mode reset only the selected lines
                    map("<leader>gu", gs.reset_hunk, "Reset git hunk")
                    vim.keymap.set("v", "<leader>gu", function()
                        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { buffer = bufnr, desc = "Reset selected git lines" })

                    -- whole-buffer inline diff: line colors, word diff, deleted lines
                    map("<leader>gi", function()
                        local on = not require("gitsigns.config").config.linehl
                        gs.toggle_linehl(on)
                        gs.toggle_word_diff(on)
                        gs.toggle_deleted(on)
                    end, "Toggle inline git diff")
                end,
            })
        end,
    },
    {
        "tpope/vim-fugitive",
    },
}
