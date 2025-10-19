return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "pyright" },
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local mason_lspconfig = require("mason-lspconfig")

			local default_handler = function(server_name)
				vim.lsp.config[server_name] = vim.lsp.config[server_name] or {}
				vim.lsp.config[server_name] = vim.tbl_deep_extend("force", vim.lsp.config[server_name], {
					capabilities = capabilities,
				})
				vim.lsp.start(vim.lsp.config[server_name])
			end

			local handlers = {
				["lua_ls"] = function()
					vim.lsp.config.lua_ls = vim.tbl_deep_extend("force", vim.lsp.config.lua_ls or {}, {
						capabilities = capabilities,
						settings = {
							Lua = { diagnostics = { globals = { "vim" } } },
						},
					})
					vim.lsp.start(vim.lsp.config.lua_ls)
				end,
			}

			for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
				(handlers[server_name] or default_handler)(server_name)
			end

			vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics in float" })
		end,
	},
}

