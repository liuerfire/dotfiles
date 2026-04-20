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
vim.o.cursorline = true


local function map(mode, lhs, rhs, desc, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { desc = desc, silent = true }, opts or {}))
end

local general_augroup = vim.api.nvim_create_augroup("general_augroup", { clear = true })
local lsp_augroup = vim.api.nvim_create_augroup("lsp_augroup", { clear = true })
local format_augroup = vim.api.nvim_create_augroup("format_augroup", { clear = true })

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
  pattern = {"java", "python", "rust" },
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

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_text = false,
  virtual_lines = false,

  jump = { float = true },
}

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

local function gh(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  { src = gh("folke/tokyonight.nvim") },
  { src = gh("Mofiqul/adwaita.nvim") },
  { src = gh("Mofiqul/vscode.nvim") },
  { src = gh("folke/snacks.nvim") },
  { src = gh("saghen/blink.cmp") },
  { src = gh("L3MON4D3/LuaSnip") },
  { src = gh("rafamadriz/friendly-snippets") },
  { src = gh("neovim/nvim-lspconfig") },
}, { confirm = false, load = true })

local Snacks = require("snacks")
local luasnip = require("luasnip")

Snacks.setup({
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
})

local lsp_progress = {}

local function lsp_progress_message(value)
  local parts = {}

  if value.title and value.title ~= "" then
    table.insert(parts, value.title)
  end

  if value.message and value.message ~= "" then
    table.insert(parts, value.message)
  end

  local msg = table.concat(parts, " ")
  if value.percentage then
    msg = msg ~= "" and ("%s (%s%%)"):format(msg, value.percentage) or ("%s%%"):format(value.percentage)
  end

  return msg ~= "" and msg or "Working"
end

vim.api.nvim_create_autocmd("LspProgress", {
  group = lsp_augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local params = args.data.params
    local value = params.value
    local id = ("lsp-progress-%s-%s"):format(client.id, tostring(params.token))

    if value.kind == "end" then
      local notif = lsp_progress[id]
      local msg = value.message
        or (notif and notif.message)
        or value.title
        or "Done"

      Snacks.notifier.notify(msg, vim.log.levels.INFO, {
        id = id,
        title = client.name,
        timeout = 1500,
      })
      lsp_progress[id] = nil
      return
    end

    local msg = lsp_progress_message(value)
    lsp_progress[id] = { message = msg }
    Snacks.notifier.notify(msg, vim.log.levels.INFO, {
      id = id,
      title = client.name,
      timeout = false,
    })
  end,
  desc = "Show LSP progress in Snacks notifier",
})

require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = { auto_show = true },
    list = {
      selection = { preselect = false },
    },
  },
  snippets = { preset = "luasnip" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = {
    implementation = "lua",
  },
  signature = {
    enabled = true,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local opts = { buffer = args.buf }
    map("n", "gd", vim.lsp.buf.definition, "Go to definition", opts)
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration", opts)
    map("n", "K", vim.lsp.buf.hover, "Hover", opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action", opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol", opts)
    map("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = false })
    end, "Format buffer", opts)

    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = format_augroup, buffer = args.buf })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_augroup,
        buffer = args.buf,
        callback = function(event)
          local filetype = vim.bo[event.buf].filetype
          local format_on_save_filetypes = {
            python = true,
            go = true,
            rust = true,
            javascript = true,
            javascriptreact = true,
            typescript = true,
            typescriptreact = true,
          }

          if format_on_save_filetypes[filetype] then
            vim.lsp.buf.format({ bufnr = event.buf, id = client.id, async = false })
          end
        end,
        desc = "Format supported buffers on save",
      })
    end
  end,
})

local blink_capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("ty", {
  capabilities = blink_capabilities,
})

vim.lsp.config("gopls", {
  capabilities = blink_capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
    },
  },
})

vim.lsp.config("rust_analyzer", {
  capabilities = blink_capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
    },
  },
})

vim.lsp.config("ts_ls", {
  capabilities = blink_capabilities,
})

vim.lsp.enable({ "ty", "gopls", "rust_analyzer", "ts_ls" })

map("n", "<leader>af", function()
  Snacks.picker.files({
    hidden = true,
    ignored = true,
    exclude = { ".git" },
  })
end, "Find all files")
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, "Find files")
map("n", "<leader>bb", function()
  Snacks.picker.buffers()
end, "Find buffers")
map("n", "<leader>ee", function()
  Snacks.explorer()
end, "Explorer")
map("n", "<leader>rg", function()
  Snacks.picker.grep_word()
end, "Grep string")
map("n", "<leader>xx", function()
  Snacks.picker.diagnostics()
end, "Workspace diagnostics")
map("n", "<leader>co", function()
  Snacks.picker.lsp_symbols()
end, "Document symbols")
map("n", "<leader>xb", function()
  Snacks.picker.diagnostics_buffer()
end, "Buffer diagnostics")
map("n", "gi", function()
  Snacks.picker.lsp_implementations()
end, "Go to implementation")
map("n", "gr", function()
  Snacks.picker.lsp_references()
end, "Find references")
map("n", "<leader>/", function()
  Snacks.picker.grep()
end, "Live grep")
map("n", "<leader>tt", function()
  Snacks.terminal()
end, "Toggle terminal")

if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/local.lua") == 1 then
  require("local")
end
