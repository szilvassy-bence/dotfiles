-- Space s my leader.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided.
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Reselect visual selection after indenting.
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Maintain the cursor position when yanking a visual selection.
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.keymap.set('v', 'y', 'myy`y')

-- Disable annoying command line typo.
vim.keymap.set('n', 'q:', ':q')

-- Paste replace visual selection without copying it.
vim.keymap.set('v', 'pp', '"_dP', { noremap = true, silent = true })

-- Remap Ctrl+Q to enter visual block mode (instead of Ctrl+V)
vim.api.nvim_set_keymap('n', '<C-q>', '<C-v>', { noremap = true, silent = true })

-- Easy insertion of a trailing ; or , from insert mode.
vim.keymap.set('i', ';;', '<Esc>A;')
vim.keymap.set('i', ',,', '<Esc>A,')
vim.keymap.set('i', '{{', '<Esc>A {}<Esc>i')
vim.keymap.set('i', '==', '<Esc>A =<Esc>A ')

-- Quickly clear search highlighting.
vim.keymap.set('n', '<Leader>k', ':nohlsearch<CR>')

-- Open the current file in the default program
vim.keymap.set('n', '<Leader>x', ':!xdg-open %<CR><CR>')

-- Move lines up and down.
vim.keymap.set('i', '<A-j>', '<Esc>:move .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:move .-2<CR>==gi')
vim.keymap.set('n', '<A-j>', ':move .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':move .-2<CR>==')
vim.keymap.set('v', '<A-j>', ":move '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":move '<-2<CR>gv=gv")

-- Bufferline
vim.api.nvim_set_keymap('n', '<leader>xo', ':BufferLineCloseOthers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>xx', ':bdelete<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>tt', ':Title<CR>', { noremap = true, silent = true })

-- Move split
vim.api.nvim_set_keymap('n', '<Leader>mh', ':vertical resize -5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ml', ':vertical resize +5<CR>', { noremap = true, silent = true })

-- Copy the current file's absolute file path to the buffer
vim.keymap.set('n', '<leader>cp', function()
  local filename = vim.fn.expand("%:p") -- Get the full path of the current buffer
  vim.fn.setreg("+", filename)           -- Set the clipboard register to the filename
  print("Filename copied to clipboard: " .. filename) -- Optional: Display a message
end, { noremap = true, silent = true })

-- Links
-- vim.keymap.set("n", "gl", function()
--   local link = vim.fn.expand("<cWORD>")
--   if link:match("^#") then
--     local anchor = link:sub(2):gsub("-", " ")
--     vim.cmd("normal! gg")vim.keymap.set("n", "gl", function()
--         local link = vim.fn.expand("<cWORD>")
--           if link:match("^#") then
--                 local anchor = link:sub(2):gsub("-", " ")
--                     vim.cmd("normal! gg")
--                         vim.fn.search("^##* " .. anchor)
--                           end
--                         end, { desc = "Jump to Markdown anchor" })
--     vim.fn.search("^##* " .. anchor)
--   end
-- end, { desc = "Jump to Markdown anchor" })
