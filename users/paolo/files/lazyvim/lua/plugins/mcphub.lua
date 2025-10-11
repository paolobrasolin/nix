return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
	},
	-- NOTE: we do this manually
	-- build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
	config = function()
		require("mcphub").setup({
			-- Required options
			port = 3000, -- Port for MCP Hub server
			config = vim.fn.expand("~/mcpservers.json"), -- Absolute path to config file

			-- Optional options
			on_ready = function(hub)
				-- Called when hub is ready
			end,
			on_error = function(err)
				-- Called on errors
			end,
			shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
			log = {
				level = vim.log.levels.WARN,
				to_file = true,
				file_path = "~/mcphub.log",
				prefix = "MCPHub",
			},
		})
	end,
}
