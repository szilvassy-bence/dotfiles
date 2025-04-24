-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local plugins = {
  {
    'jessarcher/onedark.nvim',
    config = function()
      vim.cmd('colorscheme retrobox')

      vim.api.nvim_set_hl(0, 'FloatBorder', {
        fg = vim.api.nvim_get_hl_by_name('NormalFloat', true).background,
        bg = vim.api.nvim_get_hl_by_name('NormalFloat', true).background,
      })

      -- Make the cursor line background invisible
      vim.api.nvim_set_hl(0, 'CursorLineBg', {
        fg = vim.api.nvim_get_hl_by_name('CursorLine', true).background,
        bg = vim.api.nvim_get_hl_by_name('CursorLine', true).background,
      })

      vim.api.nvim_set_hl(0, 'NvimTreeIndentMarker', { fg = '#30323E' })

      vim.api.nvim_set_hl(0, 'StatusLineNonText', {
        -- fg = vim.api.nvim_get_hl_by_name('NonText', true).background,
        bg = vim.api.nvim_get_hl_by_name('StatusLine', true).foreground,
      })

      vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = '#2F313C' })
    end,
  },
  {'tpope/vim-commentary'},
  {'tpope/vim-surround'},
  {'tpope/vim-eunuch'},
  {'tpope/vim-unimpaired'},
  {'tpope/vim-sleuth'},
  {'tpope/vim-repeat'},
  -- {'sheerun/vim-polyglot'},
  {'christoomey/vim-tmux-navigator'},
  {'farmergreg/vim-lastplace'},
  {'nelstrom/vim-visual-star-search'},
  {
    'whatyouhide/vim-textobj-xmlattr',
    dependencies = 'kana/vim-textobj-user',
  },
  {'jessarcher/vim-heritage'},
  {
    'airblade/vim-rooter',
    setup = function()
      -- Instead of this running every time we open a file, we'll just run it once when Vim starts.
      vim.g.rooter_manual_only = 1
    end,
    config = function()
      vim.cmd('Rooter')
    end,
  },
  {'windwp/nvim-autopairs', opts = {} },
  {'karb94/neoscroll.nvim', opts = {} },
  {
    'famiu/bufdelete.nvim',
    config = function()
      vim.keymap.set('n', '<Leader>q', ':Bdelete<CR>')
    end,
  },
  {
    'AndrewRadev/splitjoin.vim',
    config = function()
      vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
      vim.g.splitjoin_trailing_comma = 1
      vim.g.splitjoin_php_method_chain_full = 1
    end,
  },
  {
    'sickill/vim-pasta',
    config = function()
      vim.g.pasta_disabled_filetypes = { 'fugitive' }
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-live-grep-args.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('user.plugins.telescope')
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('user/plugins/nvim-tree')
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('user/plugins/lualine')
    end,
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    after = 'onedark.nvim',
    config = function()
      require('user/plugins/bufferline')
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}
  },
  {
    'glepnir/dashboard-nvim',
    config = function()
      require('user/plugins/dashboard-nvim')
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({ current_line_blame = true })
      vim.keymap.set('n', ']h', ':Gitsigns next_hunk<CR>')
      vim.keymap.set('n', '[h', ':Gitsigns prev_hunk<CR>')
      vim.keymap.set('n', 'gs', ':Gitsigns stage_hunk<CR>')
      vim.keymap.set('n', 'gS', ':Gitsigns undo_stage_hunk<CR>')
      vim.keymap.set('n', 'gp', ':Gitsigns preview_hunk<CR>')
      vim.keymap.set('n', 'gb', ':Gitsigns blame_line<CR>')
    end,
  },
  {
    'tpope/vim-fugitive',
    dependencies = 'tpope/vim-rhubarb',
  },
  {
    'voldikss/vim-floaterm',
    config = function()
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_height = 0.8
      -- vim.g.floaterm_wintype = 'split'
      vim.keymap.set('n', '<F1>', ':FloatermToggle<CR>')
      vim.keymap.set('t', '<F1>', '<C-\\><C-n>:FloatermToggle<CR>')
      vim.cmd([[
      highlight link Floaterm CursorLine
      highlight link FloatermBorder CursorLineBg
      ]])
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('user/plugins/treesitter')
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'b0o/schemastore.nvim',
      'nvimtools/none-ls.nvim',
      'jayp0521/mason-null-ls.nvim',
      'neovim/nvim-lspconfig'
    },
    config = function()
      require('user/plugins/lspconfig')
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind-nvim',
    },
    config = function()
      require('user/plugins/cmp')
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
    config = function()
      require('user/plugins/render-markdown')
    end,
  },
  {
    'phpactor/phpactor',
    ft = 'php',
    build = 'composer install --no-dev --optimize-autoloader',
    config = function()
      vim.keymap.set('n', '<Leader>pm', ':PhpactorContextMenu<CR>')
      vim.keymap.set('n', '<Leader>pn', ':PhpactorClassNew<CR>')
    end,
  },
  {
    'tpope/vim-projectionist',
    dependencies = 'tpope/vim-dispatch',
    config = function()
      require('user/plugins/projectionist')
    end,
  },
  {
    'vim-test/vim-test',
    config = function()
      require('user/plugins/vim-test')
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "coffebar/transfer.nvim",
    cmd = { "TransferInit", "DiffRemote", "TransferUpload", "TransferDownload", "TransferDirDiff", "TransferRepeat" },
    opts = {
      upload_method = "rsync",
      upload_rsync_params = {
        "-rlzi",
        "--delete",
        "--checksum",
        "--exclude", ".git",
        "--exclude", ".idea",
        "--exclude", ".DS_Store",
        "--exclude", ".nvim",
        "--exclude", "*.pyc",
      }
    },
  },
}

-- Setup lazy.nvim
require("lazy").setup(plugins)

-- Vim command to change the line to All Starting Capitals
vim.api.nvim_create_user_command('Title', function()
  local current_line = vim.fn.getline(".")

  -- Escape the line to safely pass it to the shell
  local escaped_line = vim.fn.shellescape(current_line)

  -- Pass the escaped line to the title script
  local output = vim.fn.system('title ' .. escaped_line)

  -- Optionally, replace the current line with the output from the script
  vim.fn.setline(".", output)
end, {})
