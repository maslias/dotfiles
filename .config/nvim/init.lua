--------------------------------------------------------------------------------------------------
-- OPTIONS
--------------------------------------------------------------------------------------------------
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
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.showmatch = true
vim.opt.cmdheight = 1
vim.opt.colorcolumn = '100'
vim.opt.termguicolors = true
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.showmode = false
vim.g.have_nerd_font = true
vim.opt.conceallevel = 0
vim.opt.concealcursor = ''
vim.opt.synmaxcol = 300

local undodir = vim.fn.expand("~/.vim/undodir")
if
	vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

vim.opt.hidden = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.isfname:append("@-@")
vim.opt.path:append('**')
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true

-- vim.opt.guicursor =
-- 	"n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" 
vim.opt.foldlevel = 99

vim.opt.wildmenu = true 
vim.opt.wildmode = "longest:full,full" 
vim.opt.diffopt:append("linematch:60") 
vim.opt.redrawtime = 10000 
vim.opt.maxmempattern = 20000 

vim.opt.spelllang='de_de,en_us'
vim.opt.spelloptions='camel'

--------------------------------------------------------------------------------------------------
-- AUTOCMDS
--------------------------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- highlight ´yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- wrap and linebreak on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})


--------------------------------------------------------------------------------------------------
-- KEYMAPS
--------------------------------------------------------------------------------------------------
-- write/quit
vim.keymap.set('n', '<leader>w', ':update<CR>', { desc = 'Save buffer' })
vim.keymap.set('n', '<leader>W', ':update<CR> :source<CR>', { desc = 'Save and source buffer' })
vim.keymap.set('n', '<leader>x', ':quit<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>X', ':quit!<CR>', { desc = 'Force quit' })

-- navigation
vim.keymap.set('n', '<C-Space>', '<C-^>', { desc = 'Switch to alternate buffer' })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Quickfix previous item" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Quickfix next item" })

-- movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- lsp (direct, no popup)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'grf', vim.lsp.buf.format, { desc = 'Format buffer' })

-- diagnostics
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle diagnostics' })

-- spell
vim.keymap.set('n', '<leader>ts', function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = 'Toggle spell check' })
vim.keymap.set('n', '<leader>tse', function()
  vim.opt_local.spell = true
  vim.opt_local.spelllang = 'en_us'
end, { desc = 'Spell: English' })
vim.keymap.set('n', '<leader>tsd', function()
  vim.opt_local.spell = true
  vim.opt_local.spelllang = 'de_de'
end, { desc = 'Spell: German' })
vim.keymap.set('n', '<leader>tsb', function()
  vim.opt_local.spell = true
  vim.opt_local.spelllang = 'de_de,en_us'
end, { desc = 'Spell: Both' })

-- selected text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
vim.keymap.set("v", "H", "<gv", { desc = "Indent selection left", silent = true })
vim.keymap.set("v", "L", ">gv", { desc = "Indent selection right", silent = true })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (cursor stays)" })

-- search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })


--------------------------------------------------------------------------------------------------
-- TREESITTER
--------------------------------------------------------------------------------------------------
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})



do
  local treesitter = require("nvim-treesitter")
  treesitter.setup({})
  local ensure_installed = {
    "vim", "vimdoc", "rust", "go", "c", "cpp", "json",
    "lua", "markdown", "markdown_inline", "python", "bash", "yaml",
  }
  local already_installed = require("nvim-treesitter.config").get_installed()
  local to_install = {}
  for _, parser in ipairs(ensure_installed) do
    if not vim.tbl_contains(already_installed, parser) then
      table.insert(to_install, parser)
    end
  end
  if #to_install > 0 then
    treesitter.install(to_install)
  end
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreeSitterHighlight", { clear = true }),
    callback = function(args)
      if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
        vim.treesitter.start(args.buf)
      end
    end,
  })
end


--------------------------------------------------------------------------------------------------
-- MASON & AUTO-INSTALL
--------------------------------------------------------------------------------------------------
vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    -- lsp servers
    "clangd",
    "gopls",
    "json-lsp",
    "lua-language-server",
    "marksman",
    "pyright",
    "bash-language-server",
    "yaml-language-server",
    "rust-analyzer",
    "efm",
    -- formatters
    "clang-format",
    "gofumpt",
    "fixjson",
    "stylua",
    "mdformat",
    "black",
    "shfmt",
    "yq",
    -- linters
    "cpplint",
    "revive",
    "luacheck",
    "markdownlint",
    "flake8",
    "shellcheck",
    "yamllint",
  },
})


