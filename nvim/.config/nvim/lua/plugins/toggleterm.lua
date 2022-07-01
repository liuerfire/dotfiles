local toggleterm = require('toggleterm')

toggleterm.setup {
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
}

vim.keymap.set('n', '<A-;>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>')
vim.keymap.set('n', '<A-:>', '<Cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>')
vim.keymap.set('n', '<leader>tt', '<Cmd>ToggleTerm direction=float<CR>')
vim.api.nvim_create_user_command('FloatTerm', 'ToggleTerm direction=float', {})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<A-;>', [[<C-\><C-n>:ToggleTerm<cr>]], opts)
end

vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
