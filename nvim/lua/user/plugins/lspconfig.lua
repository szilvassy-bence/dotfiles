local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Setup Mason to automatically install LSP servers
mason.setup()
mason_lspconfig.setup({ automatic_installation = true })

-- PHP
lspconfig.intelephense.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
lspconfig.phpactor.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'php' },
})

-- Clangd
lspconfig.clangd.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Disable clangd's formatting capabilities to avoid conflicts
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})

lspconfig.ts_ls.setup({
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    cmd = { "typescript-language-server", "--stdio" },
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    single_file_support = true,
})

lspconfig.emmet_ls.setup({
    filetypes = { "html", "blade", "css", "javascriptreact" },
})

-- BASH
lspconfig.bashls.setup{
  capabilities = capabilities,
  filetypes = { 'sh' },
}

-- JSON
lspconfig.jsonls.setup({
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
})

-- none-ls
-- local null_ls = require('null-ls')
-- null_ls.setup({
--   sources = {
--     null_ls.builtins.diagnostics.eslint_d.with({
--       condition = function(utils)
--         return utils.root_has_file({ '.eslintrc.js' })
--       end,
--     }),
--     null_ls.builtins.diagnostics.trail_space.with({ disabled_filetypes = { 'NvimTree' } }),
--     null_ls.builtins.formatting.prettierd,
--     null_ls.builtins.formatting.phpcsfixer,
--   },
-- })
-- null-ls
require('mason-null-ls').setup({ automatic_installation = true })

-- Keymaps
vim.keymap.set('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>')
vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>')
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

-- Commands
vim.api.nvim_create_user_command('Format', function()
  vim.lsp.buf.format()
end, {})


-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = false,
  float = {
    source = true,
  }
})
-- Sign configuration
vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
