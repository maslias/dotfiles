local M = {
	"stevanmilic/nvim-lspimport",
}

function M.config()
	vim.keymap.set("n", "<leader>li", require("lspimport").import, { noremap = true })
end

return M
