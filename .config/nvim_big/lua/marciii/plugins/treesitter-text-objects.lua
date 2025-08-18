local M = {
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}

function M.config()
    require("nvim-treesitter.configs").setup({
        textobjects = {
            select = {
                enable = true,
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                    ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                    ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                    ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

                    ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/field region" },
                    ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/field region" },

                    ["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
                    ["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },

                    ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },

                    ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional region" },
                    ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional region" },

                    ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop region" },
                    ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop region" },

                    ["ab"] = { query = "@block.outer", desc = "Select outer part of a block region" }, -- overrides default text object block of parenthesis to parenthesis
                    ["ib"] = { query = "@block.inner", desc = "Select inner part of a block region" }, -- overrides default text object block of parenthesis to parenthesis

                    ["ag"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                    ["ig"] = { query = "@call.inner", desc = "Select inner part of a function call" },

                    ["at"] = { query = "@comment.outer", desc = "Select commentary part" },
                },
                include_surrounding_whitespace = true,
            },
            move = {
                enable = true,
                set_jumps = true,

                goto_next_start = {
                    ["]a"] = { query = "@parameter.outer", desc = "Next function call start" },
                    ["]g"] = { query = "@call.outer", desc = "Next function call start" },
                    ["]f"] = { query = "@function.outer", desc = "Next method/function def start" },
                    ["]c"] = { query = "@class.outer", desc = "Next class start" },
                    ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                    -- ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
                },
                goto_next_end = {
                    ["]A"] = { query = "@parameter.outer", desc = "Next function call start" },
                    ["]G"] = { query = "@call.outer", desc = "Next function call end" },
                    ["]F"] = { query = "@function.outer", desc = "Next method/function def end" },
                    ["]C"] = { query = "@class.outer", desc = "Next class end" },
                    ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                    -- ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
                },
                goto_previous_start = {
                    ["[a"] = { query = "@parameter.outer", desc = "Next function call start" },
                    ["[g"] = { query = "@call.outer", desc = "Prev function call start" },
                    ["[f"] = { query = "@function.outer", desc = "Prev method/function def start" },
                    ["[c"] = { query = "@class.outer", desc = "Prev class start" },
                    ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
                    -- ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
                },
                goto_previous_end = {

                    ["[A"] = { query = "@parameter.outer", desc = "Next function call start" },
                    ["[G"] = { query = "@call.outer", desc = "Prev function call end" },
                    ["[F"] = { query = "@function.outer", desc = "Prev method/function def end" },
                    ["[C"] = { query = "@class.outer", desc = "Prev class end" },
                    ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
                    -- ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
                },
            },
        },
    })

	local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

	-- vim way: ; goes to the direction you were moving.
	vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
	vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

	-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
	vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
	vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
	vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
	vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
end

return M
