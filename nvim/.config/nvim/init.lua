local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  Packer_bootstrap = vim.fn.system {
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  -- https://github.com/wbthomason/packer.nvim/issues/750
  table.insert(vim.opt.runtimepath, 1, vim.fn.stdpath('data') .. '/site/pack/*/start/*')
end

require('packer').startup(function(use)
  -- make sure to add this line to let packer manage itself
  use 'wbthomason/packer.nvim'

  use 'sainnhe/gruvbox-material'
  use 'Mofiqul/vscode.nvim'
  use 'Mofiqul/adwaita.nvim'
  use 'kyazdani42/nvim-web-devicons'

  use 'editorconfig/editorconfig-vim'
  use 'junegunn/vim-easy-align'

  use 'nathangrigg/vim-beancount'
  use 'google/vim-jsonnet'
  use 'hashivim/vim-terraform'

  use {
    'kylechui/nvim-surround',
    config = function() require('nvim-surround').setup() end
  }

  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup {
        view = {
          adaptive_size = true,
        },
        update_focused_file = {
          enable = true,
        }
      }
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function() require('plugins.telescope') end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('plugins.nvim-treesitter') end,
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        filetype = { 'python', 'yaml' }
      }
    end,
  }

  use {
    'NvChad/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end,
  }

  use {
    'nvim-lualine/lualine.nvim',
    config = function() require('plugins.lualine') end,
  }

  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'mfussenegger/nvim-jdtls',
      'jose-elias-alvarez/null-ls.nvim',
      'jose-elias-alvarez/typescript.nvim',
    },
    config = function() require('plugins.lspconfig') end,
  }

  use {
    'kosayoda/nvim-lightbulb',
    requires = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
    end,
  }

  use {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup() end,
  }

  use {
    'stevearc/dressing.nvim',
    config = function() require('dressing').setup() end,
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind.nvim',
    },
    config = function() require('plugins.cmp') end,
  }

  use {
    'akinsho/toggleterm.nvim',
    config = function() require('plugins.toggleterm') end,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if Packer_bootstrap then
    require('packer').sync()
  end

end)

require('settings')
require('keymaps')

if vim.fn.filereadable(vim.fn.stdpath 'config' .. '/lua/local.lua') == 1 then
  require('local')
end
