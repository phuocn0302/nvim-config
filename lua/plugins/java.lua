-- Java LSP via nvim-jdtls (advanced Java support: organize imports, test runner, DAP)
-- jdtls binary is installed by mason (see lsp-config.lua ensure_installed)
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls    = require("jdtls")
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"

      -- Per-project workspace to avoid cross-project class caches
      local project_name  = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.expand("~/.local/share/nvim/jdtls-workspace/") .. project_name

      -- sdkman sets JAVA_HOME; jdtls itself requires Java 17+
      local java_bin = (os.getenv("JAVA_HOME") or "") .. "/bin/java"
      if vim.fn.executable(java_bin) == 0 then
        java_bin = "java" -- fall back to PATH
      end

      local config = {
        -- mason-installed jdtls wrapper handles launcher jar + config_linux automatically
        cmd = { mason_bin, "-data", workspace_dir },

        root_dir = vim.fs.dirname(
          vim.fs.find({ "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" }, { upward = true })[1]
        ) or vim.fn.getcwd(),

        capabilities = require("cmp_nvim_lsp").default_capabilities(),

        -- Standard LSP keymaps come from the global LspAttach autocmd in lsp-config.lua.
        -- Only Java-specific keymaps are set here.
        on_attach = function(_, bufnr)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("<leader>jo", jdtls.organize_imports,    "Organize imports")
          map("<leader>jv", jdtls.extract_variable,    "Extract variable")
          map("<leader>jm", jdtls.extract_method,      "Extract method")
          map("<leader>jt", jdtls.test_nearest_method, "Test nearest method")
          map("<leader>jT", jdtls.test_class,          "Test class")
          map("<leader>ju", "<cmd>JdtUpdateConfig<cr>","Update jdtls config")
        end,

        settings = {
          java = {
            eclipse      = { downloadSources = true },
            maven        = { downloadSources = true },
            signatureHelp         = { enabled = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens     = { enabled = true },
            contentProvider        = { preferred = "fernflower" },
            completion = {
              guessMethodArguments = true,
              favoriteStaticMembers = {
                "org.junit.Assert.*",
                "org.junit.jupiter.api.Assertions.*",
                "org.mockito.Mockito.*",
                "org.mockito.ArgumentMatchers.*",
              },
              filteredTypes = { "com.sun.*", "jdk.*", "sun.*", "java.awt.*" },
            },
            sources = {
              organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
            },
            codeGeneration = {
              toString    = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
              useBlocks   = true,
              hashCodeEquals = { useJava7Objects = true },
            },
            configuration = {
              updateBuildConfiguration = "interactive",
              runtimes = {
                -- sdkman-managed runtimes; add more as needed
                { name = "JavaSE-21", path = os.getenv("JAVA_HOME") or "" },
              },
            },
          },
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "java",
        callback = function()
          -- Only start if jdtls binary exists (mason has installed it)
          if vim.fn.executable(mason_bin) == 1 then
            jdtls.start_or_attach(config)
          else
            vim.notify("jdtls not found. Run :MasonInstall jdtls", vim.log.levels.WARN)
          end
        end,
      })
    end,
  },
}
