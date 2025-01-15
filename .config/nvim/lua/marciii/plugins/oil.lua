local M = {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
}

function M.config()
	local oil = require("oil")
	oil.setup({
		default_file_explorer = false,
		skip_confirm_for_simple_edits = true,
		float = {
			max_height = 20,
			max_width = 60,
		},
		view_options = {
			show_hidden = true,
			natural_order = true,
			is_always_hidden = function(name, _)
				return name == ".." or name == ".git"
			end,
		},
	})
	vim.keymap.set("n", "<leader>-", function()
		oil.toggle_float()
	end)
end

return M
