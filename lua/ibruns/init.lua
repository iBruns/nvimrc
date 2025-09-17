require("ibruns.set")
require("ibruns.remap")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
})

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "ibruns.plugin",
    change_detection = { notify = false }
})
