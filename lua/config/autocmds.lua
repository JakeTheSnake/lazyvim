-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "UIEnter" }, {
  callback = function(event)
    local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
    if client ~= nil and client.name == "Firenvim" then
      vim.o.colorcolumn = "50,80,100"
      vim.o.cursorline = true
      vim.o.spell = true
      vim.o.guifont = "Iosevka Fixed:h24"
      vim.o.laststatus = 1

      vim.o.background = "light"
      vim.cmd.colorscheme("quiet")

      vim.g.firenvim_config = {
        localSettings = {
          [".*"] = {
            cmdline = "neovim",
            content = "text",
            priority = 0,
            selector = "textarea:not([readonly]), div[role='textbox']",
            takeover = "once",
          },
          ["https?://.*github.com.*$"] = {
            content = "markdown",
            priority = 1,
            takeover = "once",
          },
          ["https?://.*atlassian.*$"] = {
            content = "markdown",
            priority = 1,
            takeover = "once",
          },
        },
      }
      vim.keymap.set("n", "<Esc><Esc>", "<Cmd>call firenvim#focus_page()<CR>")
      vim.keymap.set("i", "<S-CR>", '<Esc>:w<CR>:call firenvim#press_keys("<lt>CR>")<CR>ggdGa')

      vim.o.guicursor = "n-v-c-i-sm-i-ci-ve-r-cr-o:block"
      vim.cmd.startinsert()
    end
  end,
})

-- throttle syncing with page to every 3 seconds
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  callback = function(_)
    if vim.g.timer_started == true then
      return
    end
    vim.g.timer_started = true
    vim.fn.timer_start(3000, function()
      vim.g.timer_started = false
      vim.cmd([[silent! write]])
    end)
  end,
})
