return {
  "rebelot/kanagawa.nvim",
  config = function()
    require("kanagawa").setup({
      compile = false,             -- Disable compilation
      undercurl = true,            -- Enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,         -- Set background color
      dimInactive = false,         -- Do not dim inactive windows
      terminalColors = true,       -- Define terminal colors
      colors = {
        palette = {},
        theme = {
          wave = {},
          lotus = {},
          dragon = {},
          all = {},
        },
      },
      overrides = function(colors)
        return {}
      end,
      theme = "dragon",              -- Default theme
      background = {
        dark = "dragon",             -- Dark background theme
        light = "lotus",           -- Light background theme
      },
    })
    vim.cmd("colorscheme kanagawa")
  end,
}
