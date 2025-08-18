vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.winborder = "rounded"

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.colorcolumn = '90'
vim.opt.isfname:append("@-@")
vim.opt.termguicolors = true
vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)
vim.g.have_nerd_font = true

vim.opt.spelllang='de_de,en_us'
vim.opt.spelloptions='camel'

-- autocmd
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})








