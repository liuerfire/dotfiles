require('nvim-lsp-installer').setup {
  automatic_installation = true
}

local home = os.getenv('HOME')

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local on_attach = function(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
        vim.lsp.buf.formatting_sync()
      end,
    })
  end
end

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
  },
  -- on_attach = on_attach
})

local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local servers = { 'clangd', 'gopls', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
    },
  },
}

local workspace_folder = home .. '/workspace/.jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local jdtls_config = {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '--add-opens', 'java.base/sun.nio.fs=ALL-UNNAMED',
    '-javaagent:/home/liuerfire/.local/share/nvim/lsp_servers/jdtls/lombok.jar',
    '-jar', vim.fn.glob(home .. '/.local/share/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', home .. '/.local/share/nvim/lsp_servers/jdtls/config_linux',
    '-data', workspace_folder,
  },
  root_dir = require('jdtls.setup').find_root({ '.git', 'pom.xml', 'gradlew' }),
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-11',
            path = '/usr/lib/jvm/java-11-openjdk/',
          },
          {
            name = 'JavaSE-17',
            path = '/usr/lib/jvm/java-17-openjdk/',
          },
        },
      },
    }
  }
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    require('jdtls').start_or_attach(jdtls_config)
  end,
})
