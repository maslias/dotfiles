local M = {

	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = function()
		local colors = require("cyberdream.colors").default
		local cyberdream = require("lualine.themes.cyberdream")
		local icons = require("marciii.extra.icons")
		return {
			options = {
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				theme = cyberdream,
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},

			sections = {
				-- lualine_a = { { "mode", icon = "" } },
				lualine_a = {
					{
						function()
							return ""
						end,
						color = { fg = colors.yellow, bg = colors.none, gui = "bold" },
					},
					{
						"harpoon2",
						color = { fg = colors.yellow, bg = colors.none, gui = "bold" },
					},
				},
				lualine_b = {
					{
						"filename",
						symbols = { modified = "  ", readonly = "", unnamed = "" },
						color = function()
							-- auto change color according to neovims mode
							local mode_color = {
								n = colors.blue,
								i = colors.green,
								v = colors.magenta,
							}
							return { fg = mode_color[vim.fn.mode()], gui = "bold" }
						end,
					},
				},
				lualine_c = {
					{ "diff", color = { gui = "bold" } },
					{
						"progress",
						color = { fg = colors.grey, bg = colors.none, gui = "bold" },
					},
					{
						"location",
						color = { fg = colors.grey, bg = colors.none, gui = "bold" },
					},
				},
				lualine_x = {
					{
						function()
							return require("nvim-navic").get_location()
						end,
						cond = function()
							return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
						end,
						color = { fg = colors.grey, bg = colors.none, gui = "bold" },
					},
				},

				lualine_y = {
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error .. " ",
							warn = icons.diagnostics.Warning .. " ",
							info = icons.diagnostics.Information .. " ",
							hint = icons.diagnostics.Hint .. " ",
							color = { gui = "bold" },
						},
						color = { gui = "bold" },
					},
					{
						function()
							local recording_register = vim.fn.reg_recording()
							if recording_register == "" then
								return ""
							else
								return " " .. recording_register .. ".."
							end
						end,
						color = { fg = colors.pink, bg = colors.none, gui = "bold" },
					},
				},
				lualine_z = {
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = { fg = colors.green, gui = "bold" },
					},
				},
			},

			extensions = { "lazy", "toggleterm", "mason", "trouble" },
		}
	end,
}

return M
