-- ~/.config/nvim/lua/plugins/lsp.lua

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- "saghen/blink.cmp",
    },

    config = function()
        ---------------------------------------------------------------------------
        -- 1. Mason setup
        ---------------------------------------------------------------------------
        require("mason").setup({
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
            ui = { border = "rounded" },
        })

        ---------------------------------------------------------------------------
        -- 2. Mason-lspconfig setup
        ---------------------------------------------------------------------------
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls" },
            automatic_installation = true,
        })

        ---------------------------------------------------------------------------
        -- 3. Common settings
        ---------------------------------------------------------------------------
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        local on_attach = function(_, bufnr)
            local opts = { buffer = bufnr, silent = true }

            opts.desc = "Go to Definition"
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

            opts.desc = "Hover"
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

            opts.desc = "Workspace Symbols"
            vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)

            opts.desc = "Open Diagnostic Float"
            vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)

            opts.desc = "Open diagnostic [Q]uickfix list"
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

            opts.desc = "Code Action"
            vim.keymap.set("n", "<leader>vca", function()
                require("actions-preview").code_actions()
            end, opts)

            opts.desc = "Find References"
            vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)

            opts.desc = "Rename Symbol"
            vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)

            opts.desc = "Signature Help"
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

            opts.desc = "Next Diagnostic"
            vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)

            opts.desc = "Previous Diagnostic"
            vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        end

        ---------------------------------------------------------------------------
        -- 4. Diagnostics UI
        ---------------------------------------------------------------------------
        vim.diagnostic.config {
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = '󰅚 ',
                    [vim.diagnostic.severity.WARN] = '󰀪 ',
                    [vim.diagnostic.severity.INFO] = '󰋽 ',
                    [vim.diagnostic.severity.HINT] = '󰌶 ',
                },
            } or {},
            virtual_text = {
                source = 'if_many',
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        }


        ---------------------------------------------------------------------------
        -- 5. Lua LS (via mason)
        ---------------------------------------------------------------------------
        vim.lsp.config('lua_ls', {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        })
    end,
}
