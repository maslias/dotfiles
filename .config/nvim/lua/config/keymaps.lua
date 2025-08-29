--general
vim.keymap.set('n', '<leader>W', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':update<CR>')
vim.keymap.set('n', '<leader>x', ':quit<CR>')
vim.keymap.set('n', '<leader>X', ':quit!<CR>')

--navigation
vim.keymap.set('n', '<C-Space>', '<C-^>', { desc = 'Switch to alternate buffer' })

vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "quickfix previous item" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "quickfix next item" })

-- movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Motion: half page down center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Motion: half page uuuuuupppuppppup center" })

-- lsp
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'format buffer'})

-- diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })


-- selected text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected text down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected text up", silent = true })
vim.keymap.set("v", "H", "<gv", { desc = "move selected text left tab", silent = true })
vim.keymap.set("v", "L", ">gv", { desc = "move selected text right tab", silent = true })








