return {
	"nanozuki/tabby.nvim",
	config = function()
		vim.o.showtabline = 2
		local function set_inactive_hl()
			vim.api.nvim_set_hl(0, "TabbyInactive", { fg = "#c8d3f5", bg = "#3b4261" })
		end
		set_inactive_hl()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_inactive_hl })
		local theme = {
			fill = "TabLineFill", -- tabline background
			head = "TabLine", -- head element highlight
			current = "TabLineSel", -- current buffer/tab highlight
			other = "TabbyInactive", -- other buffer/tab highlight (brighter than TabLine)
		}
		-- Listed buffers on the left, tab pages on the right (only when more than one tab exists).
		require("tabby").setup({
			line = function(line)
				local tabs = line.tabs()
				return {
					line.bufs().foreach(function(buf)
						local hl = buf.is_current() and theme.current or theme.other
						return {
							line.sep("", hl, theme.fill),
							buf.file_icon(),
							buf.name(),
							buf.is_changed() and "●" or "",
							line.sep("", hl, theme.fill),
							hl = hl,
							margin = " ",
						}
					end),
					line.spacer(),
					#vim.api.nvim_list_tabpages() > 1
							and tabs.foreach(function(tab)
								local hl = tab.is_current() and theme.current or theme.other
								return {
									line.sep("", hl, theme.fill),
									tab.number(),
									line.sep("", hl, theme.fill),
									hl = hl,
									margin = " ",
								}
							end)
						or "",
					hl = theme.fill,
				}
			end,
			option = {
				buf_name = {
					mode = "unique", -- or 'relative', 'tail', 'shorten'
				},
			},
		})
	end,
}