return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				-- Ref: https://www.lazyvim.org/plugins/formatting
				-- Ref: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
				lua = { "stylua" },
				nix = { "alejandra" },
				python = { "black" },
				ruby = { "rufo" },
				sh = { "shfmt" },
			},
		},
	},
}
