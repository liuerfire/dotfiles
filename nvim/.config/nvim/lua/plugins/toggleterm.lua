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

vim.keymap.set('n', '<A-:>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>')
vim.keymap.set('n', '<A-;>', '<Cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>')
vim.keymap.set('n', '<A-S-t>', '<Cmd>exe v:count1 . "ToggleTerm direction=tab"<CR>')
vim.keymap.set('n', '<leader>tt', '<Cmd>ToggleTerm direction=float<CR>')
vim.api.nvim_create_user_command('FloatTerm', 'ToggleTerm direction=float', {})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<A-;>', [[<C-\><C-n>:ToggleTerm<cr>]], opts)
end

vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
