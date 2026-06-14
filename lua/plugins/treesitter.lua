return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build  = ":TSUpdate",
  event  = "VeryLazy",
  config = function()
    -- GCC 16 (Arch) has an ICE on large parser.c files; clang compiles them fine
    require("nvim-treesitter.install").compilers = { "clang", "gcc" }

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        -- Core
        "lua", "vim", "vimdoc", "query",
        -- Web
        "javascript", "typescript", "tsx", "html", "css", "json", "jsonc",
        -- Python
        "python",
        -- Go
        "go", "gomod", "gowork", "gosum",
        -- Rust
        "rust", "toml",
        -- Java
        "java",
        -- C / C++
        "c", "cpp",
        -- DevOps / Config
        "yaml", "dockerfile", "bash", "markdown", "markdown_inline",
        -- Git
        "git_config", "gitignore", "gitcommit",
        -- Extras
        "regex", "comment",
        -- Typst
        "typst",
      },
      highlight   = { enable = true },
      indent      = { enable = true },
      auto_install = true,
    })
  end,
}
