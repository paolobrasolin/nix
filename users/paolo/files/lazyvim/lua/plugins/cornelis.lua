return {
	{
		"isovector/cornelis",
		dependencies = {
			{ "kana/vim-textobj-user" },
			{ "neovimhaskell/nvim-hs.vim" },
		},
		init = function()
			-- https://github.com/folke/which-key.nvim/issues/514#issuecomment-1987286901
			require("lazyvim.util").on_load("which-key.nvim", function()
				require("which-key").register({
					["<leader>a"] = { name = "+cornelis", ["🚫"] = "which_key_ignore" },
				})
			end)
		end,
		config = function()
			vim.g.cornelis_use_global_binary = 1
			vim.g.cornelis_no_agda_input = 1 -- NOTE: agda-input is just too slow; we user nvim-cmp with cmp-agda-symbols instead
			vim.g.cornelis_split_location = "horizontal"
			vim.g.cornelis_max_size = 10

			local keymaps = {
				{ "<leader>al", "<cmd>CornelisLoad<cr>", "Load and type-check" },
				{ "<leader>axq", "<cmd>CornelisRestart<cr>", "Kill and restart Agda" },
				{ "<leader>axa", "<cmd>CornelisAbort<cr>", "Abort command" },
				{ "<leader>as", "<cmd>CornelisSolve<cr>", "Solve constraints" },
				{ "<leader>a?", "<cmd>CornelisGoals<cr>", "Show all goals" },
				{ "<leader>af", "<cmd>CornelisNextGoal<cr>", "Jump to next goal" },
				{ "<leader>ab", "<cmd>CornelisPrevGoal<cr>", "Jump to prev goal" },
				{ "<leader>ar", "<cmd>CornelisRefine<cr>", "Refine goal" },
				{ "<leader>ac", "<cmd>CornelisMakeCase<cr>", "Case split" },

				{ "<leader>a ", "<cmd>CornelisGive<cr>", "Fill goal with hole contents" },
				{ "<leader>aa", "<cmd>CornelisAuto<cr>", "Automatic proof search" },

				{ "<leader>am", "<cmd>CornelisElaborate Normalised<cr>", "Fill goal with normalized hole contents	" },
				{ "<leader>a,", "<cmd>CornelisTypeContext Normalised<cr>", "Show goal type and context" },
				{ "<leader>ad", "<cmd>CornelisTypeInfer Normalised<cr>", "Show inferred type of hole contents" },
				{
					"<leader>a.",
					"<cmd>CornelisTypeContextInfer Normalised<cr>",
					"Show goal type, context, and inferred type of hole contents",
				},
				{ "<leader>ah", "<cmd>CornelisHelperFunc Normalised<cr>", 'Copy inferred type to register "' },

				{ "<leader>an", "<cmd>CornelisNormalize<cr>", "Compute normal of hole contents" },

				{ "<leader>aw", "<cmd>CornelisWhyInScope<cr>", "Show why given name is in scope" },

				{ "<leader>aj", "<cmd>CornelisGoToDefinition<cr>", "Jump to definition" },
				{ "<leader>a+", "<cmd>CornelisQuestionToMeta<cr>", "Expand hole" },
				{ "<leader>axi", "<cmd>CornelisCloseInfoWindows<cr>", "Close info windows" },
				-- { "<leader>a", "<cmd>CornelisInc<cr>", "Increase" },
				-- { "<leader>a", "<cmd>CornelisDec<cr>", "Decrease" },
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "agda",
				callback = function()
					for _, keymap in ipairs(keymaps) do
						local lhs, rhs, desc = unpack(keymap)
						vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = true })
					end
				end,
			})
		end,
	},
}
