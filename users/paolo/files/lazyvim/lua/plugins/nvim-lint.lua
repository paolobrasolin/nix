return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				-- Ref: https://www.lazyvim.org/plugins/linting
				-- Ref: https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
				-- Ref: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
				lua = { "selene" },
				nix = { "statix", "deadnix" },
				python = { "ruff" },
				-- sh = { "shellcheck" }, -- already called by bashls LSP
			},
		},
	},
}
