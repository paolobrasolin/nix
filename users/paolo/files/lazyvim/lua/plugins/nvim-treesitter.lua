return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			-- NOTE: we just install gcc via nix and let nvim-treesitter do its thing.
			auto_install = true,
			-- ensure_installed = {},
			highlight = {
				enable = true,
				disable = { "agda" },
				-- disable = function(lang, buf)
				-- 	local file_path = vim.api.nvim_buf_get_name(buf)
				-- 	-- Disable highlighting for Agda files outside of the Nix store
				-- 	if lang == "agda" and not string.find(file_path, "^/nix/store/") then
				-- 		return true
				-- 	end
				-- end,
			},
		},
	},
}
