return {
    "karb94/neoscroll.nvim",
    opts = {
        -- You can set easing functions, duration, etc.
        easing_function = "quadratic", -- Default is "quadratic"
        hide_cursor = true,
    },
    config = function(_, opts)
        local neoscroll = require("neoscroll")
        neoscroll.setup(opts)

        local keymap = {
            ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 450 }) end,
            ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 450 }) end,
            ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 450 }) end,
            ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 450 }) end,
            ["<C-y>"] = function() neoscroll.scroll(-0.10, { move_cursor = false, duration = 100 }) end,
            ["<C-e>"] = function() neoscroll.scroll(0.10, { move_cursor = false, duration = 100 }) end,
            ["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end,
            ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end,
            ["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end,
        }

        local modes = { "n", "v", "x" }
        for key, func in pairs(keymap) do
            vim.keymap.set(modes, key, func, { silent = true })
        end
    end,
}
