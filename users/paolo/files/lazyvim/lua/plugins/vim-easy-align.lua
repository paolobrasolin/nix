return {
	{
		"junegunn/vim-easy-align",
		config = function()
			vim.keymap.set("n", "ga", "<Plug>(LiveEasyAlign)")
			vim.keymap.set("x", "ga", "<Plug>(LiveEasyAlign)")

			vim.g.easy_align_delimiters = {
				r = {
					pattern = "[≤≡≈∎]",
					left_margin = 1,
					right_margin = 0,
					stick_to_left = 0,
					delimiter_align = "l",
					align = "l",
					indentation = "d",
				},
			}
		end,
	},
}
