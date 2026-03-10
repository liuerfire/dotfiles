vim.g.mapleader = " "
vim.keymap.set({ "n", "x" }, "<Space>", "<Nop>", { silent = true })

vim.opt.termguicolors = true
vim.opt.mouse = "n"
vim.opt.swapfile = false
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = "tab:⇢ ,eol:¬,trail:·,extends:↷,precedes:↶"
vim.opt.showbreak = "↪"
vim.opt.inccommand = "split"
vim.opt.completeopt = "menu,menuone,noselect"

local function map(mode, lhs, rhs, desc, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { desc = desc, silent = true }, opts or {}))
end

local general_augroup = vim.api.nvim_create_augroup("general_augroup", { clear = true })
local treesitter_augroup = vim.api.nvim_create_augroup("treesitter_augroup", { clear = true })
local lsp_augroup = vim.api.nvim_create_augroup("lsp_augroup", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("FileType", {
  group = general_augroup,
  pattern = { "go", "make", "gitconfig" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = general_augroup,
  pattern = "java",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = general_augroup,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 1 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Jump to the last position",
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = general_augroup,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Do not auto comment new lines",
})

map("", "Q", "<Nop>", "Disable Ex mode")
map("n", "<leader>n", "<cmd>nohlsearch<cr>", "Clear search highlight")
map("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, "Move by display line", { expr = true })
map("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, "Move by display line", { expr = true })
map("n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<A-.>", "<cmd>tabnext<cr>", "Next tab")
map("n", "<A-,>", "<cmd>tabprevious<cr>", "Previous tab")
map("n", "<leader>p", '"+p', "Paste from system clipboard")
map("n", "<leader>P", '"+P', "Paste before from system clipboard")
map("x", "<leader>p", '"+p', "Paste from system clipboard")
map("v", "<leader>y", '"+y', "Yank to system clipboard")
map("n", "Y", "y$", "Yank to end of line")
map("t", "<C-[>", "<C-\\><C-n>", "Exit terminal mode")

vim.api.nvim_create_user_command("CopyFilePath", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Copy the relative file path" })

vim.api.nvim_create_user_command("CopyFileAbsPath", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy the absolute file path" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 or not vim.uv.fs_stat(lazypath) then
    vim.api.nvim_echo({
      { "Failed to install lazy.nvim.\n", "ErrorMsg" },
      { output,                           "WarningMsg" },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "Mofiqul/adwaita.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.icons").setup()
      require("mini.comment").setup()
      require("mini.trailspace").setup()
      require("mini.align").setup()
      require("mini.git").setup()
      require("mini.diff").setup()
      require("mini.statusline").setup({
        use_icons = true,
        content = {
          active = function()
            local statusline = require("mini.statusline")
            local icons = require("mini.icons")
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local search = statusline.section_searchcount({ trunc_width = 75 })
            local location = "%2l:%-2v"
            local filetype = vim.bo.filetype
            local filetype_icon = ""

            if filetype ~= "" then
              local ok, icon = pcall(icons.get, "filetype", filetype)
              if ok then
                filetype_icon = icon
              end
            end

            return statusline.combine_groups({
              { hl = mode_hl,                  strings = { mode } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filetype_icon, filename } },
              "%=",
              { hl = mode_hl, strings = { search, location } },
            })
          end,
        },
      })

      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>af",
        function()
          Snacks.picker.files({
            hidden = true,
            ignored = true,
            exclude = { ".git" },
          })
        end,
        desc = "Find all files",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find files",
      },
      { "<leader>bb", function() Snacks.picker.buffers() end,     desc = "Find buffers" },
      { "<leader>ee", function() Snacks.explorer() end,           desc = "Explorer" },
      { "<leader>rg", function() Snacks.picker.grep_word() end,   desc = "Grep string" },
      { "<leader>xx", function() Snacks.picker.diagnostics() end, desc = "Workspace diagnostics" },
      { "<leader>co", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
      {
        "<leader>xb",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer diagnostics",
      },
      {
        "gi",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Go to implementation",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "Find references",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Live grep",
      },
      { "<leader>tt", function() Snacks.terminal() end, desc = "Toggle terminal" },
    },
    opts = {
      explorer = { enabled = true },
      notifier = {
        enabled = true,
        top_down = false,
      },
      picker = {
        enabled = true,
        actions = {
          clear_input = function(picker)
            picker.input:set("", "")
            picker:find()
          end,
        },
        win = {
          input = {
            keys = {
              ["<C-[>"] = { "close", mode = { "i" } },
              ["<C-u>"] = { "clear_input", mode = { "i" } },
            },
          },
          list = {
            keys = {
              ["<C-[>"] = "cancel",
            },
          },
          preview = {
            keys = {
              ["<C-[>"] = "cancel",
            },
          },
        },
      },
      terminal = { enabled = true },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      local parsers = {
        "bash",
        "c",
        "cpp",
        "diff",
        "go",
        "java",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      }

      vim.api.nvim_create_user_command("TSInstallAll", function()
        treesitter.install(parsers)
      end, { desc = "Install configured Tree-sitter parsers" })

      vim.api.nvim_create_autocmd("FileType", {
        group = treesitter_augroup,
        callback = function(args)
          if vim.bo[args.buf].buftype ~= "" then
            return
          end

          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
        desc = "Enable Tree-sitter highlighting and indentation",
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = {}
  },

  { "neovim/nvim-lspconfig" },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,
      formatters = {
        isort = {
          prepend_args = { "--sl" },
        },
      },
    },
  },

  {
    "Saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts_extend = { "sources.default" },
    opts = {
      keymap     = {
        preset = "default",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        documentation = {
          auto_show = true,
        },
      },
      signature  = { enabled = true },
      sources    = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy      = {
        implementation = "prefer_rust",
      },
    },
  },
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  bang = true,
  desc = "Disable autoformat-on-save",
})

vim.api.nvim_create_user_command("FormatEnable", function(args)
  if args.bang then
    vim.b.disable_autoformat = false
  else
    vim.g.disable_autoformat = false
  end
end, {
  bang = true,
  desc = "Enable autoformat-on-save",
})

local base_capabilities = vim.lsp.protocol.make_client_capabilities()
base_capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
local capabilities = require("blink.cmp").get_lsp_capabilities(base_capabilities)

for _, server in ipairs({ "clangd", "gopls", "pyright", "rust_analyzer", "ts_ls" }) do
  vim.lsp.config(server, {
    capabilities = capabilities,
  })
  vim.lsp.enable(server)
end

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
})
vim.lsp.enable("lua_ls")

local function goto_definition_in(command)
  return function()
    vim.cmd(command)
    vim.lsp.buf.definition()
  end
end

vim.api.nvim_create_autocmd("LspProgress", {
  group = lsp_augroup,
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local status = vim.lsp.status()
    if status == "" then
      return
    end

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(status, vim.log.levels.INFO, {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        local value = ev.data and ev.data.params and ev.data.params.value
        local kind = type(value) == "table" and value.kind or nil
        notif.icon = kind == "end" and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_augroup,
  callback = function(args)
    local opts = { buffer = args.buf }

    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover", silent = true }))
    vim.keymap.set(
      "n",
      "gd",
      vim.lsp.buf.definition,
      vim.tbl_extend("force", opts, { desc = "Go to definition", silent = true })
    )
    vim.keymap.set(
      "n",
      "gxd",
      goto_definition_in("split"),
      vim.tbl_extend("force", opts, { desc = "Go to definition in split", silent = true })
    )
    vim.keymap.set(
      "n",
      "gvd",
      goto_definition_in("vsplit"),
      vim.tbl_extend("force", opts, { desc = "Go to definition in vsplit", silent = true })
    )
    vim.keymap.set(
      "n",
      "gtd",
      goto_definition_in("tab split"),
      vim.tbl_extend("force", opts, { desc = "Go to definition in tab", silent = true })
    )
    vim.keymap.set(
      "n",
      "gD",
      vim.lsp.buf.type_definition,
      vim.tbl_extend("force", opts, { desc = "Go to type definition", silent = true })
    )
    vim.keymap.set(
      "n",
      "<leader>rn",
      vim.lsp.buf.rename,
      vim.tbl_extend("force", opts, { desc = "Rename symbol", silent = true })
    )
    vim.keymap.set(
      "n",
      "<leader>ca",
      vim.lsp.buf.code_action,
      vim.tbl_extend("force", opts, { desc = "Code action", silent = true })
    )
  end,
})

vim.diagnostic.config({
  float = { border = "rounded" },
  severity_sort = true,
  underline = true,
  virtual_text = false,
  signs = true,
})

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, "Previous diagnostic")
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, "Next diagnostic")

if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/local.lua") == 1 then
  require("local")
end
