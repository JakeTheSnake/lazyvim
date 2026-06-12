-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("n", "<leader>fs", ":Telescope lsp_document_symbols <CR>")
vim.api.nvim_create_user_command("Rancher", function()
  vim.cmd.normal({ args = { "G" }, bang = true })
  vim.cmd.normal({ args = { "p" }, bang = true })
  vim.cmd.normal({ args = { "d76j" }, bang = true })
  vim.cmd.normal({ args = { "k" }, bang = true })
  vim.cmd.normal({ args = { "dd" }, bang = true })
  vim.cmd.normal({ args = { "j" }, bang = true })
  vim.cmd.normal({ args = { "dG" }, bang = true })
end, {})
vim.api.nvim_create_user_command("FormatXML", function()
  vim.cmd([[%!xmllint --format - 2>/dev/null | sed -E 's/^([ ]+)/\1\1/']])
end, { desc = "Format XML with xmllint and re-indent to 4 spaces" })

vim.keymap.set("v", "<leader>jwt", function()
  vim.cmd([[
    '<,'>!python3 -c "
import sys, base64, json

def decode_part(p):
    p = p.strip()
    p += '=' * (-len(p) % 4)
    p = p.replace('-', '+').replace('_', '/')
    return json.loads(base64.b64decode(p))

parts = sys.stdin.read().strip().split('.')
header  = decode_part(parts[0])
payload = decode_part(parts[1])

print(json.dumps(header, indent=2))
print(json.dumps(payload, indent=2))
"
  ]])
end, { desc = "Decode JWT" })
