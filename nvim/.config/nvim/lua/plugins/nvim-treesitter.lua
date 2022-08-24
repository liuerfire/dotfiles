require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash', 'c', 'comment', 'cpp', 'css', 'go', 'html', 'java', 'javascript',
    'lua', 'make', 'python', 'rust', 'sql', 'typescript', 'tsx',
  },
  sync_install = false,
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
}
