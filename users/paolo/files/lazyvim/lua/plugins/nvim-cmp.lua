return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-emoji" },
			{ "Arkissa/cmp-agda-symbols" },
		},
		opts = function(_, opts)
			table.insert(opts.sources, { name = "emoji" })
			table.insert(opts.sources, { name = "agda-symbols" })
		end,
	},
}
