return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "mason-org/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "leoluz/nvim-dap-go",
    },
    keys = {
        { "<F5>",      function() require("dap").continue() end,                                             desc = "Debug: Start/Continue" },
        { "<F1>",      function() require("dap").step_into() end,                                            desc = "Debug: Step Into" },
        { "<F2>",      function() require("dap").step_over() end,                                            desc = "Debug: Step Over" },
        { "<F3>",      function() require("dap").step_out() end,                                             desc = "Debug: Step Out" },
        { "<leader>b", function() require("dap").toggle_breakpoint() end,                                    desc = "Debug: Toggle Breakpoint" },
        { "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Set Breakpoint" },
        { "<F7>",      function() require("dapui").toggle() end,                                             desc = "Debug: Toggle DAP UI" },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        ---------------------------------------------------------------------------
        -- Mason DAP setup
        ---------------------------------------------------------------------------
        require("mason-nvim-dap").setup({
            automatic_installation = true,
            ensure_installed = {
                "delve",      -- Go
                "netcoredbg", -- .NET / C#
            },
        })

        ---------------------------------------------------------------------------
        -- DAP UI setup
        ---------------------------------------------------------------------------
        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "⏎",
                    step_over = "⏭",
                    step_out = "⏮",
                    step_back = "b",
                    run_last = "▶▶",
                    terminate = "⏹",
                    disconnect = "⏏",
                },
            },
        })

        ---------------------------------------------------------------------------
        -- Visual indicators for breakpoints
        ---------------------------------------------------------------------------
        vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
        vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
        local breakpoint_icons = vim.g.have_nerd_font
            and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
            or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
        for type, icon in pairs(breakpoint_icons) do
            local tp = 'Dap' .. type
            local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
            vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        end

        ---------------------------------------------------------------------------
        -- DAP UI event listeners
        ---------------------------------------------------------------------------
        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        ---------------------------------------------------------------------------
        -- Go (delve) setup
        ---------------------------------------------------------------------------
        require("dap-go").setup({
            delve = {
                detached = vim.fn.has("win32") == 0,
            },
        })

        ---------------------------------------------------------------------------
        -- .NET / C# setup (netcoredbg)
        ---------------------------------------------------------------------------
        local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"

        local netcoredbg_adapter = {
            type = "executable",
            command = mason_path,
            args = { "--interpreter=vscode" },
        }

        dap.adapters.netcoredbg = netcoredbg_adapter
        dap.adapters.coreclr = netcoredbg_adapter

        -- Helper to find the most recent DLL automatically
        local function find_latest_dll()
            local cwd = vim.fn.getcwd()
            local dlls = vim.fn.globpath(cwd, "bin/Debug/**/*.dll", true, true)
            if vim.tbl_isempty(dlls) then
                dlls = vim.fn.globpath(cwd, "bin/Release/**/*.dll", true, true)
            end
            if vim.tbl_isempty(dlls) then
                return vim.fn.input(" Enter path to .dll: ", cwd .. "/", "file")
            end
            table.sort(dlls, function(a, b)
                return vim.fn.getftime(a) > vim.fn.getftime(b)
            end)
            vim.notify("Launching: " .. dlls[1])
            return dlls[1]
        end

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "Launch - netcoredbg",
                request = "launch",
                program = find_latest_dll,
            },
        }
    end,
}
