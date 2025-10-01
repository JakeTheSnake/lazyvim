return {
  -- Stop lspconfig from starting jdtls with defaults
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- ensure lspconfig doesn't auto-configure jdtls
        jdtls = nil,
      },
      setup = {
        -- jdtls = function()
        --   return true -- tell LazyVim: we handle jdtls ourselves
        -- end,
      },
    },
  },

  -- Ensure nvim-jdtls is available when editing Java
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" }, -- load only for Java buffers
  },
}
