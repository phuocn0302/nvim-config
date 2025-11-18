return {
  -- Main Theme
  {
    "phuocn0302/pywal.nvim",
    name = "pywal",
    priority = 1000,

    config = function()
      require("pywal").setup()
      vim.cmd.colorscheme = "pywal"

      local lualine = require("lualine")

      lualine.setup({
        options = {
          theme = "pywal",
        },
      })
    end,
  },

  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function ()
  --     require("catppuccin").setup()
  --     vim.cmd.colorscheme "catppuccin-mocha"
  --
  --   end
  -- },

  -- Show color code
  {
    "rrethy/vim-hexokinase",
    name = "vim-hexokinase",
    build = "make hexokinase",
    event = "VeryLazy",

    config = function()
      vim.cmd("HexokinaseTurnOn")
    end,
  },

  -- Disable hls when done search
  {
    "romainl/vim-cool",
    event = "VeryLazy",
  },

  -- Cursor blink when move
  {
    "danilamihailov/beacon.nvim",
  },

  -- A fraction of neovide cursor animation :( 
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  },

  -- Highlight windows
  {
    "nvim-zh/colorful-winsep.nvim",
    event = { "WinLeave" },
    config = true,
  },
}
