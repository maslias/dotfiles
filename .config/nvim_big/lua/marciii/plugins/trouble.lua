local M = {
	"folke/trouble.nvim",
	opts = {}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",

	keys = {
		{
			"<leader>lT",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "trouble: diagnostics (trouble)",
		},
		{
			"<leader>lt",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "trouble: buffer diagnostics (trouble)",
		},
		{
			"<leader>lcs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "trouble: symbols (trouble)",
		},
		{
			"<leader>lcl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "trouble: lsp definitions / references / ... (trouble)",
		},
		{
			"<leader>lq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "trouble: quickfix list (trouble)",
		},
		{
			"<leader>ll",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "trouble: location list (trouble)",
		},
		{
			"[t",
			function()
				if require("trouble").is_open() then
					require("trouble").prev({ skip_groups = true, jump = true })
				end
			end,
			{ desc = "trouble: prev item" },
		},
		{
			"]t",
			function()
				if require("trouble").is_open() then
					require("trouble").next({ skip_groups = true, jump = true })
				end
			end,
			{ desc = "trouble: next item" },
		},
	},
}

return M