--------------------------------------------------------------------------------------------------
-- AUTOCOMPLETION
--------------------------------------------------------------------------------------------------
vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp" },
})

require("blink.cmp").setup({
  keymap = { preset = "default" },
  signature = { enabled = true },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
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
    nerd_font_variant = "mono",
  },
  sources = {
    default = { "lsp", "path", "buffer" },
  },
})


--------------------------------------------------------------------------------------------------
-- DIAGNOSTICS
--------------------------------------------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  virtual_lines = { current_line = true },
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
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})




--------------------------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------------------------
vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/b0o/SchemaStore.nvim" },
  { src = "https://github.com/creativenull/efmls-configs-nvim" },
})

vim.lsp.config["*"] = {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim", "require" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = { unusedparams = true },
    },
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
})

vim.lsp.config("bashls", {
  filetypes = { "bash", "sh" },
})

-- efm (formatting & linting)
do
  local luacheck = require("efmls-configs.linters.luacheck")
  local stylua = require("efmls-configs.formatters.stylua")
  local flake8 = require("efmls-configs.linters.flake8")
  local black = require("efmls-configs.formatters.black")
  local fixjson = require("efmls-configs.formatters.fixjson")
  local shellcheck = require("efmls-configs.linters.shellcheck")
  local shfmt = require("efmls-configs.formatters.shfmt")
  local cpplint = require("efmls-configs.linters.cpplint")
  local clangfmt = require("efmls-configs.formatters.clang_format")
  local go_revive = require("efmls-configs.linters.go_revive")
  local gofumpt = require("efmls-configs.formatters.gofumpt")
  local mdformat = require("efmls-configs.formatters.mdformat")
  local markdownlint = require("efmls-configs.linters.markdownlint")
  local yq = require("efmls-configs.formatters.yq")
  local yamllint = require("efmls-configs.linters.yamllint")

  vim.lsp.config("efm", {
    filetypes = { "c", "cpp", "go", "json", "lua", "markdown", "python", "sh", "yaml" },
    init_options = { documentFormatting = true },
    settings = {
      languages = {
        c = { clangfmt, cpplint },
        cpp = { clangfmt, cpplint },
        go = { gofumpt, go_revive },
        json = { fixjson },
        lua = { stylua, luacheck },
        markdown = { mdformat, markdownlint },
        python = { black, flake8 },
        sh = { shfmt, shellcheck },
        yaml = { yq, yamllint },
      },
    },
  })
end

vim.lsp.enable({
  "lua_ls",
  "gopls",
  "jsonls",
  "yamlls",
  "bashls",
  "clangd",
  "marksman",
  "pyright",
  "rust_analyzer",
  "efm",
})


--------------------------------------------------------------------------------------------------
-- ADDONS
--------------------------------------------------------------------------------------------------
-- colors theme
vim.pack.add({
  { src = 'https://github.com/scottmckendry/cyberdream.nvim' },
})
require("cyberdream").setup({
  terminal_colors = true,
  transparent = true,
  hide_fillchars = true,
})
vim.cmd.colorscheme("cyberdream")

