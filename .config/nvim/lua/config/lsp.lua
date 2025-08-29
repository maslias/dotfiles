-- lsp setup
vim.pack.add {
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  -- for automate install
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
}

require('mason').setup()
require('mason-lspconfig').setup()

-- for automate install
require('mason-tool-installer').setup({
  ensure_installed = {
    "lua_ls",
    "stylua",
    "marksman",
    "mdformat",
    "jsonls",
    "fixjson",
    "yamlls",
    "yamlfix",
    "gopls",
    -- "gofumpt",
    -- "goimports-reviser",
    "bashls"
   -- "cspell_ls"
  }
})

-- autocompletion
vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp" },
})


require("blink.cmp").setup({
  keymap = {
    preset = 'default',
  },
  signature = { enabled = true },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    menu = {
      auto_show = true,
      draw = {
        treesitter = { "lsp" },
        columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
      },
    },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },
})

-- diagnostic
-- vim.diagnostic.config({
--   virtual_lines = {
--     current_line = true,
--   },
--   signs = {
--     text = {
--       [vim.diagnostic.severity.ERROR] = "󰅚 ",
--       [vim.diagnostic.severity.WARN] = "󰀪 ",
--       [vim.diagnostic.severity.INFO] = "󰋽 ",
--       [vim.diagnostic.severity.HINT] = "󰌶 ",
--     },
--     numhl = {
--       [vim.diagnostic.severity.ERROR] = "ErrorMsg",
--       [vim.diagnostic.severity.WARN] = "WarningMsg",
--     },
--   },
-- })



-- treesitter
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' }
})
require("nvim-treesitter.configs").setup(
  {
    ensure_installed = {
      'lua',
      'markdown',
      'markdown_inline',
      'json',
      'yaml',
      'go',
      'bash'
    },
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlightling = false,
    },
    indent = {
      enable = true,
    },
    autotag = { enable = true }
  }
)
