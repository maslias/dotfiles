local M = {}

function M.get_servers()
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
	return servers
end

function M.get_tools()
	local tools = {
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
	return tools
end

return M
