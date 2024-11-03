return {
	{
		"echasnovski/mini.operators",
		opts = {
			evaluate = {
				prefix = "gH",
				func = function(content)
					local function humanize(text)
						return text:gsub("([ (])[CD]%.", "%1"):gsub("%.F₀ ", " "):gsub("%.F₁ ", " ")
					end

					local function peel(text)
						return text:gsub(" %(([^()]+)%)", "%1")
					end

					local function humanize_and_peel(text)
						text = humanize(text)
						local last_text = text
						while true do
							text = peel(text)
							if text == last_text then
								break
							end
							last_text = text
						end

						return text
					end

					-- local lastLine = table.remove(content.lines)
					local lines = table.concat(content.lines, "\n")
					return humanize_and_peel(lines)
				end,
			},
		},
	},
}
