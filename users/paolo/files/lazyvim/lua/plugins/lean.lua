return {
	-- Highlighting, the Lean language server (`lake serve`), the infoview, and \-abbreviations.
	-- NOTE: Lean isn't installed globally: each project pins its own (e.g. `nix develop .#formal`),
	-- so `lake` must be on PATH when neovim starts.
	"Julian/lean.nvim",
	event = { "BufReadPre *.lean", "BufNewFile *.lean" },
	init = function()
		-- NOTE: lean.nvim has no setup() since 2026-10; lazy's `opts` would call it.
		---@type lean.Config
		vim.g.lean_config = { mappings = true }
	end,
}
