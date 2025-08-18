local M = {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
}

function M.config()
		local highlight = {
			"Light",
			"Dark",
		}
		local hooks = require("ibl.hooks")
	local colors = require("cyberdream.colors")
	local t = colors.default
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			-- vim.api.nvim_set_hl(0, "Light", { fg = t.bgHighlight})
			-- vim.api.nvim_set_hl(0, "Dark", { fg = t.bgAlt})
			vim.api.nvim_set_hl(0, "Light", { fg = t.bgHighlight})
			vim.api.nvim_set_hl(0, "Dark", { fg = t.grey})
		end)
		vim.g.rainbow_delimiters = { highlight = highlight }
		local ibl = require("ibl")
		ibl.setup({
			indent = { highlight = highlight, char = "┊" },
			scope = { enabled = false },
		})
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end

return M


