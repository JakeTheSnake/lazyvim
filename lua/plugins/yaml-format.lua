-- Override the yamlls formatter (used by LazyVim's lang.yaml extra) so it
-- keeps single quotes instead of converting them to double quotes on save.
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      yamlls = {
        settings = {
          yaml = {
            format = {
              enable = true,
              singleQuote = true,
            },
          },
        },
      },
    },
  },
}
