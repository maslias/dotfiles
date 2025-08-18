-- colors heme
vim.pack.add({
  { src = 'https://github.com/scottmckendry/cyberdream.nvim' },
})
require("cyberdream").setup({
  terminal_colors = true,
  transparent = true,
  hide_fillchars = true,
})
vim.cmd.colorscheme("cyberdream")


-- markdown
vim.pack.add({
  { src = "https://github.com/bullets-vim/bullets.vim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})
require("render-markdown").setup()

vim.g.bullets_delete_last_bullet_if_empty = 1



-- minis
vim.pack.add({
  { src = 'https://github.com/echasnovski/mini.pick' },
  { src = 'https://github.com/echasnovski/mini.bracketed' },
  { src = 'https://github.com/echasnovski/mini.files' },
  { src = 'https://github.com/echasnovski/mini.icons' },
  { src = 'https://github.com/echasnovski/mini.diff' },
  { src = 'https://github.com/echasnovski/mini-git' },
  { src = 'https://github.com/echasnovski/mini.statusline' },
  { src = 'https://github.com/echasnovski/mini.indentscope' },
  { src = 'https://github.com/echasnovski/mini.ai' },
  { src = 'https://github.com/echasnovski/mini.surround' },
  { src = 'https://github.com/echasnovski/mini.splitjoin' },
  { src = 'https://github.com/echasnovski/mini.notify' },
})

require("mini.pick").setup({
  mappings = {
    choose = '<C-y>',
  }
})

vim.keymap.set('n', '<leader>ff', ":Pick files<CR>")
vim.keymap.set('n', '<leader>fb', ":Pick buffers<CR>")
vim.keymap.set('n', '<leader>fg', ":Pick grep_live<CR>")
vim.keymap.set('n', '<leader>fh', ":Pick help<CR>")

require("mini.bracketed").setup()
require("mini.files").setup()

vim.keymap.set('n', '<leader>ee', ":lua MiniFiles.open()<CR>")
vim.keymap.set("n", "<leader>ef", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
  require("mini.files").reveal_cwd()
end)

require('mini.icons').setup()
require('mini.diff').setup()
require('mini.git').setup()
require('mini.indentscope').setup()
require('mini.ai').setup()
require('mini.surround').setup()
require('mini.statusline').setup()
require('mini.notify').setup()


require("mini.splitjoin").setup({
  mappings = { toggle = "" }
})

vim.keymap.set({ "n", "x" }, "sj", function() require("mini.splitjoin").join() end)
vim.keymap.set({ "n", "x" }, "sk", function() require("mini.splitjoin").split() end)



-- undo tree
vim.pack.add({
  { src = 'https://github.com/mbbill/undotree' },
})

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)


-- stay-centered
vim.pack.add({
  { src = "https://github.com/arnamak/stay-centered.nvim" },
})
require("stay-centered").setup({
  skip_filetypes = {},
  enabled = true,
  allow_scroll_move = true,
  disable_on_mouse = true
})


-- noice
-- vim.pack.add({
--   { src = "https://github.com/MunifTanjim/nui.nvim" },
--   { src = "https://github.com/folke/noice.nvim" },
-- })
-- require("noice").setup({
--   stages = "static",
--   cmdline = {
--     view = "cmdline",
--   },
--   lsp = {
--     progress = {
--     },
--     signature = {
--       enabled = false,
--       auto_open = {
--         enabled = false,
--         trigger = false,
--         luasnip = false,
--       },
--
--     }
--   },
--   presets = {
--     lsp_doc_border = true
--   }
-- })

-- flash
vim.pack.add({
  { src = "https://github.com/folke/flash.nvim" }
})

require("flash").setup({
  modes = {
    search = {
      enabled = true,
    },
    char = {
      jump_labels = true,
    },
  }
})

vim.keymap.set({ 'n', 'x', 'o' }, 'sS', function() require("flash").treesitter() end)
vim.keymap.set({ 'n', 'x', 'o' }, 'ss', function() require("flash").jump() end)


-- schema store
vim.pack.add({
  { src = "https://github.com/b0o/schemastore.nvim" },
})



vim.pack.add({
  { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})

require("tiny-inline-diagnostic").setup({
  -- ...
  signs = {
    left = "",
    right = "",
    diag = "●",
    arrow = "    ",
    up_arrow = "    ",
    vertical = " │",
    vertical_end = " └",
  },
  blend = {
    factor = 0.22,
  },
})

-- diagnostic
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})




vim.pack.add({
  { src = "https://github.com/ravibrock/spellwarn.nvim" }
})

require("spellwarn").setup({
  enable = true
})
