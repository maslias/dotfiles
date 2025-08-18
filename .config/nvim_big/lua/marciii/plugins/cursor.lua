local M = {
	"ukyouz/syntax-highlighted-cursor.nvim",
	event = "VeryLazy",
	opts = {
		-- If you feel updating cursor color is too often for you, try make debounce_ms bigger.
		debounce_ms = 10,

		-- If your cursor color not change immediately, try set this to true
		-- This setting adds a keymap for `:` to iteslf with quiet flag,
		-- and let vim enter command mode for a moment
		-- to force GUI refreshing cursor color.
		force_refresh_hack = true,

		-- Update Color on every cursor move
		-- If you feel laggy, try set this to false
		when_cursor_moved = true,

		-- Update Color on every cursor hold (delay is updatetime)
		when_cursor_hold = false,
	},
}

return M
