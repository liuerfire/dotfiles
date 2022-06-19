require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'c', 'cpp', 'go', 'java', 'javascript', 'lua', 'make', 
    'python', 'rust', 'typescript',
  },
  sync_install = false,
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
