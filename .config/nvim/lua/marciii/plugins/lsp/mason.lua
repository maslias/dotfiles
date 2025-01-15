local M = {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
}

function M.config()
	local servers = {
		"lua_ls",
		"cssls",
		"html",
		"eslint",
		"bashls",
		"jsonls",
		"gopls",
		"intelephense",
		"lemminx",
		"templ",
		"htmx",
		"tailwindcss",
		"docker_compose_language_service",
		"pyright",
		"marksman",
	}

	local server_tools = {
		"prettier",
		"stylua",
		"fixjson",
		"phpcs",
		"php-cs-fixer",
		"shfmt",
		"xmlformatter",
		"gofumpt",
		"goimports-reviser",
		"golines",
		"mypy",
		"ruff",
		"black",
	}

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
		ensure_installed = server_tools,
	})
end

return M
