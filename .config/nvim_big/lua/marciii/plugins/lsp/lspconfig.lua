local M = {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
}

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(
		bufnr,
		"n",
		"gD",
		"<cmd>lua vim.lsp.buf.declaration()<CR>",
		{ desc = "lspconfig: declaration", noremap = true, silent = true }
	)
	keymap(
		bufnr,
		"n",
		"gd",
		"<cmd>lua vim.lsp.buf.definition()<CR>",
		{ desc = "lspconfig: definition", noremap = true, silent = true }
	)
	keymap(
		bufnr,
		"n",
		"K",
		"<cmd>lua vim.lsp.buf.hover()<CR>",
		{ desc = "lspconfig: hover", noremap = true, silent = true }
	)
	keymap(
		bufnr,
		"n",
		"gI",
		"<cmd>lua vim.lsp.buf.implementation()<CR>",
		{ desc = "lspconfig: impementation", noremap = true, silent = true }
	)
	keymap(
		bufnr,
		"n",
		"gr",
		"<cmd>lua vim.lsp.buf.references()<CR>",
		{ desc = "lspconfig: references", noremap = true, silent = true }
	)
	keymap(
		bufnr,
		"n",
		"gl",
		"<cmd>lua vim.diagnostic.open_float()<CR>",
		{ desc = "lspconfig: diagnostic", noremap = true, silent = true }
	)
	keymap(
		bufnr,
		"n",
		"gt",
		"<cmd>lua vim.buf.lsp_type_definitions()<CR>",
		{ desc = "lspconfig: type definition", noremap = true, silent = true }
	)
	keymap(
		bufnr,
		"i",
		"<C-s>",
		"<cmd>lua vim.buf.signature_help()<CR>",
		{ desc = "lspconfig: signature", noremap = true, silent = true }
	)
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)

	if client.supports_method("textDocument/inlayHint") then
		-- vim.lsp.inlay_hint.enable(bufnr, true)
		vim.lsp.inlay_hint.enable()
	end
end

function M.common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return capabilities
end

M.toggle_inlay_hints = function()
	local bufnr = vim.api.nvim_get_current_buf()
	-- vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
	vim.lsp.inlay_hint.enable()
end

function M.config()
	-- keymaps
	vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Prev Diagnostic" })
	vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next Diagnostic" })

	vim.keymap.set(
		"n",
		"<leader>lf",
		"<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
		{ desc = "lspconfig: format" }
	)
	vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "lspconfig: rename" })
	vim.keymap.set(
		{ "v", "n" },
		"<leader>la",
		"<cmd>lua vim.lsp.buf.code_action()<cr>",
		{ desc = "lspconfig: code action" }
	)

	local servers = require("marciii.plugins.lsp.list.server-list").get_servers()

	local lspconfig = require("lspconfig")
	local icons = require("marciii.extra.icons")

	local default_diagnostic_config = {
		signs = {
			active = true,
			values = {
				{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
				{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
				{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
				{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
			},
		},
		virtual_text = false,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(default_diagnostic_config)

	for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	for _, server in pairs(servers) do
		local opts = {
			on_attach = M.on_attach,
			capabilities = M.common_capabilities(),
		}

		local require_ok, settings = pcall(require, "marciii.plugins.lsp.settings." .. server)
		if require_ok then
			opts = vim.tbl_deep_extend("force", settings, opts)
		end

		if server == "lua_ls" then
			require("lazydev").setup({})
		end

		lspconfig[server].setup(opts)
	end
end

return M
