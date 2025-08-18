local M = {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"vrischmann/tree-sitter-templ",
	},
}

function M.config()
	local treesitter = require("nvim-treesitter.configs")

	treesitter.setup({
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		autotag = { enable = true },

		ensure_installed = {
			"json",
			"html",
			"css",
			"bash",
			"lua",
			"php",
			"xml",
			"sql",
			"go",
			"http",
			"hurl",
			"templ",
			"dockerfile",
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-v>i",
				node_incremental = "<C-v>i",
				scope_incremental = false,
				node_decremental = "<C-v>d",
			},
		},
		auto_install = true,
	})

	-- local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
	-- ts_context_commentstring = {
	-- 	enable_autocmd = false,
	-- }
	vim.g.skip_ts_context_commentstring_module = true
end

return M
