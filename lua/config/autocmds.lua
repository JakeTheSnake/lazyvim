-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "yaml",
--   callback = function()
--     vim.lsp.start({
--       cmd = { "openapi-language-server" },
--       filetypes = { "yaml" },
--       root_dir = vim.fn.getcwd(),
--     })
--   end,
-- })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "helm",
  callback = function()
    -- disable all mini.animate animations in this buffer
    vim.b.minianimate_disable = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
