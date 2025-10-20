-- lua/manual_diag.lua
local M = {}

M.ns = vim.api.nvim_create_namespace("manual_diag")

-- Nice per-namespace visuals (override only for our ns)
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = true,
}, M.ns)

local function current_pos()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  return row - 1, col
end

local function append_diag(bufnr, diag)
  local existing = vim.diagnostic.get(bufnr, { namespace = M.ns })
  table.insert(existing, diag)
  vim.diagnostic.set(M.ns, bufnr, existing, {})
end

---Add a diagnostic on the current line, prompting for a message.
---@param severity integer one of vim.diagnostic.severity.*
---@param opts? {lnum?:integer, col?:integer}
function M.add(severity, opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum, col = current_pos()
  lnum = opts and opts.lnum or lnum
  col = opts and opts.col or 0

  vim.ui.input({ prompt = "Diagnostic message: " }, function(msg)
    if not msg or msg == "" then
      return
    end
    local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""
    append_diag(bufnr, {
      lnum = lnum,
      end_lnum = lnum,
      col = col,
      end_col = #line,
      severity = severity,
      source = "manual",
      message = msg,
      user_data = { manual = true },
    })
  end)
end

-- Picker: choose severity interactively
function M.add_pick()
  local items = {
    { "ERROR", vim.diagnostic.severity.ERROR },
    { "WARN", vim.diagnostic.severity.WARN },
    { "INFO", vim.diagnostic.severity.INFO },
    { "HINT", vim.diagnostic.severity.HINT },
  }
  vim.ui.select(items, {
    prompt = "Choose severity:",
    format_item = function(it)
      return it[1]
    end,
  }, function(choice)
    if not choice then
      return
    end
    M.add(choice[2])
  end)
end

-- Open only our namespace in the loclist
function M.open_list()
  vim.diagnostic.setloclist({ namespace = M.ns, open = true })
end

-- Show float (only our ns) for current line
function M.open_float()
  local opts = { bufnr = 0, namespace = M.ns, scope = "line", focus = true }
  -- New signature (0.10/0.11+): open_float(opts)
  local ok = pcall(vim.diagnostic.open_float, opts)
  if not ok then
    -- Old signature (<=0.9): open_float(bufnr?, opts?)
    ---@diagnostic disable-next-line:param-type-mismatch
    vim.diagnostic.open_float(0, opts)
  end
end

-- Jump within our namespace
function M.next()
  if type(vim.diagnostic.jump) == "function" then
    vim.diagnostic.jump({ count = 1, namespace = M.ns })
  else
    ---@diagnostic disable-next-line:deprecated
    vim.diagnostic.goto_next({ namespace = M.ns })
  end
end

function M.prev()
  if type(vim.diagnostic.jump) == "function" then
    vim.diagnostic.jump({ count = -1, namespace = M.ns })
  else
    ---@diagnostic disable-next-line:deprecated
    vim.diagnostic.goto_prev({ namespace = M.ns })
  end
end

-- Clear everything from this buffer in our ns
function M.clear(bufnr)
  bufnr = bufnr or 0
  if type(vim.diagnostic.clear) == "function" then
    vim.diagnostic.clear(M.ns, bufnr)
  else
    ---@diagnostic disable-next-line:deprecated
    vim.diagnostic.reset(M.ns, bufnr)
  end
end

-- Clear only the current line (our ns)
function M.clear_line()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = select(1, current_pos())
  local rest = {}
  for _, d in ipairs(vim.diagnostic.get(bufnr, { namespace = M.ns })) do
    if d.lnum ~= lnum then
      table.insert(rest, d)
    end
  end
  vim.diagnostic.set(M.ns, bufnr, rest, {})
end

return M
