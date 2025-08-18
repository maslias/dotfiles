local M = {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "pbogut/vim-dadbod-ssh", lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},

	event = "VeryLazy",
}

function M.config()
	vim.keymap.set("n", "<leader>db", "<cmd> DBUIToggle<cr>", { desc = "DB: Toggle" })
	vim.g.db_ui_use_nerd_fonts = 1
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "dbout",
		callback = function()
			vim.wo.foldenable = false
		end,
	})
end

return M
