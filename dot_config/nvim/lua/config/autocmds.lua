-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_user_command("ManualDiagAdd", function()
  require("../utils/manual_diag").add_pick()
end, {})

vim.api.nvim_create_user_command("ManualDiagClear", function()
  require("manual_diag").clear(0)
end, {})

vim.api.nvim_create_user_command("ManualDiagOpen", function()
  require("manual_diag").open_list()
end, {})
