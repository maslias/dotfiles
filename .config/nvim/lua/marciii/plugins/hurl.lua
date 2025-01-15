local M = {
	"jellydn/hurl.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	ft = "hurl",
	opts = {
		-- Show debugging info
		debug = false,
		-- Show notification on run
		show_notification = false,
		-- Show response in popup or split
		mode = "split",
		-- Default formatter
		formatters = {
			json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
			html = {
				"prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
				"--parser",
				"html",
			},
			xml = {
				"tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
				"-xml",
				"-i",
				"-q",
			},
		},
		-- Default mappings for the response popup or split views
		mappings = {
			close = "q", -- Close the response popup or split view
			next_panel = "<C-n>", -- Move to the next response popup window
			prev_panel = "<C-p>", -- Move to the previous response popup window
		},
	},
	keys = {
		-- Run API request
		{ "<leader>cA", "<cmd>HurlRunner<CR>", desc = "hurl: run all requests" },
		{ "<leader>ca", "<cmd>HurlRunnerAt<CR>", desc = "hurl: run api request" },
		-- { "<leader>cte", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
		-- { "<leader>ctm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
		{ "<leader>cq", "<cmd>HurlVerbose<CR>", desc = "hurl: run api in verbose mode" },
		-- Run Hurl request in visual mode
		-- { "<leader>ch", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
	},
}
return M
