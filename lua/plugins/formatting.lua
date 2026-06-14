return {
  -- Install non-LSP mason tools (formatters / linters)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "stylua",             -- Lua
          "prettier",           -- JS/TS/HTML/CSS/JSON/YAML/Markdown
          "ruff",               -- Python (formatter + linter)
          "gofumpt",            -- Go (strict gofmt)
          "goimports",          -- Go (auto import management)
          "google-java-format", -- Java
          "clang-format",       -- C / C++
          "shfmt",              -- Bash / Shell
          "typstyle",           -- Typst
          -- Linters
          "eslint_d",           -- Fast ESLint daemon for JS/TS
          "golangci-lint",      -- Go linter aggregator
          "hadolint",           -- Dockerfile linter
        },
        auto_update  = false,
        run_on_start = true,
      })
    end,
  },

  -- Formatter engine
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = { "ConformInfo" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua          = { "stylua" },
          python       = { "ruff_format" },
          go           = { "gofumpt", "goimports" },
          -- rustfmt ships with rustup, not mason
          rust         = { "rustfmt" },
          java         = { "google_java_format" },
          c            = { "clang_format" },
          cpp          = { "clang_format" },
          javascript   = { "prettier" },
          javascriptreact   = { "prettier" },
          typescript   = { "prettier" },
          typescriptreact   = { "prettier" },
          json         = { "prettier" },
          jsonc        = { "prettier" },
          html         = { "prettier" },
          css          = { "prettier" },
          scss         = { "prettier" },
          markdown     = { "prettier" },
          yaml         = { "prettier" },
          sh           = { "shfmt" },
          bash         = { "shfmt" },
          typst        = { "typstyle" },
        },
        format_on_save = {
          timeout_ms   = 3000,
          lsp_fallback = true,
        },
        -- rustfmt comes from rustup, not mason
        formatters = {
          rustfmt = {
            command = "rustfmt",
            args    = { "--edition", "2021" },
          },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>gf", function()
        conform.format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },
}
