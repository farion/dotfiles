-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "d", '"_d')
vim.keymap.set("n", "D", '"_D')
vim.keymap.set("v", "d", '"_d')

vim.keymap.set("n", "<leader>d", '""d')
vim.keymap.set("n", "<leader>D", '""D"')
vim.keymap.set("v", "<leader>d", '""d')
