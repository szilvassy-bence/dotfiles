require('nvim-tree').setup({
  git = {
    ignore = false,
  },
  actions = {
    open_file = {
      quit_on_open = true, -- This closes the tree when a file is opened.
    },
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        folder_arrow = false,
      },
    },
    indent_markers = {
      enable = true,
    },
  },
})

vim.keymap.set('n', '<Leader>n', ':NvimTreeFindFileToggle<CR>')
