-- ==============================================================================
-- 1. Leader & Global Settings
-- ==============================================================================

-- Leader keys must be configured before any mappings or plugins are loaded so
-- that all `<leader>` and `<localleader>` bindings resolve to the right prefix.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw early because `snacks.explorer` replaces built-in directory browsing.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ==============================================================================
-- 2. Editor Options
-- ==============================================================================

local opt = vim.opt

-- UI & Appearance
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"       -- Always reserve gutter space to avoid text shifting
opt.winborder = "rounded"    -- Native Neovim 0.11+ default border for floating windows
opt.laststatus = 3           -- Global statusline across all splits
opt.scrolloff = 8            -- Keep context lines visible above/below cursor
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.showmatch = true

-- Editing & Indentation (2 spaces by default; overridden per filetype below)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.shiftround = true        -- Round indent to multiple of shiftwidth
opt.virtualedit = "block"    -- Allow cursor to move past EOL in visual block mode

-- Whitespace & Wrapping
opt.wrap = false
opt.linebreak = true         -- When wrap is toggled on, break at word boundaries
opt.showbreak = "↪ "
opt.list = true
opt.listchars = {
  tab = "⇢ ",
  trail = "·",
  extends = "↷",
  precedes = "↶",
  nbsp = "␣",
}

-- Search & Substitution
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"     -- Live preview of :substitute in a split

-- Splits & Windows
opt.splitright = true
opt.splitbelow = true

-- Persistence, Recovery & Responsiveness
opt.swapfile = false
opt.undofile = true          -- Persistent undo history across sessions
opt.updatetime = 200         -- Faster CursorHold & diagnostic updates
opt.confirm = true           -- Prompt to save before closing unsaved buffers

-- Completion & Mouse
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("WcI")  -- Suppress intro screen and noisy completion messages
opt.mouse = "a"

-- ==============================================================================
-- 3. Helper Utilities & Diagnostics
-- ==============================================================================

local function map(mode, lhs, rhs, desc, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { desc = desc, silent = true }, opts or {}))
end

local function gh(repo)
  return "https://github.com/" .. repo
end

-- Display high-signal diagnostics without cluttering inline code during typing.
vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = false,
  virtual_lines = false,
  jump = { float = true },
})

-- ==============================================================================
-- 4. Autocommands & User Commands
-- ==============================================================================

local general_augroup = vim.api.nvim_create_augroup("general_augroup", { clear = true })
local lsp_augroup = vim.api.nvim_create_augroup("lsp_augroup", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = general_augroup,
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

vim.api.nvim_create_autocmd("FileType", {
  group = general_augroup,
  pattern = { "go", "make", "gitconfig" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = false
  end,
  desc = "Use 4-column hard tabs for Go, Make, and Gitconfig",
})

vim.api.nvim_create_autocmd("FileType", {
  group = general_augroup,
  pattern = { "java", "python", "rust" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
  desc = "Use 4-space indentation for Java, Python, and Rust",
})

-- Restore cursor to last known position when opening a normal file buffer,
-- skipping git commit/rebase buffers where starting at line 1 is expected.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = general_augroup,
  callback = function(args)
    local exclude = { gitcommit = true, gitrebase = true }
    local buf = args.buf
    if exclude[vim.bo[buf].filetype] or vim.bo[buf].buftype ~= "" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore last cursor position on file open",
})

vim.api.nvim_create_autocmd("FileType", {
  group = general_augroup,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable automatic comment continuation on new lines",
})

-- Close transient utility windows with `q` for ergonomic navigation.
vim.api.nvim_create_autocmd("FileType", {
  group = general_augroup,
  pattern = { "help", "qf", "lspinfo", "man", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    map("n", "q", "<cmd>close<cr>", "Close utility window", { buffer = event.buf })
  end,
  desc = "Close utility buffers with q",
})

-- Automatically resize splits when the host terminal window is resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = general_augroup,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  desc = "Keep split proportions balanced on terminal resize",
})

