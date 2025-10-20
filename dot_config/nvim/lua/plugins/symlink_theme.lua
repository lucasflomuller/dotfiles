-- Conditional theme loading based on system
local theme_path = "/home/lucas/.config/omarchy/current/theme/neovim.lua"

-- Check if the symlinked theme exists (Linux with omarchy setup)
if vim.loop.fs_stat(theme_path) then
  return dofile(theme_path)
else
  -- Fallback theme for macOS or systems without omarchy
  return {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme tokyonight]])
      end,
    }
  }
end
