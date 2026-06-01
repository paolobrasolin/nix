local util = require("lspconfig.util")

return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
				-- NOTE: LSPs are installed via nix, not mason.
				bashls = {},
				biome = {},
				cssls = {},
				docker_compose_language_service = {},
				dockerls = {},
				html = {},
				jsonls = {},
				lua_ls = {},
				marksman = {},
				nil_ls = {},
				pyright = {},
				rust_analyzer = {},
				solargraph = {},
				tailwindcss = {
					filetypes = {
						"html",
						"slim",
						"css",
						"less",
						"postcss",
						"sass",
						"scss",
						"javascript",
						"typescript",
						"svelte",
					},
				},
				texlab = {},
				terraformls = {},
				denols = {
					enabled = false,
				},
				ts_ls = {},
				yamlls = {},
			},
		},
	},
}
