return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")

    -- don't preselect anything
    -- opts.preselect = cmp.PreselectMode.None
    -- don't insert automatically; don't select automatically
    opts.completion = { completeopt = "menu,menuone,noinsert,noselect" }

    -- ensure the keymaps behave explicitly
    opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
      ["<C-Space>"] = cmp.mapping.complete(), -- manual trigger
      ["<C-e>"] = cmp.mapping.close(), -- close menu
      ["<CR>"] = cmp.mapping.confirm({ select = false }), -- confirm only if selected
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
    })

    return opts
  end,
}
