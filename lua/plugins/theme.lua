return {
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
}
