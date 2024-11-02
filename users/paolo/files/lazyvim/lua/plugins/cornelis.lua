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
				-- Global commands
				-- Ref: https://agda.readthedocs.io/en/latest/tools/emacs-mode.html#global-commands
				{ "<leader>al", "<cmd>CornelisLoad<cr>", "Load and type-check" },
				-- { "<leader>axc", "", "Compile file" },
				-- { "<leader>axq", "", "Quit Agda process" },
				{ "<leader>axr", "<cmd>CornelisRestart<cr>", "Kill and restart Agda" },
				{ "<leader>axa", "<cmd>CornelisAbort<cr>", "Abort command" },
				-- { "<leader>axd", "", "Remove goals and highlighting" },
				-- { "<leader>axh", "", "Toggle hidden arguments" },
				-- { "<leader>axi", "", "Toggle irrelevant arguments" },
				-- { "<leader>a=", "", "Show constraints" },
				{ "<leader>as", "<cmd>CornelisSolve Normalised<cr>", "Solve constraints" },
				{ "<leader>aS1", "<cmd>CornelisSolve AsIs<cr>", "Solve constraints (AsIs)" },
				{ "<leader>aS2", "<cmd>CornelisSolve Instantiated<cr>", "Solve constraints (Instantiated)" },
				{ "<leader>aS3", "<cmd>CornelisSolve HeadNormal<cr>", "Solve constraints (HeadNormal)" },
				{ "<leader>aS4", "<cmd>CornelisSolve Simplified<cr>", "Solve constraints (Simplified)" },
				{ "<leader>aS5", "<cmd>CornelisSolve Normalised<cr>", "Solve constraints (Normalised)" },
				{ "<leader>a?", "<cmd>CornelisGoals<cr>", "Show all goals" },
				{ "<leader>af", "<cmd>CornelisNextGoal<cr>", "Jump to next goal" },
				{ "<leader>ab", "<cmd>CornelisPrevGoal<cr>", "Jump to prev goal" },
				{ "<leader>ad", "<cmd>CornelisTypeInfer Normalised<cr>", "Infer type" },
				-- { "<leader>ao", "", "Module contents" },
				-- { "<leader>az", "", "Search Definitions in Scope" },
				{ "<leader>an", "<cmd>CornelisNormalize DefaultCompute<cr>", "Compute normal form" },
				{ "<leader>aun", "<cmd>CornelisNormalize IgnoreAbstract<cr>", "Compute normal form ignoring abstract" },
				{ "<leader>auun", "<cmd>CornelisNormalize UseShowInstance<cr>", "Compute normal form of show <expr>" },
				{ "<leader>auuun", "<cmd>CornelisNormalize HeadCompute<cr>", "Compute weak head normal form" },
				-- { "<leader>ax;", "", "Comment/uncomment rest of buffer" },
				-- { "<leader>axs", "", "Switch Agda version" }

				-- Commands in context of a goal
				-- Ref: https://agda.readthedocs.io/en/latest/tools/emacs-mode.html#commands-in-context-of-a-goal
				--------------------------------------------------------------------------------
				{ "<leader>a ", "<cmd>CornelisGive<cr>", "Fill goal with hole contents" },
				{ "<leader>ar", "<cmd>CornelisRefine<cr>", "Refine goal" },
				{ "<leader>am", "<cmd>CornelisElaborate Normalised<cr>", "Fill goal with normalized hole contents" },
				-- { "<leader>aum", "<cmd>CornelisElaborate ?<cr>", "" },
				-- { "<leader>auum", "<cmd>CornelisElaborate ?<cr>", "" },
				{ "<leader>aa", "<cmd>CornelisAuto<cr>", "Automatic proof search" },
				{ "<leader>ac", "<cmd>CornelisMakeCase<cr>", "Case split" },
				{ "<leader>ah", "<cmd>CornelisHelperFunc Normalised<cr>", 'Copy inferred type to register "' },
				-- { "<leader>at", "", "Goal type" },
				-- { "<leader>ae", "", "Context (environment)" },
				-- { "<leader>ad", "<cmd>CornelisTypeInfer Normalised<cr>", "Infer type" },
				{ "<leader>a,", "<cmd>CornelisTypeContext Normalised<cr>", "Goal type and context" },
				{
					"<leader>a.",
					"<cmd>CornelisTypeContextInfer Normalised<cr>",
					"Goal type, context and inferred type",
				},
				-- { "<leader>a;", "", "Goal type, context and checked term" },
				-- { "<leader>ao", "", "Module contents" },
				-- { "<leader>an", "<cmd>CornelisNormalize DefaultCompute<cr>", "Compute normal form" },
				-- { "<leader>aun", "<cmd>CornelisNormalize IgnoreAbstract<cr>", "Compute normal form ignoring abstract" },
				-- { "<leader>auun", "<cmd>CornelisNormalize UseShowInstance<cr>", "Compute normal form of show <expr>" },
				-- { "<leader>auuun", "<cmd>CornelisNormalize HeadCompute<cr>", "Compute weak head normal form" },
				{ "<leader>aw", "<cmd>CornelisWhyInScope<cr>", "Show why given name is in scope" },

				-- Other commands
				-- Ref: https://agda.readthedocs.io/en/latest/tools/emacs-mode.html#other-commands
				{ "<leader>aj", "<cmd>CornelisGoToDefinition<cr>", "Jump to definition" },

				-- Cornelis specific commands
				{ "<leader>a+", "<cmd>CornelisQuestionToMeta<cr>", "Expand hole" },
				-- { "<leader>a", "<cmd>CornelisInc<cr>", "Increase" },
				-- { "<leader>a", "<cmd>CornelisDec<cr>", "Decrease" },
				{ "<leader>axi", "<cmd>CornelisCloseInfoWindows<cr>", "Close info windows" },
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
