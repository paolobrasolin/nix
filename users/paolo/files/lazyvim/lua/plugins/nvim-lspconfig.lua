return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
				-- NOTE: LSPs are installed via nix, not mason.
				bashls = {},
				cssls = {},
				docker_compose_language_service = {},
				dockerls = {},
				html = {},
				jsonls = {},
				lua_ls = {},
				marksman = {},
				nil_ls = {},
				pyright = {},
				solargraph = {},
				tailwindcss = {},
				texlab = {},
				tsserver = {},
				yamlls = {},
			},
		},
	},
}
