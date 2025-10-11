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
				denols = {
					workspace_required = true,
					single_file_support = false,
					root_dir = util.root_pattern("deno.json"),
				},
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
				tsserver = {
					workspace_required = true,
					single_file_support = false,
					root_dir = function(fname)
						if util.root_pattern("deno.json")(fname) then
							return nil -- disable tsserver in deno projects
						end
						return util.root_pattern("package.json")(fname)
					end,
				},
				yamlls = {},
			},
		},
	},
}
