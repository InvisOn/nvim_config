return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<Leader>p", function()
                builtin.find_files()
            end)
            vim.keymap.set("n", "<Leader>f", function()
                builtin.live_grep()
            end)
            vim.keymap.set("n", "<Leader><Tab>", function()
                builtin.buffers({ show_all_buffers = false, sort_mru = true })
            end)
            vim.keymap.set("n", "<Leader>k", function()
                builtin.keymaps()
            end)
            vim.api.nvim_create_user_command("Help", function()
                builtin.live_grep({ cwd = "/tmp/.mount_nvim*/usr/share/nvim/runtime/doc/" })
            end, {})
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
