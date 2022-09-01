local vi_mode_utils = require('feline.providers.vi_mode')

local components = {
  active = {},
  inactive = {},
}

components.active[1] = {
  {
    provider = function()
      return ' ' .. vi_mode_utils.get_vim_mode() .. ' '
    end,
    hl = function()
      return {
        name = vi_mode_utils.get_mode_highlight_name(),
        style = 'bold',
      }
    end,
    right_sep = ' ',
    icon = '',
  },
  {
    provider = {
      name = 'file_info',
      opts = {
        type = 'relative',
      },
    },
    hl = {
      fg = 'NONE',
      style = 'bold',
    },
    right_sep = ' ',
  },
}

components.active[2] = {
  {
    provider = 'diagnostic_errors',
    hl = { fg = 'red' },
  },
  {
    provider = 'diagnostic_warnings',
    hl = { fg = 'yellow' },
  },
  {
    provider = 'diagnostic_hints',
    hl = { fg = 'cyan' },
  },
  {
    provider = 'diagnostic_info',
    hl = { fg = 'skyblue' },
  },
}

components.active[3] = {
  {
    provider = 'position',
    left_sep = ' ',
    right_sep = ' ',
  },
  {
    provider = 'line_percentage',
    hl = {
      style = 'bold',
    },
    right_sep = ' ',
  },
  {
    provider = 'scroll_bar',
    hl = {
      fg = 'skyblue',
      style = 'bold',
    },
  },
}

components.inactive[1] = {
  {
    provider = 'file_info',
    hl = {
      style = 'bold',
    },
  },
  -- Empty component to fix the highlight till the end of the statusline
  {},
}


require("feline").setup({
  components = components,
})
