return {
	{
		"olimorris/codecompanion.nvim",
		config = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
			},
		},

		keys = {
			{ "<leader>a", "", desc = "+CodeCompanion", mode = { "n", "v" } },
			{ "<leader>za", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Actions" },
			{ "<leader>zc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "Chat" },
			{ "<leader>zp", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Prompt" },
		},
	},
}
