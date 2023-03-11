return {
  "dense-analysis/ale",
  config = function()
    vim.g.ale_use_neovim_diagnostics_api = 1
    vim.g.ale_echo_msg_format = nil
    vim.g.ale_sign_error = "✘"
    vim.g.ale_sign_warning = "⚠"
    vim.g.ale_display_lsp = 1
    vim.g.ale_fixers = {
      java = { "google_java_format" },
      javascript = { "prettier" },
      typescriptreact = { "prettier" },
      typescript = { "prettier" },
    }
    vim.g.ale_fix_on_save = 1
    vim.g.ale_java_checkstyle_config = "/home/jake/.config/checkstyle.xml"
    vim.g.ale_linters_ignore = { java = { "eclipselsp", "javac" } }
  end,
}
