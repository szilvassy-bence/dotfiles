require('user.plugins')
require('user.options')
require('user.keymaps')

vim.api.nvim_create_autocmd('FileType', {
    pattern = {'sh', 'php', 'lua', 'js'},
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
    end,
})
