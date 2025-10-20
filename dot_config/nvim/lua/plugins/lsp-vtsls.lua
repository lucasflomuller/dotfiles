-- lua/plugins/lsp-vtsls.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          -- monorepo-friendly: do NOT treat the whole repo as one project
          single_file_support = false,
          root_dir = function(fname)
            local util = require("lspconfig.util")
            -- prefer the nearest package's tsconfig.json
            return util.root_pattern("tsconfig.json")(fname)
              or util.root_pattern("package.json")(fname)
              or util.find_git_ancestor(fname)
          end,

          -- Point vtsls to the correct TypeScript SDK per workspace/package
          on_new_config = function(new_config, root_dir)
            local util = require("lspconfig.util")
            local function find_tsdk(start)
              local join = util.path.join
              -- 1) try the package root itself
              local tsdk = join(start, "node_modules", "typescript", "lib")
              if vim.fn.isdirectory(tsdk) == 1 then
                return tsdk
              end
              -- 2) try nearest ancestor that has node_modules (pnpm hoists)
              local nm_ancestor = util.find_node_modules_ancestor(start)
              if nm_ancestor then
                tsdk = join(nm_ancestor, "node_modules", "typescript", "lib")
                if vim.fn.isdirectory(tsdk) == 1 then
                  return tsdk
                end
              end
              -- 3) fallback: repo root (git) node_modules
              local git_root = util.find_git_ancestor(start)
              if git_root then
                tsdk = join(git_root, "node_modules", "typescript", "lib")
                if vim.fn.isdirectory(tsdk) == 1 then
                  return tsdk
                end
              end
              return nil
            end

            local tsdk = find_tsdk(root_dir)
            new_config.settings = new_config.settings or {}
            new_config.settings.typescript = new_config.settings.typescript or {}
            -- vtsls reads the same key as vscode: typescript.tsdk
            if tsdk then
              new_config.settings.typescript.tsdk = tsdk
            end
          end,

          settings = {
            -- vtsls-specific nice-to-haves
            vtsls = {
              enableMoveToFileRefactoring = true,
              autoUseWorkspaceTsdk = true,
              tsserver = {
                -- helps when repos are large; bump if you still hit perf ceilings
                maxTsServerMemory = 4096,
              },
            },
            typescript = {
              -- Inlay hints & prefs – tune to taste
              inlayHints = {
                parameterNames = { enabled = "literals" },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
              },
              preferences = {
                importModuleSpecifier = "non-relative",
                includeCompletionsForModuleExports = true,
              },
              format = { semicolons = "insert" },
            },
            javascript = {
              inlayHints = { variableTypes = { enabled = true } },
            },
          },
        },
      },
    },
  },
}
