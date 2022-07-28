require('lualine').setup {
  sections = {
    lualine_b = {
      { 'branch' }, { 'diff' },
      {
        "diagnostics",
        sources = { 'nvim_workspace_diagnostic', 'nvim_lsp', 'nvim_diagnostic' },
      },
    },
    lualine_c = {
      { 'filename', path = 3, },
    },
  },
  options = {
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    globalstatus = true,
  },
  extensions = { 'toggleterm' },
}
