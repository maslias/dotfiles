local M = {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		jump = {
			autojump = true,
		},
		modes = {
			char = {
				jump_labels = true,
				multi_line = false,
			},
		},
	},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "flash: flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "flash: flash treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "flash: remote flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "flash: treesitter search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "flash: toggle flash search" },
  },
}

return M
