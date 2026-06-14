--Load lazyvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.opt.clipboard = "unnamedplus"

local opts = {}

require("vim-opts")
--require("lazy").setup("plugins")
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = {
		enabled = true, -- automatically check for plugin updates
		notify = false, -- get a notification when new updates are found
	},

	-- ui config
	ui = {},
})

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local argc = vim.fn.argc()

		local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1

		if not is_dir then
			return
		end

		vim.schedule(function()
			if vim.bo.buftype ~= "" then
				vim.cmd("enew")
			end

			vim.cmd("Neotree show left")

			local height = math.floor(vim.o.lines * 0.3)
			vim.cmd("botright " .. height .. "split | terminal")

			vim.cmd("wincmd k")
		end)
	end,
})
