return {
	"frabjous/knap",
	config = function()
		local knap = require("knap")

		local function swallow_output(callback)
			print = function(...) end
			pcall(callback, arg)
		end

		local group = vim.api.nvim_create_augroup("KnapReload", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "main.tex",
			group = group,
			callback = function()
				swallow_output(function()
					local _ = knap.process_once()
				end)
			end,
		})

		local keymap = vim.keymap

		keymap.set({ "n", "v" }, "<leader><leader>p", function()
			knap.process_once()
		end)

		keymap.set({ "n", "v" }, "<leader><leader>s", function()
			knap.toggle_autopreviewing()
		end)

		keymap.set({ "n", "v" }, "<leader><leader>c", function()
			knap.forward_jump()
		end)

		keymap.set({ "n", "v" }, "<leader><leader>e", function()
			knap.close_viewer()
		end)
	end,
}
