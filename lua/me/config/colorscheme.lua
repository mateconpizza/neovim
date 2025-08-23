-- colorscheme

local autocmd = vim.api.nvim_create_autocmd

---@param name string
---@param val any
local function set_hl(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

local M = {}

M.name = 'retrobox'

function M.light_highlight()
  local c = Core.colors.gruvbox_light_medium()
  local d = Core.colors.gruvbox_dark_medium()
  -- stylua: ignore start
  local hls = {
    MiniTablineCurrent =      { bg = d.foreground, fg = c.foreground, italic = true, bold = true },
    -- diagnostic
    DiagnosticInfo =          { fg = c.blue, bold = true },
    DiagnosticHint =          { fg = c.cyan, bold = true },
    DiagnosticOk =            { fg = c.green, bold = true },
    DiagnosticError =         { fg = c.red, bold = true },
    -- diagnostic statusline
    __ME__DiagnosticError =   { bg = c.red, fg = 'NONE' },
    __ME__DiagnosticWarning = { bg = c.yellow, fg = 'NONE' },
    __ME__DiagnosticInfo =    { bg = c.blue, fg = 'NONE' },
    __ME__DiagnosticHints =   { bg = c.blue, fg = 'NONE' },
    -- neotest
    NeotestDir =              { fg = c.yellow },
    NeotestFile =             { fg = c.yellow, italic = true },
    NeotestTest =             { link = 'Normal', italic = true, default = true },
    NeotestSkipped =          { fg = c.blue },
    NeotestRunning =          { fg = c.yellow },
    NeotestPassed =           { fg = c.green },
    -- neovim
    FloatBorder =             { bg = '#e5d4b1' },
    Folded =                  { fg = d.lightgrey, bg = '#e5d5ad', italic = true },
    LineNr =                  { fg = c.lightgrey },
    Normal =                  { fg = c.foreground, bg = c.background },
    StatusLine =              { fg = d.foreground, bg = c.foreground, bold = true, reverse = true },
    String =                  { fg = c.green, italic = true },
    Visual =                  { link = 'TabLine', italic = true },
    VisualNOS =               { link = 'TabLine', italic = true },
  }
  -- stylua: ignore end
  return vim.tbl_deep_extend('force', hls, M.hls_common(c))
end

---@return table
function M.dark_highlight()
  local c = Core.colors.gruvbox_dark_medium()
  local light = Core.colors.gruvbox_light_medium()
  -- stylua: ignore start
  local hls =  {
    MiniTablineCurrent =      { bg = light.foreground, fg = c.foreground, italic = true, bold = true },
    -- neovim
    ColorColumn =             { link = 'WinSeparator' },
    FloatBorder =             { bg = light.foreground },
    Folded =                  { bg = light.foreground, fg = c.blue, italic = true },
    Normal =                  { fg = c.foreground, bg = c.background },
    SignColumn =              { bg = c.background },
    StatusLine =              { bg = light.foreground, fg = 'NONE' },
    StatusLineNC =            { bg = c.background, fg = 'NONE' },
    String =                  { italic = true, fg = c.green },
    Visual =                  { link = 'TabLine', italic = true },
    -- diagnostic statusline
    __ME__GitBranchName =     { fg = c.red, bold = true },
  }
  -- stylua: ignore end
  return vim.tbl_deep_extend('force', hls, M.hls_common(c))
end

---@param c table
function M.hls_common(c)
  -- stylua: ignore start
  return {
    __ME__DiagnosticError =   { fg = c.red, bg = 'NONE' },
    __ME__DiagnosticWarning = { fg = c.yellow, bg = 'NONE' },
    __ME__DiagnosticInfo =    { fg = c.blue, bg = 'NONE' },
    __ME__DiagnosticHints =   { fg = c.blue, bg = 'NONE' },
  }
  -- stylua: ignore end
end

function M.autocmd()
  autocmd('ColorScheme', {
    group = Core.augroup(M.name),
    pattern = M.name,
    callback = function()
      local hls
      if vim.o.background == 'dark' then
        hls = M.dark_highlight()
      else
        hls = M.light_highlight()
      end

      for k, v in pairs(hls) do
        set_hl(k, v)
      end
    end,
    desc = 'change colorscheme colors',
  })
end

function M.setup()
  if Core.env.get('NVIM_THEME', '') ~= M.name then
    return
  end

  -- M.autocmd()
  -- _G._statusline = require('me.config.statusline')
  -- require('me.config.statusline').setup()

  -- vim.cmd.colorscheme(M.name)
end

return M
