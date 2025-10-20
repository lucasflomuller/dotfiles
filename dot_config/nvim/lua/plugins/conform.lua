return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      biome = {
        require_cwd = true, -- ensures it only runs if biome exists in the project
      },
    },
  },
}
