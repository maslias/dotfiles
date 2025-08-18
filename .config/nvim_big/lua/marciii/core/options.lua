local opt = vim.opt
vim.cmd("let g:netrw_liststyle = 3")

opt.relativenumber = true
opt.number = true

opt.softtabstop = 4
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.scrolloff = 8

opt.termguicolors = true
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")
-- opt.clipboard = 'unnamedplus'

opt.splitright = true
opt.splitbelow = true
opt.wildignore:append({ "*/node!modules/*" })
opt.path:append({ "**" })

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.completeopt = "menuone,noselect"
opt.clipboard = "unnamedplus"
opt.breakindent = true
-- opt.inccommand = "split"
-- opt.splitbelow = true
-- opt.splitright = true
-- opt.splitkeep = "cursor"
opt.formatoptions:append({ "r" })

-- some script helpers
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.filetype.add({
	extension = {
		["http"] = "http",
        templ = "templ",
	},
})

vim.opt.spelllang = 'en_us'
