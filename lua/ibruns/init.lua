require("ibruns.set")
require("ibruns.remap")
require("ibruns.lazy_init")

-- Restore cursor to last position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local last_pos = vim.fn.line([['"]])
		if last_pos > 0 and last_pos <= vim.fn.line("$") then
			pcall(vim.api.nvim_win_set_cursor, 0, { last_pos, 0 })
		end
	end,
})

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup("ThePrimeagen", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = ThePrimeagenGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = ThePrimeagenGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition", buffer = e.buf })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = e.buf })
		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, { desc = "Workspace Symbols", buffer = e.buf })
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Open Diagnostic Float", buffer = e.buf })
		vim.keymap.set("n", "<leader>vca", function()
			require("actions-preview").code_actions()
		end, { desc = "Code Action", buffer = e.buf })
		vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, { desc = "Find References", buffer = e.buf })
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = e.buf })
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = e.buf })
		vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { desc = "Next Diagnostic", buffer = e.buf })
		vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic", buffer = e.buf })
	end,
})

vim.lsp.config("roslyn", {
	on_attach = function()
		print("This will run when the server attaches!")
	end,
	settings = {
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
		},
	},
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
