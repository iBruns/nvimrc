return {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerRestartLast" },
    keys = {
        { "<leader>or", "<cmd>OverseerRun<cr>",         desc = "Run a task" },
        { "<leader>oo", "<cmd>OverseerToggle<cr>",      desc = "Toggle task list" },
        { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Restart last task" },
    },
    opts = {
        strategy = {
            "terminal",
            direction = "horizontal", -- could also be "vertical" or "float"
        },
        templates = { "builtin" },    -- include built-in templates (dotnet, npm, etc.)
    },
    config = function(_, opts)
        local overseer = require("overseer")
        overseer.setup(opts)

        local dotnet_tasks = {
            {
                name = "dotnet build (Debug)",
                builder = function()
                    return {
                        cmd = { "dotnet" },
                        args = { "build", "--configuration", "Debug" },
                        components = { "default" },
                    }
                end,
                condition = { filetype = { "cs" } },
            },
            {
                name = "dotnet build (Release)",
                builder = function()
                    return {
                        cmd = { "dotnet" },
                        args = { "build", "--configuration", "Release" },
                        components = { "default" },
                    }
                end,
                condition = { filetype = { "cs" } },
            },
            {
                name = "dotnet run",
                builder = function()
                    return {
                        cmd = { "dotnet" },
                        args = { "run", "--configuration", "Debug" },
                        components = { "default" },
                    }
                end,
                condition = { filetype = { "cs" } },
            },
        }

        for _, task in ipairs(dotnet_tasks) do
            overseer.register_template(task)
        end
    end,
}