-- markdown renderer
vim.pack.add({
  { src = "https://github.com/bullets-vim/bullets.vim" }, { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})
require("render-markdown").setup()
vim.g.bullets_delete_last_bullet_if_empty = 1


-- minis
vim.pack.add({
  { src = 'https://github.com/echasnovski/mini.pick' },
  { src = 'https://github.com/echasnovski/mini.extra' },
  { src = 'https://github.com/echasnovski/mini.statusline' },
  { src = 'https://github.com/echasnovski/mini.clue' },
  { src = 'https://github.com/echasnovski/mini.bracketed' },
  { src = 'https://github.com/echasnovski/mini.files' },
  { src = 'https://github.com/echasnovski/mini.icons' },
  { src = 'https://github.com/echasnovski/mini.diff' },
  { src = 'https://github.com/echasnovski/mini-git' },
  { src = 'https://github.com/echasnovski/mini.indentscope' },
  { src = 'https://github.com/echasnovski/mini.ai' },
  { src = 'https://github.com/echasnovski/mini.surround' },
  { src = 'https://github.com/echasnovski/mini.splitjoin' },
})


require('mini.statusline').setup()
require("mini.extra").setup()
require("mini.bracketed").setup()
require("mini.icons").setup()
require("mini.diff").setup()
require("mini.git").setup()
require("mini.indentscope").setup()
require("mini.ai").setup()
require("mini.surround").setup()

require("mini.files").setup()
vim.keymap.set('n', '<leader>ee', function() MiniFiles.open() end, { desc = 'Open explorer' })
vim.keymap.set('n', '<leader>ef', function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
  require("mini.files").reveal_cwd()
end, { desc = 'Open explorer at current file' })

require("mini.splitjoin").setup({ mappings = { toggle = "" } })
vim.keymap.set({ "n", "x" }, "sj", function() require("mini.splitjoin").join() end, { desc = "Join arguments" })
vim.keymap.set({ "n", "x" }, "sk", function() require("mini.splitjoin").split() end, { desc = "Split arguments" })

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = 'n', keys = '<Leader>' },
    { mode = 'v', keys = '<Leader>' },
    { mode = 'n', keys = 'g' },
    { mode = 'v', keys = 'g' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'n', keys = '<C-w>' },
    { mode = 'n', keys = 'z' },
    { mode = 'v', keys = 'z' },
    { mode = 'n', keys = 's' },
    { mode = 'v', keys = 's' },
  },
  clues = {
    miniclue.gen_clues.g(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),

    { mode = 'n', keys = '<Leader>f', desc = '+find' },
    { mode = 'n', keys = '<Leader>t', desc = '+toggle' },
    { mode = 'n', keys = '<Leader>ts', desc = '+spell' },
    { mode = 'n', keys = '<Leader>e', desc = '+explorer' },
    { mode = 'n', keys = 'sa', postkeys = '', desc = 'Add surrounding' },
    { mode = 'n', keys = 'sd', postkeys = '', desc = 'Delete surrounding' },
    { mode = 'n', keys = 'sr', postkeys = '', desc = 'Replace surrounding' },
    { mode = 'n', keys = 'sf', postkeys = '', desc = 'Find surrounding' },
    { mode = 'n', keys = 'sh', postkeys = '', desc = 'Highlight surrounding' },
  },
  window = {
    delay = 300,
    config = {
      width = 'auto',
    },
  },
})

-- minis filepicker
require("mini.pick").setup({
  mappings = {
    choose = '<C-y>',
  }
})


-- general pickers
vim.keymap.set('n', '<leader>ff', function()
  MiniPick.builtin.cli(
    { command = { 'fd', '--type', 'f', '--no-follow', '--color', 'never', '--hidden', '--exclude', '.git' } },
    { source = { name = 'Files (fd)' } }
  )
end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fb', ":Pick buffers<CR>", { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fg', ":Pick grep_live<CR>", { desc = 'Find grep' })
vim.keymap.set('n', '<leader>fh', ":Pick help<CR>", { desc = 'Find help' })
-- lsp pickers
vim.keymap.set('n', '<leader>fd', ":Pick lsp scope='definition'<CR>", { desc = 'Find definitions' })
vim.keymap.set('n', '<leader>fr', ":Pick lsp scope='references'<CR>", { desc = 'Find references' })
vim.keymap.set('n', '<leader>fi', ":Pick lsp scope='implementation'<CR>", { desc = 'Find implementations' })
vim.keymap.set('n', '<leader>ft', ":Pick lsp scope='type_definition'<CR>", { desc = 'Find type definitions' })
vim.keymap.set('n', '<leader>fs', ":Pick lsp scope='document_symbol'<CR>", { desc = 'Find document symbols' })
vim.keymap.set('n', '<leader>fS', ":Pick lsp scope='workspace_symbol'<CR>", { desc = 'Find workspace symbols' })
vim.keymap.set('n', '<leader>fD', ":Pick diagnostic scope='current'<CR>", { desc = 'Find diagnostics' })
vim.keymap.set('n', '<leader>fz', ":Pick spellsuggest<CR>", { desc = 'Find spell suggestions' })

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


