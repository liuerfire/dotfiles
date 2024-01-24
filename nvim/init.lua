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
vim.opt.list = true
vim.opt.listchars = "tab:⇢ ,eol:¬,trail:·,extends:↷,precedes:↶"
vim.opt.showbreak = "↪"
vim.opt.inccommand = "split"
vim.opt.completeopt = "menu,menuone,noselect"

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go,make,gitconfig",
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
  pattern = "*",
  command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]],
  desc = "jump to the last position",
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = [[ set fo-=c fo-=r fo-=o ]],
  desc = "do not auto commenting new lines",
})

vim.g.mapleader = " "
vim.keymap.set("", "<Space>", "<nop>")

-- Get rid of annoying ex keybind
vim.keymap.set("", "Q", "<nop>")

vim.keymap.set("n", "<leader>n", "<cmd>nohl<cr>")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<A-.>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<A-,>", "<cmd>tabprevious<cr>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("i", "<C-a>", "<Home>")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-f>", "<Right>")
vim.keymap.set("i", "<C-b>", "<Left>")

vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>P", '"+P')
vim.keymap.set("x", "<leader>p", '"+p')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("t", "<C-[>", "<C-\\><C-n>")

vim.api.nvim_create_user_command("CopyFilePath", function()
  vim.fn.system("wl-copy", vim.fn.expand("%"))
end, {})
vim.api.nvim_create_user_command("CopyFileAbsPath", function()
  vim.fn.system("wl-copy", vim.fn.expand("%:p"))
end, {})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "Mofiqul/vscode.nvim",
    config = function()
      require("vscode").setup({
        italic_comments = true,
        color_overrides = {
          vscTabCurrent = "#959695",
        },
      })
    end,
  },
  { "catppuccin/nvim", name = "catppuccin" },
  { "projekt0n/github-nvim-theme" },
  { "sainnhe/gruvbox-material" },

  { "FabijanZulj/blame.nvim" },
  { "editorconfig/editorconfig-vim" },
  { "nmac427/guess-indent.nvim" },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      require("lualine").setup({
        options = {
          globalstatus = true,
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = {
            "mode",
          },
          lualine_c = {
            { "filetype", icon_only = true, colored = false, padding = { left = 1 } },
            { "filename", path = 1 },
          },
          lualine_x = {
            {
              require("noice").api.status.message.get,
              cond = require("noice").api.status.message.has,
            },
            "searchcount",
          },
          lualine_y = { "fileformat" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = {
            { "filename", path = 2 },
          },
        },
      })
    end,
  },

  {
    "echasnovski/mini.nvim",
    version = false,
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
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        view = {
          adaptive_size = true,
        },
        update_focused_file = {
          enable = true,
        },
      })
    end,
    keys = {
      { "<leader>ee", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          layout_strategy = "vertical",
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<C-[>"] = actions.close,
            },
          },
          dynamic_preview_title = true,
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("ui-select")

      vim.cmd([[
  command! AF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git,--no-ignore previewer=false
  command! FF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git, previewer=false
]])
      vim.keymap.set("n", "<leader>af", "<cmd>AF<CR>")
      vim.keymap.set("n", "<leader>ff", "<cmd>FF<CR>")
      vim.keymap.set("n", "<leader>bb", builtin.buffers)
      vim.keymap.set("n", "<leader>rg", builtin.grep_string)
      vim.keymap.set("n", "<leader>xx", builtin.diagnostics)
      vim.keymap.set("n", "<leader>co", builtin.lsp_document_symbols)
      vim.keymap.set("n", "<leader>xb", function()
        builtin.diagnostics({ bufnr = 0 })
      end)
      vim.keymap.set("n", "gi", function()
        builtin.lsp_implementations({ show_line = false })
      end)
      vim.keymap.set("n", "gr", function()
        builtin.lsp_references({ show_line = false })
      end)

      vim.keymap.set("n", "<leader>/", require("telescope").extensions.live_grep_args.live_grep_args)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "comment",
          "cpp",
          "css",
          "go",
          "html",
          "java",
          "javascript",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "ruby",
          "rust",
          "sql",
          "typescript",
          "tsx",
          "vim",
          "vue",
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
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
  },

  { "stevearc/conform.nvim" },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
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
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
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
              kind = { "", "echo", "echomsg", "return_prompt", "search_count" },
              ["not"] = {
                find = "\n",
              },
            },
            opts = { skip = true },
          },
        },
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      })
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = "<A-\\>",
        direction = "float",
        shell = "fish",
        winbar = {
          enabled = true,
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      cmp.setup({
        preselect = cmp.PreselectMode.None,

        -- load snippet support
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },

        -- key mapping
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            select = false,
          }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
          end, { "i", "s" }),
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "path" },
          { name = "buffer" },
        }),

        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
          }),
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline", keyword_length = 4 },
        }),
      })
    end,
  },
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    typescript = { "prettier" },
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
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "clangd",
    "gopls",
    "jdtls",
    "pyright",
    "rust_analyzer",
    "lua_ls",
    "tsserver",
  },
  automatic_installation = true,
})

local home = os.getenv("HOME")

local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = { "clangd", "gopls", "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = capabilities,
  })
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
    },
  },
})

local workspace_folder = home .. "/workspace/.jdtls/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local jdtls_config = {
  init_options = {
    extendedClientCapabilities = {
      progressReportProvider = false,
    },
  },
  handlers = {
    -- mute; having progress reports is enough
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
    "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "-jar",
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
    "-data",
    workspace_folder,
  },
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
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
            name = "JavaSE-11",
            path = "/usr/lib/jvm/java-11-openjdk/",
          },
          {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-openjdk/",
          },
        },
      },
    },
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require("jdtls").start_or_attach(jdtls_config)
  end,
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gxd", "<cmd>split <bar> lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "gvd", "<cmd>vsplit <bar> lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "gtd", "<cmd>tab split | lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "gD", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/local.lua") == 1 then
  require("local")
end
