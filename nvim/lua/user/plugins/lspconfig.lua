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

local keymap = vim.keymap.set
local opts = function(desc) return { noremap = true, silent = true, desc = desc } end
local builtin = require('telescope.builtin')

-- diagnostic
keymap('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>')
keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')

-- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
-- vim.keymap.set('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
-- vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>')
-- vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>')

-- Other LSP features
keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

-- Navigation commands are in Telescope plugin configuration

-- Commands
vim.api.nvim_create_user_command('Format', function()
  vim.lsp.buf.format()
end, {})

vim.diagnostic.config({
  virtual_text = false,
  float = {
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "",
    },
  },
})
