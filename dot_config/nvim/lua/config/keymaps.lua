-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Custom keymaps

-- Ctrl+S to save current file
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Buffer navigation with < and > (only in normal mode to preserve visual mode indentation)
vim.keymap.set("n", "<", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", ">", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Diagnostics
vim.keymap.set("n", "<leader>dc", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Manual diagnostics keymaps (LazyVim)
local ok, md = pcall(require, "../utils/manual_diag")
if not ok then
  return
end

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

-- Add diagnostics (current line; prompts for message)
map("n", "<leader>me", function()
  md.add(vim.diagnostic.severity.ERROR)
end, "Manual diag: add ERROR")
map("n", "<leader>mw", function()
  md.add(vim.diagnostic.severity.WARN)
end, "Manual diag: add WARN")
map("n", "<leader>mi", function()
  md.add(vim.diagnostic.severity.INFO)
end, "Manual diag: add INFO")
map("n", "<leader>mh", function()
  md.add(vim.diagnostic.severity.HINT)
end, "Manual diag: add HINT")
map("n", "<leader>mp", md.add_pick, "Manual diag: pick severity")

-- Navigate / inspect only our namespace
map("n", "]m", md.next, "Manual diag: next (manual ns)")
map("n", "[m", md.prev, "Manual diag: prev (manual ns)")
map("n", "<leader>mo", md.open_list, "Manual diag: open list (loclist)")
map("n", "<leader>mf", md.open_float, "Manual diag: float on line")

-- Clear
map("n", "<leader>mC", md.clear_line, "Manual diag: clear current line")
map("n", "<leader>mc", function()
  md.clear(0)
end, "Manual diag: clear buffer")
