return {
  { -- https://github.com/nvim-treesitter/nvim-treesitter
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    opts = function()
      Core.treesitter.add({ 'tsx', 'javascript', 'typescript' })
    end,
  },

  { -- https://github.com/williamboman/mason.nvim
    'williamboman/mason.nvim',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'eslint_d' })
      end
    end,
  },
}
