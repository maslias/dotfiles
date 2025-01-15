local M = {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	config = true,
}

function M.config()
	require("colorizer").setup({
		user_default_options = {
			tailwind = true,
		},
	})
end

return M
