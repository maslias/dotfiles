vim.g.mapleader = " "
vim.keymap.set("n", "<leader>lv", vim.cmd.Ex, { desc = "Buffer: leave buffer" })
vim.keymap.set("n", "<leader>lx", "<cmd>quit<CR>", { desc = "Buffer: save buffer" })
vim.keymap.set("n", "<leader>lX", "<cmd>quit!<CR>", { desc = "Buffer: save buffer" })
vim.keymap.set("n", "<leader>lw", "<cmd>update<CR>", { desc = "Buffer: save buffer" })

vim.keymap.set("n", "<c-space>", "<cmd>e #<CR>", { desc = "Buffer: switch to last buffer" })

vim.keymap.set("v", "<S-a>", "vgg<S-v>G", { desc = "Motion: center search term" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Motion: center search term" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Motion: center search term" })
vim.keymap.set("n", "*", "*zzzv", { desc = "Motion: center search term" })
vim.keymap.set("n", "#", "#zzzv", { desc = "Motion: center search term" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Motion: move selected text down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Motion: move selected text up", silent = true })
vim.keymap.set("v", "H", "<gv", { desc = "Motion: move selected text left tab", silent = true })
vim.keymap.set("v", "L", ">gv", { desc = "Motion: move selected text right tab", silent = true })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Motion: cursor to begin after J" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Motion: half page down center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Motion: half page uuuuuupppuppppup center" })

vim.keymap.set("x", "<C-p>", [["_dP]], { desc = "P: do not wright overwritten value into register" })
vim.keymap.set({ "n", "v" }, "<C-y>", [["+y]], { desc = "Y: copy into system clipboard" })

vim.keymap.set(
	"n",
	"<leader>lcr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "replace string under cursor" }
)

vim.keymap.set("n", "<C-w>x", "<cmd>close<CR>", { desc = "Close current split" })
vim.keymap.set("n", "<C-w>X", "<C-W>o", { desc = "Close all other splits" })
vim.keymap.set("n", "<C-w>-", "<cmd>vsplit<CR>", { desc = "new split window" })
vim.keymap.set("n", "<C-w>_", "<cmd>split<CR>", { desc = "new split window" })

vim.keymap.set("n", "<leader>lQ", function()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end
	if qf_exists == true then
		vim.cmd("cclose")
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd("copen")
	end
end, { desc = "Quickfix: Toggle List" })

vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Quickfix: previous item" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Quickfix: next item" })

vim.keymap.set("n", "]l", function()
	if require("trouble").is_open() then
		require("trouble").next({ skip_groups = true, jump = true })
	else
		vim.cmd("cnext")
	end
end, { desc = "trouble / quickfix: next item" })

vim.keymap.set("n", "[l", function()
	if require("trouble").is_open() then
		require("trouble").prev({ skip_groups = true, jump = true })
	else
		vim.cmd("cprev")
	end
end, { desc = "trouble / quickfix: previous item" })
