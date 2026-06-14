return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",        -- Lua
          "ts_ls",         -- TypeScript / JavaScript
          "eslint",        -- JS/TS linting via LSP
          "basedpyright",  -- Python
          "gopls",         -- Go
          "rust_analyzer", -- Rust
          "clangd",        -- C / C++
          "jdtls",         -- Java (binary installed here; nvim-jdtls manages startup)
          "yamlls",        -- YAML
          "dockerls",      -- Dockerfile
          "docker_compose_language_service",
          "jsonls",        -- JSON
          "bashls",        -- Bash / Shell
          "taplo",         -- TOML
          "tinymist",      -- Typst
        },
        -- Let mason-lspconfig call vim.lsp.enable() for installed servers,
        -- but exclude jdtls — nvim-jdtls handles its own startup.
        automatic_enable = { exclude = { "jdtls" } },
      })
    end,
  },

  {
    -- nvim-lspconfig provides default server configs (cmd, filetypes, root_dir)
    -- via lsp/ runtime files. We use vim.lsp.config to extend/override them.
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Global capabilities: applies to every LSP server
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Keymaps via LspAttach (fires for every attached client)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("n", "gd",         vim.lsp.buf.definition,     "Go to definition")
          map("n", "gD",         vim.lsp.buf.declaration,    "Go to declaration")
          map("n", "gr",         vim.lsp.buf.references,     "Go to references")
          map("n", "gi",         vim.lsp.buf.implementation, "Go to implementation")
          map("n", "K",          vim.lsp.buf.hover,          "Hover docs")
          map("n", "<leader>rn", vim.lsp.buf.rename,         "Rename symbol")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>e",  vim.diagnostic.open_float,  "Show diagnostics")
          map("n", "[d",         vim.diagnostic.goto_prev,   "Prev diagnostic")
          map("n", "]d",         vim.diagnostic.goto_next,   "Next diagnostic")
        end,
      })

      -- Per-server config overrides ------------------------------------------

      -- Lua: recognise `vim` global
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      -- Python: auto-detect uv .venv in project root
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths    = true,
              useLibraryCodeForTypes = true,
              diagnosticMode     = "workspace",
              typeCheckingMode   = "standard",
            },
          },
        },
      })

      -- Go
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses    = { unusedparams = true, shadow = true },
            staticcheck = true,
            gofumpt     = true,
          },
        },
      })

      -- Rust: run clippy on save
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo       = { allFeatures = true },
            checkOnSave = { command = "clippy" },
            imports     = { granularity = { group = "module" }, prefix = "self" },
          },
        },
      })

      -- C / C++: clang-tidy + iwyu headers
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders    = true,
          completeUnimported = true,
          clangdFileStatus   = true,
        },
      })

      -- YAML: SchemaStore for Kubernetes, GitHub Actions, etc.
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            validate    = true,
            schemaStore = {
              enable = true,
              url    = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = {
              kubernetes = "/*.k8s.yaml",
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
            format = { enable = true },
          },
        },
      })

      -- ESLint: auto-fix on save
      vim.lsp.config("eslint", {
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer  = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      -- Diagnostic appearance
      vim.diagnostic.config({
        virtual_text  = { prefix = "●" },
        severity_sort = true,
        float         = { border = "rounded", source = "always" },
      })
    end,
  },
}
