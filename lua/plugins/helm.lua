return {
  {
    "qvalentin/helm-ls.nvim",
    ft = "helm",
    opts = {
      helmLint = {
        enabled = true,
        ignoredMessages = {},
      },
      yamlls = {
        enabled = true,
        enabledForFilesGlob = "*.{yaml,yml}",
        diagnosticsLimit = 50,
        showDiagnosticsDirectly = false,
        path = "yaml-language-server", -- or something like { "node", "yaml-language-server.js" }
        initTimeoutSeconds = 3,
        config = {
          schemas = {
            kubernetes = "templates/**",
          },
          completion = true,
          hover = true,
          -- any other config from https://github.com/redhat-developer/yaml-language-server#language-server-settings
        },
      },
      conceal_templates = {
        -- enable the replacement of templates with virtual text of their current values
        enabled = false,
      },
      indent_hints = {
        -- enable hints for indent and nindent functions
        enabled = true,
        -- show the hints only for the line the cursor is on
        only_for_current_line = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        helm_ls = {},
      },

      setup = {
        yamlls = function()
          LazyVim.lsp.on_attach(function(client, buffer)
            if vim.bo[buffer].filetype == "helm" then
              vim.schedule(function()
                vim.cmd("LspStop ++force yamlls")
              end)
            end
          end, "yamlls")
        end,
      },
    },
  },
}
