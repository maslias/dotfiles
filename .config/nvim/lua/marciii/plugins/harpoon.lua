local M = {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim", "letieu/harpoon-lualine" },
}
function M.config()
	local harpoon = require("harpoon")
	-- local tmux = require("harpoon.tmux")
	harpoon:setup()

	vim.keymap.set("n", "<leader>ha", function()
		harpoon:list():add()
		vim.notify("󱡁  marked file")
	end)
	vim.keymap.set("n", "<leader>hs", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end)

	vim.keymap.set("n", "<C-h>h", function()
		harpoon:list():select(1)
	end)
	vim.keymap.set("n", "<C-h>j", function()
		harpoon:list():select(2)
	end)
	vim.keymap.set("n", "<C-h>k", function()
		harpoon:list():select(3)
	end)
	vim.keymap.set("n", "<C-h>l", function()
		harpoon:list():select(4)
	end)

	-- Toggle previous & next buffers stored within Harpoon list
	vim.keymap.set("n", "<C-h>p", function()
		harpoon:list():prev()
	end)
	vim.keymap.set("n", "<C-h>n", function()
		harpoon:list():next()
	end)
end
return M
