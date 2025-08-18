return {
	settings = {
		json = {
			-- schemas = require("schemastore").json.schemas(),
			schemas = vim.list_extend({
				{
					description = "pyright config",
					fileMatch = { "pyrightconfig.json" },
					name = "pyrightconfig.json",
					url = "https://raw.githubusercontent.com/microsoft/pyright/main/packages/vscode-pyright/schemas/pyrightconfig.schema.json",
				},
			}, require("schemastore").json.schemas({})),
		},
	},
	setup = {
		commands = {
			Format = {
				function()
					vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
				end,
			},
		},
	},
}
