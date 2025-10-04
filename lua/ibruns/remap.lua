vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>exp", ":Explore<CR>", { noremap = true, silent = true, desc = "Explore" })

-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

vim.keymap.set("n", "<leader>vd", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
vim.keymap.set("n", "<leader>vD", ":DiffviewClose<CR>", { desc = "Close Diffview" })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>")
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf, silent = true }

        local map = vim.keymap.set

        opts.desc = "Go to Definition"
        map("n", "gd", vim.lsp.buf.definition, opts)

        opts.desc = "Hover"
        map("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Workspace Symbols"
        map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)

        opts.desc = "Open Diagnostic Float"
        map("n", "<leader>vd", vim.diagnostic.open_float, opts)

        opts.desc = "Open diagnostic [Q]uickfix list"
        map("n", "<leader>q", vim.diagnostic.setloclist, opts)

        opts.desc = "Code Action"
        map("n", "<leader>vca", function()
            require("actions-preview").code_actions()
        end, opts)

        opts.desc = "Find References"
        map("n", "<leader>vrr", vim.lsp.buf.references, opts)

        opts.desc = "Rename Symbol"
        map("n", "<leader>vrn", vim.lsp.buf.rename, opts)

        opts.desc = "Signature Help"
        map("i", "<C-h>", vim.lsp.buf.signature_help, opts)

        opts.desc = "Next Diagnostic"
        map("n", "[d", vim.diagnostic.goto_next, opts)

        opts.desc = "Previous Diagnostic"
        map("n", "]d", vim.diagnostic.goto_prev, opts)
    end,
})
