-- ~/.config/nvim/init.lua

-- Set leader key BEFORE lazy loads
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic sane defaults
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- { import = "plugins" },  -- no plugins yet, add specs here later
  },
  change_detection = { notify = false },
})
