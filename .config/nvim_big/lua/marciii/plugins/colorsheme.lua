local M = {
	"scottmckendry/cyberdream.nvim",
	-- "maxmx03/fluoromachine.nvim",
	lazy = false,
	priority = 1000,
}

function M.config()
	local colors = require("cyberdream.colors")
	local t = colors.default
	require("cyberdream").setup({
		italic_comments = true,
		hide_fillchars = true,
		borderless_telescope = false,
		terminal_colors = true,
		-- transparent = true,
		theme = {
			highlights = {
				LineNr = { fg = t.grey },
				CursorLineNr = { fg = t.yellow },
				TelescopeBorder = { fg = t.blue },
                Visual = {  bg = t.grey},


			},
		},
	})
	vim.cmd.colorscheme("cyberdream")
	-- require("fluoromachine").setup({
	-- 	glow = false,
	-- 	theme = "fluoromachine",
 --        transparent = 'full'
	-- })
	-- vim.cmd.colorscheme("fluoromachine")
end

return M
