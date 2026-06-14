-- System deps (Arch):
--   sudo pacman -S ueberzugpp imagemagick luarocks poppler zathura zathura-pdf-mupdf
--   luarocks install magick

return {
  -- Inline image rendering inside Neovim buffers (PNG/JPG/GIF/WebP/SVG)
  {
    "3rd/image.nvim",
    build = false,
    event = "VeryLazy",
    config = function()
      local backend
      if os.getenv("KITTY_WINDOW_ID") or os.getenv("TERM_PROGRAM") == "WezTerm" then
        backend = "kitty"  -- both kitty and WezTerm speak the kitty graphics protocol
      elseif vim.fn.executable("ueberzugpp") == 1 then
        backend = "ueberzugpp"
      else
        vim.notify("image.nvim: no supported backend (need WezTerm/kitty or ueberzugpp)", vim.log.levels.WARN)
        return
      end

      require("image").setup({
        backend = backend,
        integrations = {
          markdown = { enabled = true, clear_in_insert_mode = false },
          typst    = { enabled = true },
        },
        max_width  = 100,
        max_height = 30,
        editor_only_render_when_focused = true,
        tmux_show_only_in_active_window = true,
      })
    end,
  },

  -- Telescope extension: image + PDF preview in the file picker
  -- PDF preview renders the first page via pdftoppm (from poppler)
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          media_files = {
            filetypes = { "png", "jpg", "jpeg", "gif", "webp", "svg", "pdf" },
            find_cmd  = "rg",
          },
        },
      })
      require("telescope").load_extension("media_files")

      vim.keymap.set("n", "<leader>fm", "<cmd>Telescope media_files<cr>", { desc = "Find media files" })

      -- Opening a .pdf buffer redirects to zathura and wipes the binary buffer
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern  = "*.pdf",
        callback = function()
          local path = vim.fn.expand("%:p")
          vim.cmd("bdelete!")
          vim.fn.jobstart({ "zathura", path }, { detach = true })
          vim.notify("PDF → zathura: " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
        end,
      })
    end,
  },
}
