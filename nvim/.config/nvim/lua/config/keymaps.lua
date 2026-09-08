local utils = require("utils")
local map = utils.map

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

map("n", "<leader>w", "<cmd>silent w<CR>", "Save")
map("n", "<C-s>", "<cmd>silent update<CR>", "Save")
map("n", "<leader>Q", "<cmd>q<CR>", "Quit")
map("n", "<C-q>", "<cmd>wq<CR>", "Save and Quit")

-- Insert movment
map("i", "<C-h>", "<Left>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
map("i", "<C-l>", "<Right>")

-- Splits movement
map("n", "<C-h>", "<C-w>h", "Move to left split")
map("n", "<C-j>", "<C-w>j", "Move to bottom split")
map("n", "<C-k>", "<C-w>k", "Move to top split")
map("n", "<C-l>", "<C-w>l", "Move to right split")
map("n", "<A-h>", "<cmd>vertical resize +2<CR>", "Increase split vertical")
map("n", "<A-j>", "<cmd>resize -2<CR>", "Reduce split horizontal")
map("n", "<A-k>", "<cmd>resize +2<CR>", "Increase split horizontal")
map("n", "<A-l>", "<cmd>vertical resize -2<CR>", "Reduce split vertical")

-- Buffer movement
map("n", "<Tab>", "<cmd>bnext<CR>", "Next buffer")
map("n", "<s-Tab>", "<cmd>bprev<CR>", "Previous buffer")
map("n", "<leader>q", "<cmd>bdelete<CR>", "Close buffer")

-- Selected actions
map("v", "??", "y:h <C-R>0<CR>", "Vim help")
map("v", "?/", "y:/<C-R>0<CR>", "Search the buffer")

map("n", "<C-c>", "<cmd>noh<CR><cmd>redraw!<CR>", "Remove highlights")