vim.api.nvim_create_user_command("CopyFilePath", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path to system clipboard" })

vim.api.nvim_create_user_command("CopyFileAbsPath", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute file path to system clipboard" })

-- ==============================================================================
-- 5. Core Keymaps (Plugin-Independent)
-- ==============================================================================

map({ "n", "x" }, "<Space>", "<Nop>", "Leader prefix")
map("", "Q", "<Nop>", "Disable Ex mode")
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")

-- Navigate wrapped display lines naturally unless a count is given.
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", "Down (display line)", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", "Up (display line)", { expr = true })

-- Keep cursor centered during half-page scrolling and search jumps.
map("n", "<C-d>", "<C-d>zz", "Scroll down half page and center")
map("n", "<C-u>", "<C-u>zz", "Scroll up half page and center")
map("n", "n", "nzzzv", "Next search result (centered)")
map("n", "N", "Nzzzv", "Previous search result (centered)")

-- Join lines without jumping the cursor to the end of the line.
map("n", "J", "mzJ`z", "Join lines keeping cursor position")

-- Move selected lines up/down in visual mode with automatic re-indentation.
map("x", "J", ":m '>+1<cr>gv=gv", "Move selection down")
map("x", "K", ":m '<-2<cr>gv=gv", "Move selection up")

-- Keep visual selection active when indenting.
map("x", "<", "<gv", "Indent left and reselect")
map("x", ">", ">gv", "Indent right and reselect")

-- Paste over visual selection without overwriting the unnamed yank register.
map("x", "p", "P", "Paste without clobbering yank register")

-- Insert undo break-points on punctuation so `u` undoes phrase-by-phrase.
map("i", ",", ",<c-g>u", "Undo break-point at comma")
map("i", ".", ".<c-g>u", "Undo break-point at period")
map("i", ";", ";<c-g>u", "Undo break-point at semicolon")

-- Window navigation & resizing
map("n", "<C-h>", "<C-w>h", "Focus left window")
map("n", "<C-j>", "<C-w>j", "Focus lower window")
map("n", "<C-k>", "<C-w>k", "Focus upper window")
map("n", "<C-l>", "<C-w>l", "Focus right window")
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase window height")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease window height")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease window width")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase window width")

-- Buffer navigation (Tab navigation uses Neovim 0.11+ built-in `[t` / `]t`)
map("n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")

-- Diagnostic navigation (built-in `[d`/`]d` jumps all severities; `[e`/`]e` jumps errors only)
map("n", "gl", vim.diagnostic.open_float, "Show line diagnostics")
map("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, "Next error diagnostic")
map("n", "[e", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, "Previous error diagnostic")

-- System clipboard shortcuts (keep default registers clean during normal edits)
map({ "n", "x" }, "<leader>y", '"+y', "Yank to system clipboard")
map("n", "<leader>Y", '"+Y', "Yank line to system clipboard")
map({ "n", "x" }, "<leader>p", '"+p', "Paste after from system clipboard")
map({ "n", "x" }, "<leader>P", '"+P', "Paste before from system clipboard")

-- Terminal mode escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")

-- ==============================================================================
-- 6. Package Management (Neovim 0.12+ `vim.pack`)
-- ==============================================================================

-- Use native `vim.pack.add`. Pin `blink.cmp` to v1.* so it can fetch prebuilt
-- Rust fuzzy-matcher binaries instead of falling back to the slower Lua engine.
vim.pack.add({
  -- Colorschemes & Icons (recommended by Snacks for Explorer/Picker/Dashboard icons)
  { src = gh("folke/tokyonight.nvim") },
  { src = gh("Mofiqul/adwaita.nvim") },
  { src = gh("Mofiqul/vscode.nvim") },
  { src = gh("nvim-tree/nvim-web-devicons") },

  -- Core Swiss-Army Knife (Picker, Explorer, Notifier, Terminal, Scope, Zen, etc.)
  { src = gh("folke/snacks.nvim") },

  -- Completion & Snippets (Native `vim.snippet` + friendly-snippets; no LuaSnip needed)
  { src = gh("rafamadriz/friendly-snippets") },
  { src = gh("saghen/blink.cmp"), version = "v1.*" },

  -- LSP, Formatting & Git
  { src = gh("neovim/nvim-lspconfig") },
  { src = gh("stevearc/conform.nvim") },
  { src = gh("lewis6991/gitsigns.nvim") },
}, { confirm = false, load = true })

-- ==============================================================================
-- 7. Plugin Configurations
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 7.1 Snacks.nvim (All Recommended Built-in Sub-Plugins Enabled)
-- ------------------------------------------------------------------------------
local Snacks = require("snacks")

Snacks.setup({
  bigfile = { enabled = true },      -- Prevent large files from freezing LSP/syntax
  dim = { enabled = true },          -- Dim inactive scopes on demand (`<leader>uD`)
  explorer = { enabled = true },     -- File tree explorer (replaces netrw/neo-tree)
  gitbrowse = { enabled = true },    -- Open current file/line/commit on GitHub/GitLab
  indent = { enabled = true },       -- Clean indent guides with current scope highlight
  input = { enabled = true },        -- Pretty floating `vim.ui.input` (LSP rename, etc.)
  picker = { enabled = true },       -- Fuzzy finder for files, grep, LSP, git, undo
  quickfile = { enabled = true },    -- Render file contents before plugins finish loading
  rename = { enabled = true },       -- LSP-integrated file rename (auto-updates imports)
  scope = { enabled = true },        -- Scope detection, textobjects (`ii`/`ai`) & jumps (`[i`/`]i`)
  scroll = { enabled = true },       -- Smooth scrolling animations
  statuscolumn = { enabled = true }, -- Clean gutter layout for signs, numbers & folds
  terminal = { enabled = true },     -- Floating/split toggleable terminal
  words = { enabled = true },        -- Auto-highlight LSP references under cursor
  zen = { enabled = true },          -- Distraction-free Zen mode & window zoom
  notifier = {
    enabled = true,
    top_down = false,
  },
})

-- Pipe LSP progress updates into Snacks.notifier with per-client token deduplication.
local lsp_progress = {}

local function format_lsp_progress(value)
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
      local prev = lsp_progress[id]
      local msg = value.message or (prev and prev.message) or value.title or "Done"
      Snacks.notifier.notify(msg, vim.log.levels.INFO, {
        id = id,
        title = client.name,
        timeout = 1500,
      })
      lsp_progress[id] = nil
      return
    end

    local msg = format_lsp_progress(value)
    lsp_progress[id] = { message = msg }
    Snacks.notifier.notify(msg, vim.log.levels.INFO, {
      id = id,
      title = client.name,
      timeout = false,
    })
  end,
  desc = "Show LSP progress in Snacks notifier",
})

