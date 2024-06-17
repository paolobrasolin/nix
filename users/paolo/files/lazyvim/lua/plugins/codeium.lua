return {
	{
		"Exafunction/codeium.vim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			-- TODO: get the binary path via nix
			vim.g.codeium_bin = "/run/current-system/sw/bin/codeium_language_server"
			vim.g.codeium_enabled = true
			vim.g.codeium_manual = false
			-- NOTE: some default bindings are a bit absurd (e.g. <Right> to accept) so I just turn them off.
			-- NOTE: see https://github.com/Exafunction/codeium.vim/commit/9fa0dee67051d8e5d334f7f607e6bab1d6a46d1a#r143124905
			-- vim.g.codeium_disable_bindings = 1
			-- TODO: welp, the line above doesn't even work. let's just drop the bindings and wait for a fix.
			vim.keymap.del("i", "<Right>")
			vim.keymap.del("i", "<C-Right>")
			vim.keymap.set("i", "<M-Enter>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<M-]>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<M-[>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<M-Backspace>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, silent = true })
		end,
	},
}
