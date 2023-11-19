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

require("typescript-tools").setup({})

local home = os.getenv("HOME")

local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = { "clangd", "gopls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    capabilities = capabilities,
  })
end

lspconfig.pyright.setup({
  capabilities = capabilities,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = false,
      virtual_text = false,
      signs = false,
    }),
  },
})

require("rust-tools").setup({
  tools = {
    inlay_hints = {
      auto = false,
    },
  },
  server = {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
      },
    },
  },
})

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
