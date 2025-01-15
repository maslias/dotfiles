local M = {
	"iamcco/markdown-preview.nvim",
	ft = { "markdown" },
	build = "cd app && yarn install",
	config = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
}

function M.config()
	vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "markdown preview" })
end
return M
