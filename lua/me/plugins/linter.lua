-- me.plugins.linting

local autocmd = vim.api.nvim_create_autocmd
local shell_path = Core.env.xdg_home() .. '/dot/shellcheck/shellcheckrc'
if not Core.utils.file_exist(shell_path) then
  Core.warnme('linting: shellcheckrc not found\n')
end

local configs = {
  shellcheckrc = { -- https://www.shellcheck.net/wiki/
    '--format',
    'json',
    '--rcfile',
    shell_path,
    '-',
  },
  djlint = { -- https://github.com/djlint/djLint
    '--linter-output-format',
    '{line}:{code}: {message}',
    '--ignore=H006',
    '--profile=golang',
    '-',
  },
}

return {
  { -- https://github.com/mfussenegger/nvim-lint
    'mfussenegger/nvim-lint',
    enabled = true,
    event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
    config = function()
      local lint = require('lint')
      lint.linters.shellcheck.args = configs.shellcheckrc
      lint.linters.djlint.args = configs.djlint
      lint.linters_by_ft = {
        ['*'] = { 'codespell', 'misspell', 'typos' },
        ['_'] = { 'codespell', 'misspell', 'typos' },
        -- ['c'] = { 'cpplint' },
        -- gitcommit = { 'commitlint' },
        css = { 'stylelint' },
        go = { 'golangcilint', 'typos' },
        gohtml = { 'djlint' },
        gotmpl = { 'djlint' },
        htmldjango = { 'djlint' },
        typescript = { 'eslint_d' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        make = { 'checkmake' },
        -- ['markdown'] = { 'markdownlint', 'write_good', 'alex' },
        markdown = { 'write_good' }, -- , 'alex' },
        python = { 'mypy' },
        sh = { 'shellcheck' },
        typescriptreact = { 'eslint_d' },
      }

      autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = Core.augroup('lint'),
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
        desc = 'lint code via nvim-lint',
      })

      vim.keymap.set('n', '<leader>ll', function()
        lint.try_lint()
      end, { desc = 'trigger linting for current file' })
    end,
  },
}
