local M = {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		notifier = { enabled = true },
		notifiy = { enabled = true },
		bigfile = { enabled = true },
		debug = { enabled = true },
		input = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		rename = { enabled = true },
	},

	keys = {
		{
			"<leader>fn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>lrf",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "snacks: rename file",
		},

		{
			"<leader>x",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
	},
}

-- function M.config() end
return M
