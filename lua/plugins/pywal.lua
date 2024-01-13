return {
  "phuocn0302/pywal.nvim",
  name = "pywal",
  priority = 1000,

  config = function()
    require("pywal").setup()
    vim.cmd.colorscheme = "pywal"
  end,
}
