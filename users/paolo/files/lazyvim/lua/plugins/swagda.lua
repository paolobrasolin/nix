return {
	{
		"paolobrasolin/swagda.nvim",
		dir = "~/pb/swagda.nvim",
		config = function()
			require("swagda").setup()
			-- vim.keymap.set(
			-- 	"v",
			-- 	"<leader>aH",
			-- 	":<C-u>'<,'>SwagdaSimplifySelection<cr>",
			-- 	{ desc = "Simplify selection", buffer = true }
			-- )
		end,
	},
}
