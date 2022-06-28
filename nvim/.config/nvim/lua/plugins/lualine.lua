require('lualine').setup {
  sections = {
    lualine_b = {
      { 'branch' }, { 'diff' },
      {
        "diagnostics",
        sources = {
          function()
            local diag_severity = vim.diagnostic.severity

            local function workspace_diag(severity)
              local count = vim.diagnostic.get(nil, { severity = severity })
              return vim.tbl_count(count)
            end

            return {
              error = workspace_diag(diag_severity.ERROR),
              warn = workspace_diag(diag_severity.WARN),
              info = workspace_diag(diag_severity.INFO),
              hint = workspace_diag(diag_severity.HINT)
            }
          end,
        },
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
}
