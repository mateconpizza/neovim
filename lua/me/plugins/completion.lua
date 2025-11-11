return {
  { -- https://github.com/Saghen/blink.cmp
    'saghen/blink.cmp',
    enabled = true,
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    event = 'VeryLazy',
    lazy = false,
    version = 'v0.*',
    ---@module 'blink.cmp'
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = 'default' },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },

      signature = {
        enabled = false, -- this shows a popup window
        window = { border = 'rounded' },
      },

      completion = {
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= 'cmdline'
          end,
          border = 'rounded',
        },
        documentation = { auto_show = true, window = { border = 'rounded', scrollbar = false } },
      },
      cmdline = { enabled = false },
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'gomarks' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          gomarks = {
            name = 'Gomarks',
            module = 'me.config.gomarks', -- blink.cmp will call `require('your-source').new(...)`
            opts = {
              count = true, -- tagname (n)
            },
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
