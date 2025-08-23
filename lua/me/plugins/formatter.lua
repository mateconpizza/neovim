-- formatters

local fmtcfg = {
  goimports = {
    args = { '-rm-unused', '-set-alias', '-format', '$FILENAME' },
  },
  texfmt = {
    args = { '-s', '--nowrap' },
  },
  golines = {
    args = { '-m', '110' },
  },
}

return {
  { -- https://github.com/stevearc/conform.nvim
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    enabled = true,
    -- stylua: ignore
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = true, timeout_ms = 500 })
        end,
        mode = { "n", "v" },
        desc = "format file or range (in visual mode)",
      },
    },
    init = function()
      local logpath = Core.env.xdg_state_home() .. '/nvim/' .. 'conform.log'
      Core.utils.gc_logfile(logpath, 500)
    end,
    config = function()
      local conform = require('conform')
      conform.formatters['goimports-reviser'] = fmtcfg.goimports
      conform.formatters['tex-fmt'] = fmtcfg.texfmt
      conform.formatters['golines'] = fmtcfg.golines
      conform.setup({
        formatters_by_ft = {
          ['_'] = { 'trim_whitespace' },
          ['css'] = { 'prettier' },
          ['go'] = { 'goimports-reviser', 'golines' },
          ['html'] = { 'prettier' },
          ['htmldjango'] = { 'djlint' },
          ['javascript'] = { 'prettier' },
          ['javascriptreact'] = { 'prettier' },
          ['json'] = { 'prettier' },
          ['jsonc'] = { 'prettier' },
          ['lua'] = { 'stylua' },
          ['markdown'] = { 'prettier' },
          ['markdown.mdx'] = { 'prettier' },
          ['python'] = { 'ruff_format', 'ruff_organize_imports' },
          ['sh'] = { 'shfmt' },
          ['sql'] = { 'sqlfmt' },
          ['tex'] = { 'tex-fmt' },
          ['typescript'] = { 'prettier' },
          ['typescriptreact'] = { 'prettier' },
          ['yaml'] = { 'prettier' },
        },

        formatters = {
          injected = { options = { ignore_errors = true } },
        },

        format_on_save = function(_)
          if not vim.g.enable_autoformat then
            return
          end

          return { timeout_ms = 500, lsp_format = 'fallback', lsp_fallback = true }
        end,
      })
    end,
  },
}
