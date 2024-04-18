return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			-- NOTE: we just install gcc via nix and let nvim-treesitter do its thing.
			auto_install = true,
			ensure_installed = {},
		},
	},
}