-- ------------------------------------------------------------------------------
-- 7.2 Git Integration (Gitsigns)
-- ------------------------------------------------------------------------------
require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local opts = { buffer = bufnr }
    map("n", "]h", function() gs.nav_hunk("next") end, "Next Git hunk", opts)
    map("n", "[h", function() gs.nav_hunk("prev") end, "Previous Git hunk", opts)
    map({ "n", "x" }, "<leader>hs", ":Gitsigns stage_hunk<cr>", "Stage hunk", opts)
    map({ "n", "x" }, "<leader>hr", ":Gitsigns reset_hunk<cr>", "Reset hunk", opts)
    map("n", "<leader>hS", gs.stage_buffer, "Stage entire buffer", opts)
    map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk", opts)
    map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline", opts)
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line", opts)
  end,
})

-- ------------------------------------------------------------------------------
-- 7.3 Completion (Blink.cmp + Native `vim.snippet`)
-- ------------------------------------------------------------------------------
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
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    list = {
      selection = { preselect = false, auto_insert = true },
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
  signature = {
    enabled = true,
  },
})

-- ------------------------------------------------------------------------------
-- 7.4 Formatting (Conform.nvim)
-- ------------------------------------------------------------------------------
-- Conform decouples formatting from slow LSP servers, supports external CLI
-- formatters (stylua, ruff, prettier, gofumpt), and falls back to LSP cleanly.
vim.g.autoformat = true

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format", "ruff_organize_imports" },
    go = { "gofumpt", "goimports" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = function(bufnr)
    if not vim.g.autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 1500, lsp_format = "fallback" }
  end,
})

map({ "n", "x" }, "<leader>cf", function()
  require("conform").format({ async = true })
end, "Format buffer or selection")

-- ==============================================================================
-- 8. LSP Configuration (Neovim 0.11+ Native `vim.lsp.config`)
-- ==============================================================================

-- Share capabilities across all LSP servers via the `*` wildcard config instead
-- of duplicating `capabilities = ...` in every server definition.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("ty", {})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
    },
  },
})

vim.lsp.config("ts_ls", {})

