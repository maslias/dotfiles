local M = {
	"tzachar/highlight-undo.nvim",

	dependencies = {
		"mbbill/undotree",
	},

	event = "VeryLazy",
	opts = {},
}

function M.config()
	vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR><C-w>h", { desc = "toggle undotree" })
end
return M
