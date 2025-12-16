return {
  { -- faster LuaLS setup for Neovim
    'https://github.com/folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    cmd = 'LazyDev',
    enabled = true,
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'Core', words = { 'Core' } },
        { path = 'LazyVim', words = { 'LazyVim' } },
        integrations = { coq = true },
      },
    },
  },
}
