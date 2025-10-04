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
            -- on_attach = on_attach,
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
