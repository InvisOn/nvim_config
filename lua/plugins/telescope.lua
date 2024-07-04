return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Telescope find files" })

            vim.keymap.set("n", "<Leader>lg", builtin.live_grep, { desc = "Telescope live grep" })

            vim.keymap.set("n", "<Leader><Tab>", function()
                builtin.buffers({ show_all_buffers = false, sort_mru = true })
            end, { desc = "Telescope buffers" })

            vim.keymap.set("n", "<Leader>kk", builtin.keymaps, { desc = "Telescope keymaps" })

            vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help tags" })
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
        cmake --build build --config Release && \
        cmake --install build --prefix build",
        config = function()
            require("telescope").setup({
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })
            require("telescope").load_extension("fzf")
        end,
    },
}
