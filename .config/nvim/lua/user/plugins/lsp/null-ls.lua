local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	debug = false,
	sources = {
		-- code actions
		code_actions.eslint,
		code_actions.proselint,
		code_actions.refactoring,

		-- diagnostics
		diagnostics.eslint,
		diagnostics.flake8.with({ extra_args = { "--max-line-length", "80", "--ignore=E501,W503" } }),
		diagnostics.ruff,
		diagnostics.luacheck,
		diagnostics.proselint,

		-- formatting
		formatting.black.with({ extra_args = { "--line-length", "80" } }),
		formatting.dart_format,
		formatting.latexindent,
		formatting.stylua,
		formatting.prettier.with({ extra_args = { "--single-quote", "--jsx-single-quote" } }),
	},
	-- you can reuse a shared lspconfig on_attach callback here
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false, bufnr = bufnr })
				end,
			})
		end
	end,
})
