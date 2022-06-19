local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

require("packer").startup(function(use)
  -- make sure to add this line to let packer manage itself
  use 'wbthomason/packer.nvim'

  use 'liuerfire/vim-code-dark'
  use 'sainnhe/edge'
  use 'sainnhe/gruvbox-material'
  use 'eemed/sitruuna.vim'
  use 'kyazdani42/nvim-web-devicons'

  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'machakann/vim-sandwich'
  use 'editorconfig/editorconfig-vim'
  use 'junegunn/vim-easy-align'

  use 'nathangrigg/vim-beancount'
  use 'google/vim-jsonnet'

  -- https://github.com/neovim/neovim/issues/12587
  use {
    'antoinemadec/FixCursorHold.nvim',
    config = function()
      vim.g.cursorhold_updatetime = 100
    end,
  }

  use 'kyazdani42/nvim-tree.lua'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
      {'nvim-telescope/telescope-live-grep-args.nvim'},
      {'nvim-telescope/telescope-ui-select.nvim'},
    },
    config = function() require('plugins.telescope') end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('plugins.nvim-treesitter') end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function() 
      require('indent_blankline').setup {
        filetype = { 'python', 'yaml' }
      }
    end,
  }

  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
  }

  use 'williamboman/nvim-lsp-installer'
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'mfussenegger/nvim-jdtls',
      'jose-elias-alvarez/null-ls.nvim',
    },
    config = function() require('plugins.lspconfig') end
  }
  use {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {
        auto_close = true,
      }
    end
  }

  use { 
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup() end
  }

  use {
    'kosayoda/nvim-lightbulb',
    config = function()
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        pattern = '*',
        callback = function()
          require('nvim-lightbulb').update_lightbulb()
        end,
        desc = 'VSCode 💡 for neovim\'s built-in LSP',
      })
    end,
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
    },
    config = function() require('plugins.cmp') end,
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

require('nvim-tree').setup {
  view = {
    adaptive_size = true,
  },
  update_focused_file = {
    enable = true,
  }
}
