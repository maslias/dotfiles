local M = {
	"bullets-vim/bullets.vim",
}

function M.config()
	vim.g.bullets_delete_last_bullet_if_empty = 1
end

return M
