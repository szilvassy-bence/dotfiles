require('user/plugins')
require('user/options')
require('user/keymaps')

-- Remap Ctrl+Q to enter visual block mode (instead of Ctrl+V)
vim.api.nvim_set_keymap('n', '<C-q>', '<C-v>', { noremap = true, silent = true })
