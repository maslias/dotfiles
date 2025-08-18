local M = {
	"olexsmir/gopher.nvim",
	ft = "go",
	-- branch = "develop", -- if you want develop branch
	-- keep in mind, it might break everything
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
	},
	-- (optional) will update plugin's deps on every update
	build = function()
		vim.cmd.GoInstallDeps()
	end,
	---@type gopher.Config
	opts = {},
}

function M.config()
	vim.keymap.set("n", "<leader>gi", vim.cmd.GoImpl, { desc = "Gopher: interface implementation" })
	vim.keymap.set("n", "<leader>gta", "<cmd>GoTagAdd json<CR>", { desc = "Gopher: Add json tags in structure" })
	vim.keymap.set("n", "<leader>gtr", "<cmd>GoTagRm json<CR>", { desc = "Gopher: Remove json tags in structure" })
	vim.keymap.set("n", "<leader>gmt", "<cmd>GoMod tidy<CR>", { desc = "Gopher: go mod tidy" })
	vim.keymap.set("n", "<leader>ge", vim.cmd.GoIfErr, { desc = "Gopher: snippet if err" })
	vim.keymap.set("n", "<leader>gg", function()
		local repo = string.gsub(vim.fn.expand("<cWORD>"), '"', "")
		vim.cmd.GoGet(repo)
	end, { desc = "replac string under cursor" })

	require("gopher").setup({
		commands = {
			go = "go",
			gomodifytags = "gomodifytags",
			gotests = "gotests",
			impl = "impl",
			iferr = "iferr",
			dlv = "dlv",
		},
		gotests = {
			-- gotests doesn't have template named "default" so this plugin uses "default" to set the default template
			template = "default",
			-- path to a directory containing custom test code templates
			template_dir = nil,
			-- switch table tests from using slice to map (with test name for the key)
			-- works only with gotests installed from develop branch
			named = false,
		},
		gotag = {
			transform = "snakecase",
		},
	})
end

return M
