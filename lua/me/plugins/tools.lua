return {

  { -- https://github.com/echasnovski/mini.bufremove
    'echasnovski/mini.bufremove',
    -- stylua: ignore
    keys = {
      { '<leader>bd', '', desc = '+buffers' },
      { "<leader>bdc", function() require("mini.bufremove").delete(0, false) end, desc = "buffer delete" },
      { "<leader>bdF", function() require("mini.bufremove").delete(0, true) end, desc = "buffer delete (force)" },
    },
    enabled = true,
  },

  { -- https://github.com/folke/todo-comments.nvim
    'folke/todo-comments.nvim',
    cmd = { 'TodoFzfLua', 'TodoQuickFix' },
    opts = {
      keywords = {
        WIP = { icon = ' ', color = 'warning' },
      },
    },
    keys = {
      -- stylua: ignore start
      { ']t', function() require('todo-comments').jump_next() end, desc = 'next todo comment' },
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'previous todo comment' },
      { '<leader>st', '<CMD>TodoFzfLua<CR>', desc = 'search TODO|FIX|FIXME|WIP' },
      { '<leader>mT', function()
        if not Core.utils.has_plugin('trouble.nvim') then
          Core.warnme('todo-comments.nvim: "trouble.nvim" not installed\n')
          return
        end
        vim.cmd('<CMD>TodoTrouble keywords=TODO,FIX,FIXME,WIP,NOTE,HACK<CR>')
      end, desc = 'TODO/FIX/FIXME (trouble)' },
    },
    -- stylua: ignore end
    enabled = true,
  },

  { -- https://github.com/toppair/peek.nvim
    -- dependencies: webkit2gtk (webview)
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    opts = {
      theme = 'light',
      app = 'webview', -- webview
    },
    -- stylua: ignore
    keys = {
      { '<leader>mp', function() require('peek').open() end, desc = 'peek open' },
      { '<leader>mP', function () require('peek').close() end, desc = 'peek close' },
    },
    enabled = Core.is_executable('deno'),
  },

  { -- https://github.com/mbbill/undotree
    'mbbill/undotree',
    keys = {
      { '<leader>gu', '<CMD>UndotreeToggle<CR>', desc = 'undotree' },
    },
  },
}
