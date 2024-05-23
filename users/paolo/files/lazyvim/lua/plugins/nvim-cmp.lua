return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "Arkissa/cmp-agda-symbols" },
		},
		opts = function(_, opts)
			table.insert(opts.sources, { name = "agda-symbols" })
		end,
	},
}
