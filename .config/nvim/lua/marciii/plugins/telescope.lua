local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true } },
}

function M.config()
	local icons = require("marciii.extra.icons")
	local actions = require("telescope.actions")
	local builtin = require("telescope.builtin")
	require("telescope").setup({

		defaults = {
			file_ignore_patterns = {
				"node_modules",
			},
			prompt_prefix = icons.ui.Telescope .. " ",
			selection_caret = icons.ui.Forward .. " ",
			entry_prefix = "   ",
			initial_mode = "insert",
			selection_strategy = "reset",
			path_display = { "smart" },
			color_devicons = true,
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
			},

			mappings = {
				i = {
					["<C-u>"] = actions.cycle_history_next,
					["<C-d>"] = actions.cycle_history_prev,
					-- ["<C-t>"] = require("trouble.sources.telescope").open,
					-- ["<C-a>"] = require("trouble.sources.telescope").add,
					-- ["<C-j>"] = actions.move_selection_next,
					-- ["<C-k>"] = actions.move_selection_previous,
					["<C-n>"] = actions.move_selection_next,
					["<C-p>"] = actions.move_selection_previous,
				},
				n = {
					-- ["<C-t>"] = require("trouble.sources.telescope").open,
					["<esc>"] = actions.close,
					["n"] = actions.move_selection_next,
					["p"] = actions.move_selection_previous,
					-- ["t"] = require("trouble.sources.telescope").open,
					-- ["a"] = require("trouble.sources.telescope").add,
					["q"] = actions.close,
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		},
		pickers = {
			find_files = {
				theme = "ivy",
				previewer = false,
				hidden = true,
			},
			live_multigrep = {
				theme = "ivy",
			},
			live_grep = {
				theme = "ivy",
			},
			grep_string = {
				theme = "ivy",
			},
			help_tags = {
				theme = "ivy",
				previewer = false,
			},
			resume = {
				theme = "ivy",
				previewer = false,
			},
			buffers = {
				theme = "ivy",
				previewer = false,
				mappings = {
					n = {
						["dd"] = actions.delete_buffer,
					},
				},
			},
		},
	})

	-- <leader>fg
	require("marciii.plugins.tsp-extension.multigrep").setup()

	vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "telescope: find files" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "telescope: open buffers" })
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "telescope: neovim help tags" })
	vim.keymap.set("n", "<leader>fl", builtin.resume, { desc = "telescope: resume" })
	vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "telescope: keymaps" })

	-- vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Telescope: show todo" })
	-- vim.keymap.set("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", { desc = "Telescope: show jumplist" })
	-- vim.keymap.set("n", "<leader>fn", "<cmd>Telescope noice<CR>", { desc = "Telescope:  show projects" })

	vim.keymap.set("n", "<leader>fc", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "telescope: find neovim config" })

	vim.keymap.set("n", "<leader>fp", function()
		builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
	end, { desc = "telescope: find neovim plugin" })

	vim.keymap.set("n", "<leader>fG", function()
		local word = vim.fn.expand("<cWORD>")
		builtin.grep_string({ search = word })
	end, { desc = "Telescope: grep string under cursor" })
end
return M
