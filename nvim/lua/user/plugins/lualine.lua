local separator = { '"▏"', color = 'StatusLineNonText' }
require('lualine').setup({
  options = {
    section_separators = '',
    component_separators = '',
    globalstatus = true,
    theme = {
      normal = {
        a = 'StatusLine',
        b = 'StatusLine',
        c = 'StatusLine',
      },
    },
  },
  sections = {
    lualine_a = {
      'mode',
      separator,
    },
    lualine_b = {
      'branch',
      {
        'diff',
        color = { fg = '#1c1c1c' }
      },
      separator,
      '"🖧  " .. tostring(#vim.tbl_keys(vim.lsp.get_clients()))',
      { 'diagnostics', sources = { 'nvim_diagnostic' } },
      separator,
    },
    lualine_c = {
      'filename'
    },
    lualine_x = {
      {
        'filetype',
        color =  { fg = '#1c1c1c' },
      },
      'encoding',
      'fileformat',
    },
    lualine_y = {
      separator,
      '(vim.bo.expandtab and "󱁐 " or "⇥ ") .. " " .. vim.bo.shiftwidth',
      separator,
    },
    lualine_z = {
      'location',
      'progress',
    },
  },
})
