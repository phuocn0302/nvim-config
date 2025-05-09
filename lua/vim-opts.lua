vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.numberwidth = 4
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline= true
vim.o.scrolloff = 10
vim.o.sidescrolloff = 10
vim.o.splitbelow = true

--vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
--vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
--vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
--vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
vim.keymap.set("v", "<c-c>", '"+y')

vim.cmd(":command WQ wq")
vim.cmd("command Wq wq")
vim.cmd(":command W w")
vim.cmd(":command Q q")

vim.g.mapleader = " "
