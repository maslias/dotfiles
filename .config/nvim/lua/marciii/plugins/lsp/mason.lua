local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
}

function M.config()
	local servers = require("marciii.plugins.lsp.list.server-list").get_servers()
	local tools = require("marciii.plugins.lsp.list.server-list").get_tools()

	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		automatic_installation = false,
	})

	require("mason-lspconfig").setup({
		ensure_installed = servers,
	})

	require("mason-tool-installer").setup({
		ensure_installed = tools,
	})
end

return M
