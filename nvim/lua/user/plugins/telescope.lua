local actions = require('telescope.actions')

vim.cmd([[
  highlight link TelescopePromptTitle PMenuSel
  highlight link TelescopePreviewTitle PMenuSel
  highlight link TelescopePromptNormal NormalFloat
  highlight link TelescopePromptBorder FloatBorder
  highlight link TelescopeNormal CursorLine
  highlight link TelescopeBorder CursorLineBg
]])

require('telescope').setup({
  defaults = {
    path_display = { truncate = 1 },
    prompt_prefix = '   ',
    selection_caret = '  ',
    layout_config = {
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    mappings = {
      i = {
        ['<esc>'] = actions.close,
        ['<C-Down>'] = actions.cycle_history_next,
        ['<C-Up>'] = actions.cycle_history_prev,
      },
    },
    file_ignore_patterns = { '.git/' },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    buffers = {
      previewer = false,
      layout_config = {
        width = 80,
      },
    },
    oldfiles = {
      prompt_title = 'History',
    },
    lsp_references = {
      previewer = false,
    },
  },
})

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'live_grep_args')

local keymap = vim.keymap.set
local builtin = require('telescope.builtin')
local lga = require('telescope').extensions.live_grep_args
local opts = function(desc) return { noremap = true, silent = true, desc = desc } end

-- file search
keymap('n', '<leader>f', builtin.find_files, { desc = 'Find files' })
keymap('n', '<leader>F', function()
  builtin.find_files({ no_ignore = true, prompt_title = 'All Files (no .gitignore)' })
end, { desc = 'Find all files (no ignore)' })

-- buffer & history
keymap('n', '<leader>b', builtin.buffers, { desc = 'List of buffers' })
keymap('n', '<leader>h', builtin.oldfiles, { desc = 'Recent files (history)' })

-- grep
keymap('n', '<leader>g', lga.live_grep_args, { desc = 'Grep with args (LGA)' })

-- symbols in file
keymap('n', '<leader>s', builtin.lsp_document_symbols, { desc = 'Document symbol (LSP)' })

-- LSP navigation via Telescope
keymap('n', 'gd', builtin.lsp_definitions, opts('Telescope: Go to definition'))
keymap('n', 'gy', builtin.lsp_type_definitions, opts('Telescope: Go to type definition'))
keymap('n', 'gi', builtin.lsp_implementations, opts('Telescope: Go to implementations'))
keymap('n', 'gr', builtin.lsp_references, opts('Telescope: List references'))
-- keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
-- keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
-- keymap('n', 'gi', ':Telescope lsp_implementations<CR>')
-- keymap('n', 'gr', ':Telescope lsp_references<CR>')
