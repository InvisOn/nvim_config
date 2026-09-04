return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- Install parsers up front
			require("nvim-treesitter").install({
				"bash",
				"c",
				-- "haskell",
				"html",
				"lua",
				"markdown",
				"markdown_inline",
				"nu",
				-- "ocaml",
				"python",
				"roc",
				"rust",
				-- "tsx",
				"vim",
				"vimdoc",
				"yaml",
				"zig",
				-- "c++",
				-- "lean",
			})

			local indent_supported = {
				bash = true,
				c = true,
				html = true,
				lua = true,
				markdown = true,
				python = true,
				rust = true,
				vim = true,
				yaml = true,
				zig = true,
				-- roc intentionally absent
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function()
					pcall(vim.treesitter.start)
					if indent_supported[vim.bo.filetype] then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
			-- -- Enable highlighting + treesitter indent per filetype
			-- vim.api.nvim_create_autocmd("FileType", {
			-- 	pattern = "*",
			-- 	callback = function()
			-- 		pcall(vim.treesitter.start)
			-- 		if not vim.b.did_indent then
			-- 			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			-- 		end
			-- 	end,
			--
			-- 	-- callback = function()
			-- 	-- 	pcall(vim.treesitter.start)
			-- 	-- 	vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			-- 	-- end,
			--
			-- 	-- callback = function(args)
			-- 	-- 	local ft = vim.bo[args.buf].filetype
			-- 	-- 	local lang = vim.treesitter.language.get_lang(ft)
			-- 	-- 	if lang and vim.treesitter.language.add(lang) then
			-- 	-- 		vim.treesitter.start(args.buf, lang)
			-- 	-- 		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			-- 	-- 	end
			-- 	-- end,
			-- })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			local sel = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			-- Text object selections
			local select_maps = {
				af = "@function.outer",
				["if"] = "@function.inner",
				ac = "@class.outer",
				ic = "@class.inner",
			}
			for lhs, query in pairs(select_maps) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					sel.select_textobject(query, "textobjects")
				end)
			end

			-- Motion mappings
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				move.goto_next_start("@class.inner", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				move.goto_next_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				move.goto_next_end("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				move.goto_previous_start("@class.inner", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				move.goto_previous_end("@class.outer", "textobjects")
			end)
		end,
	},
}
