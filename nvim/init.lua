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

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "make", "gitconfig" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
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
map("i", "<C-a>", "<Home>", "Line start")
map("i", "<C-e>", "<End>", "Line end")
map("i", "<C-f>", "<Right>", "Move right")
map("i", "<C-b>", "<Left>", "Move left")
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
    "FabijanZulj/blame.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    opts = {
      options = {
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_c = {
          { "filetype", icon_only = true, colored = false, padding = { left = 1 } },
          { "filename", path = 1 },
        },
        lualine_x = { "searchcount" },
        lualine_y = { "fileformat" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_c = {
          { "filename", path = 2 },
        },
      },
    },
  },

  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.comment").setup()
      require("mini.trailspace").setup()
      require("mini.align").setup()

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
    ---@type snacks.Config
    opts = {
      explorer = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
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
              ["<C-[>"] = { "close", mode = { "i", } },
              ["<C-u>"] = { "clear_input", mode = { "i", } },
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
      quickfile = { enabled = true },
      terminal = { enabled = true },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },

  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "gopls",
        "jdtls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "ts_ls",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
  },

  { "stevearc/conform.nvim",   config = true },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = -2,
            col = 6,
          },
        },
        popupmenu = {
          position = {
            row = -5,
            col = 5,
          },
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = { "search_count" },
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
  },

  {
    "Saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts_extend = { "sources.default" },
    opts = {
      keymap = {
        preset = "default",
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = {
        implementation = "prefer_rust",
      },
    },
  },
})

require("conform").setup({
  formatters_by_ft = {
    python = { "isort", "black" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    return {
      timeout_ms = 500,
      lsp_fallback = true,
    }
  end,
  formatters = {
    isort = {
      prepend_args = { "--sl" },
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

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
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

local home = os.getenv("HOME")
local jdtls_root = home .. "/.local/share/nvim/mason/packages/jdtls"
local jdtls_runtime = "/usr/lib/jvm/java-17-openjdk/"
local jdtls_launcher = vim.fn.glob(jdtls_root .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local jdtls_lombok = jdtls_root .. "/lombok.jar"
local jdtls_config = jdtls_root .. "/config_linux"
local warned_missing_jdtls = false

local function path_exists(path)
  return path ~= nil and path ~= "" and vim.uv.fs_stat(path) ~= nil
end

local function notify_missing_jdtls(missing)
  if warned_missing_jdtls then
    return
  end

  warned_missing_jdtls = true
  vim.notify("Skipping jdtls setup; missing: " .. table.concat(missing, ", "), vim.log.levels.WARN)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(args)
    local root_dir = vim.fs.root(args.buf, { ".git", "mvnw", "gradlew" }) or vim.fn.getcwd()
    local workspace_name = string.format("%s-%s", vim.fs.basename(root_dir), vim.fn.sha256(root_dir):sub(1, 8))
    local workspace_folder = home .. "/workspace/.jdtls/" .. workspace_name
    local missing = {} ---@type string[]

    if vim.fn.executable("java") ~= 1 then
      missing[#missing + 1] = "java executable"
    end
    if not path_exists(jdtls_lombok) then
      missing[#missing + 1] = jdtls_lombok
    end
    if not path_exists(jdtls_launcher) then
      missing[#missing + 1] = "jdtls launcher jar"
    end
    if vim.fn.isdirectory(jdtls_config) ~= 1 then
      missing[#missing + 1] = jdtls_config
    end
    if vim.fn.isdirectory(jdtls_runtime) ~= 1 then
      missing[#missing + 1] = jdtls_runtime
    end
    if #missing > 0 then
      notify_missing_jdtls(missing)
      return
    end

    vim.fn.mkdir(workspace_folder, "p")

    require("jdtls").start_or_attach({
      init_options = {
        extendedClientCapabilities = {
          progressReportProvider = false,
        },
      },
      handlers = {
        ["language/status"] = function() end,
      },
      capabilities = capabilities,
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "--add-opens",
        "java.base/sun.nio.fs=ALL-UNNAMED",
        "-javaagent:" .. jdtls_lombok,
        "-jar",
        jdtls_launcher,
        "-configuration",
        jdtls_config,
        "-data",
        workspace_folder,
      },
      root_dir = root_dir,
      settings = {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            hashCodeEquals = {
              useJava7Objects = true,
            },
            useBlocks = true,
          },
          configuration = {
            runtimes = {
              {
                name = "JavaSE-17",
                path = jdtls_runtime,
              },
            },
          },
        },
      },
    })
  end,
})

local function goto_definition_in(command)
  return function()
    vim.cmd(command)
    vim.lsp.buf.definition()
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
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

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, "Previous diagnostic")
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, "Next diagnostic")

if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/local.lua") == 1 then
  require("local")
end
