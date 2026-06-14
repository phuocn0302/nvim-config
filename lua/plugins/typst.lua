return {
  -- Live preview for Typst (opens in browser, hot-reloads on save)
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    build = function()
      require("typst-preview").update()
    end,
    config = function()
      require("typst-preview").setup({
        open_cmd = "xdg-open %s", -- Linux browser opener
      })

      vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreview<cr>",       { desc = "Typst preview open" })
      vim.keymap.set("n", "<leader>ts", "<cmd>TypstPreviewStop<cr>",   { desc = "Typst preview stop" })
      vim.keymap.set("n", "<leader>tt", "<cmd>TypstPreviewToggle<cr>", { desc = "Typst preview toggle" })
    end,
  },
}