vim.lsp.enable({ "ty", "gopls", "rust_analyzer", "ts_ls" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local opts = { buffer = args.buf }

    -- Use Snacks picker for LSP jumps: jumps immediately when there is a single
    -- target, and opens an interactive preview picker when there are multiple.
    map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Go to definition", opts)
    map("n", "gD", function() Snacks.picker.lsp_declarations() end, "Go to declaration", opts)
    map("n", "gr", function() Snacks.picker.lsp_references() end, "Find references", opts)
    map("n", "gi", function() Snacks.picker.lsp_implementations() end, "Go to implementation", opts)
    map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition", opts)
    map("n", "K", vim.lsp.buf.hover, "Hover documentation", opts)
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action", opts)
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol", opts)
    map("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename current file (LSP)", opts)
    map("n", "]r", function() Snacks.words.jump(vim.v.count1) end, "Next symbol reference", opts)
    map("n", "[r", function() Snacks.words.jump(-vim.v.count1) end, "Previous symbol reference", opts)

    if client:supports_method("textDocument/inlayHint") then
      Snacks.toggle.inlay_hints():map("<leader>uh")
    end
  end,
  desc = "Attach buffer-local LSP keymaps",
})

-- ==============================================================================
-- 9. Unified Mnemonic Keymaps (Snacks Picker, Explorer, Terminal & Toggles)
-- ==============================================================================

-- Top-Level Quick Access
map("n", "<leader><space>", function() Snacks.picker.smart() end, "Smart find files")
map("n", "<leader>,", function() Snacks.picker.buffers() end, "Switch buffer")
map("n", "<leader>/", function() Snacks.picker.grep() end, "Live grep workspace")
map("n", "<leader>:", function() Snacks.picker.command_history() end, "Command history")
map("n", "<leader>e", function() Snacks.explorer() end, "Toggle file explorer")
map("n", "<leader>.", function() Snacks.scratch() end, "Toggle scratch buffer")
map("n", "<leader>S", function() Snacks.scratch.select() end, "Select scratch buffer")
map("n", "<leader>z", function() Snacks.zen() end, "Toggle Zen mode")
map("n", "<leader>Z", function() Snacks.zen.zoom() end, "Toggle window zoom")
map({ "n", "t" }, "<C-/>", function() Snacks.terminal() end, "Toggle terminal")
map({ "n", "t" }, "<C-_>", function() Snacks.terminal() end, "Toggle terminal")

-- `<leader>f` : Find / Files
map("n", "<leader>ff", function() Snacks.picker.files() end, "Find files")
map("n", "<leader>fF", function()
  Snacks.picker.files({ hidden = true, ignored = true, exclude = { ".git" } })
end, "Find all files (hidden & ignored)")
map("n", "<leader>fr", function() Snacks.picker.recent() end, "Recent files")
map("n", "<leader>fb", function() Snacks.picker.buffers() end, "Find buffers")
map("n", "<leader>fc", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, "Find Neovim config files")

-- `<leader>b` : Buffers
map("n", "<leader>bd", function() Snacks.bufdelete() end, "Delete buffer")
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, "Delete other buffers")

-- `<leader>s` : Search
map("n", "<leader>sg", function() Snacks.picker.grep() end, "Grep workspace")
map("n", "<leader>sb", function() Snacks.picker.lines() end, "Search lines in current buffer")
map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, "Search word or selection")
map("n", "<leader>sr", function() Snacks.picker.resume() end, "Resume last picker")
map("n", "<leader>sh", function() Snacks.picker.help() end, "Search help tags")
map("n", "<leader>sk", function() Snacks.picker.keymaps() end, "Search keymaps")
map("n", "<leader>su", function() Snacks.picker.undo() end, "Undo history tree")
map("n", "<leader>sn", function() Snacks.picker.notifications() end, "Notification history")

-- `<leader>c` : Code / LSP
map("n", "<leader>cs", function() Snacks.picker.lsp_symbols() end, "Document symbols")
map("n", "<leader>cS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")

-- `<leader>x` : Diagnostics
map("n", "<leader>xx", function() Snacks.picker.diagnostics() end, "Workspace diagnostics")
map("n", "<leader>xb", function() Snacks.picker.diagnostics_buffer() end, "Buffer diagnostics")

-- `<leader>g` : Git
map("n", "<leader>gs", function() Snacks.picker.git_status() end, "Git status")
map("n", "<leader>gl", function() Snacks.picker.git_log() end, "Git log")
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, "Git current file history")
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, "Git diff (hunks)")
map({ "n", "x" }, "<leader>go", function() Snacks.gitbrowse() end, "Open in GitHub/GitLab browser")

-- `<leader>u` : UI / Feature Toggles
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ur")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>us")
Snacks.toggle({
  name = "Auto Format on Save",
  get = function() return vim.g.autoformat end,
  set = function(state) vim.g.autoformat = state end,
}):map("<leader>uf")

-- ==============================================================================
-- 10. Machine-Local Overrides
-- ==============================================================================

if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/local.lua") == 1 then
  require("local")
end