-- flash
vim.pack.add({
  { src = "https://github.com/folke/flash.nvim" },
})
require("flash").setup({
  modes = {
    search = { enabled = true },
    char = { jump_labels = true },
  },
})
vim.keymap.set({ 'n', 'x', 'o' }, 'ss', function() require("flash").jump() end, { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'sS', function() require("flash").treesitter() end, { desc = 'Flash treesitter' })


-- noice
vim.pack.add({
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/folke/noice.nvim" },
})
require("noice").setup({
  cmdline = { view = "cmdline" },
  lsp = {
    signature = { enabled = false },
  },
  presets = {
    lsp_doc_border = true,
  },
})


--------------------------------------------------------------------------------------------------
-- START SCREEN
--------------------------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  once = true,
  desc = "Show start screen when opening without arguments",
  callback = function()
    if vim.fn.argc() > 0 then return end
    -- stdin was piped if the default buffer already has content
    if vim.api.nvim_buf_line_count(0) > 1 or vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] ~= "" then
      return
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local old = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_current_buf(buf)
    if vim.api.nvim_buf_is_valid(old) and old ~= buf then
      vim.api.nvim_buf_delete(old, { force = true })
    end

    -- clean window chrome for the start screen
    local saved_wo = {
      number = vim.wo.number,
      relativenumber = vim.wo.relativenumber,
      signcolumn = vim.wo.signcolumn,
      colorcolumn = vim.wo.colorcolumn,
      cursorline = vim.wo.cursorline,
      list = vim.wo.list,
    }
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.colorcolumn = ""
    vim.wo.cursorline = false
    vim.wo.list = false

    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = buf,
      once = true,
      callback = function()
        for k, v in pairs(saved_wo) do
          vim.wo[k] = v
        end
      end,
    })

    local sections = {
      { "Write/Quit", {
        { "SPC w", "Save buffer" },
        { "SPC x", "Quit" },
        { "SPC X", "Force quit" },
      }},
      { "Navigation", {
        { "C-Space", "Alt buffer" },
        { "[q / ]q", "Quickfix prev/next" },
      }},
      { "Find", {
        { "SPC ff", "Files" },
        { "SPC fg", "Grep" },
        { "SPC fb", "Buffers" },
        { "SPC fh", "Help" },
        { "SPC fd", "Definitions" },
        { "SPC fr", "References" },
        { "SPC fs", "Symbols" },
      }},
      { "LSP", {
        { "gd", "Definition" },
        { "gD", "Declaration" },
        { "grf", "Format" },
      }},
      { "Diagnostics", {
        { "SPC q", "Loclist" },
        { "SPC td", "Toggle" },
      }},
      { "Explorer", {
        { "SPC ee", "Open" },
        { "SPC ef", "Current file" },
      }},
      { "Flash", {
        { "ss", "Jump" },
        { "sS", "Treesitter" },
      }},
      { "Surround", {
        { "sa", "Add" },
        { "sd", "Delete" },
        { "sr", "Replace" },
      }},
      { "Split/Join", {
        { "sj", "Join" },
        { "sk", "Split" },
      }},
      { "Spell", {
        { "SPC ts", "Toggle" },
        { "SPC tse", "English" },
        { "SPC tsd", "German" },
      }},
      { "Misc", {
        { "SPC u", "Undo tree" },
      }},
    }

    local win_w = vim.api.nvim_win_get_width(0)
    local key_w, desc_w, gap = 12, 18, 4
    local block_w = (key_w + desc_w) * 2 + gap
    local margin = math.max(2, math.floor((win_w - block_w) / 2))

    local function center(s)
      local pad = math.floor((win_w - #s) / 2)
      return pad > 0 and (string.rep(" ", pad) .. s) or s
    end

    local lines = { "", "" }
    table.insert(lines, center("Neovim"))
    table.insert(lines, "")

    for _, sec in ipairs(sections) do
      table.insert(lines, "")
      table.insert(lines, string.rep(" ", margin) .. sec[1])
      local maps = sec[2]
      for i = 1, #maps, 2 do
        local l = maps[i]
        local r = maps[i + 1]
        local left = string.format("%-" .. key_w .. "s%-" .. desc_w .. "s", l[1], l[2])
        if r then
          local right = string.format("%-" .. key_w .. "s%s", r[1], r[2])
          table.insert(lines, string.rep(" ", margin + 2) .. left .. string.rep(" ", gap) .. right)
        else
          table.insert(lines, string.rep(" ", margin + 2) .. left)
        end
      end
    end

    table.insert(lines, "")
    table.insert(lines, "")
    table.insert(lines, center("q to close"))
    table.insert(lines, "")

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.bo[buf].buflisted = false

    local function close()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.cmd("enew")
      end
    end
    vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
    vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true })
  end,
})
