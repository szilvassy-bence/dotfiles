local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Setup Mason to automatically install LSP servers
mason.setup()
mason_lspconfig.setup({ automatic_installation = true })

local on_attach = function(client, bufnr)
  local keymap = vim.keymap.set
  local opts = { buffer = bufnr, noremap = true, silent = true }

  keymap('n', 'gra', vim.lsp.buf.code_action, opts)
  keymap('n', 'gri', vim.lsp.buf.implementation, opts)
  keymap('n', 'grn', vim.lsp.buf.rename, opts)
  keymap('n', 'grr', vim.lsp.buf.references, opts)
  keymap('n', 'grt', vim.lsp.buf.type_definition, opts)
  keymap('n', 'gO', vim.lsp.buf.document_symbol, opts)
  keymap('i', '<C-S>', vim.lsp.buf.signature_help, opts)
  keymap('n', 'gi', require('telescope.builtin').lsp_implementations, opts)
  keymap('n', 'gr', require('telescope.builtin').lsp_references, opts)
  keymap('n', 'gy', require('telescope.builtin').lsp_type_definitions, opts)
  keymap('n', 'gd', require('telescope.builtin').lsp_definitions, opts)
  vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
  end, { desc = 'Show diagnostics under cursor' })

  -- if client.name == "intelephense" or client.name == "phpactor" then
  --   -- insert-mode completion bekapcsolása
  --   vim.lsp.completion.enable(true, client.id, bufnr, {
  --     autotrigger = true,  -- automatikusan feljön a menü a trigger karaktereknél
  --   })
  -- end

  -- if client.name == "intelephense" then
  --   vim.lsp.inline_completion.enable(true, client.id, bufnr, {
  --     autotrigger = true,   -- automatikus javaslat gépeléskor
  --     debounce = 100,       -- (opcionális) ms-ben, mennyi ideig várjon a trigger után
  --     highlight = "Comment" -- ghost text színe
  --   })

  --   -- Manual trigger: Ctrl+Space
  --   keymap("i", "<C-Space>", function()
  --     vim.lsp.inline_completion.get()
  --   end, { buffer = bufnr, desc = "Trigger inline completion" })
  -- end

end

-- vim.lsp.config('copilot', {
--   cmd = { 'copilot-language-server', '--stdio', },
--   root_markers = { '.git' },
-- })
-- vim.lsp.enable("copilot")

-- PHP
vim.lsp.config("intelephense", {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = on_attach,
})
vim.lsp.enable("intelephense")

vim.lsp.config("phpactor", {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'php' },
})
vim.lsp.enable("phpactor")

-- Clangd
vim.lsp.config("clangd", {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Disable clangd's formatting capabilities to avoid conflicts
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    vim.lsp.default_keymaps({ buffer = bufnr })
  end,
})
vim.lsp.enable("clangd")

vim.lsp.config("ts_ls", {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  cmd = { "typescript-language-server", "--stdio" },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  single_file_support = true,
  on_attach = on_attach,
  capabilities = capabilities
})
vim.lsp.enable("ts_ls")

vim.lsp.config("emmet_ls", {
  capabilities = capabilities,
  filetypes = { "html", "blade", "css", "javascriptreact" },
  on_attach = on_attach
})
vim.lsp.enable("emmet_ls")

-- BASH
vim.lsp.config("bashls", {
  capabilities = capabilities,
  filetypes = { 'sh' },
  on_attach = on_attach
})
vim.lsp.enable("bashls")

-- JSON
vim.lsp.config("jsonls", {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
})
vim.lsp.enable("jsonls")

vim.lsp.config("copilot", {
  cmd = { "copilot-language-server", "--stdio", },
  root_markers = { '.git' },
})
vim.lsp.enable("copilot")

require('mason-null-ls').setup({ automatic_installation = true })

vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local types = {
    [vim.lsp.protocol.MessageType.Error] = vim.log.levels.ERROR,
    [vim.lsp.protocol.MessageType.Warning] = vim.log.levels.WARN,
    [vim.lsp.protocol.MessageType.Info] = vim.log.levels.INFO,
    [vim.lsp.protocol.MessageType.Log] = vim.log.levels.DEBUG,
  }
  local level = types[result.type] or vim.log.levels.INFO

  -- Csak WARNING és ERROR mutatása
  if level >= vim.log.levels.WARN then
    vim.notify(result.message, level)
  end
end

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
