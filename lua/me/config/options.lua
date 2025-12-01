-- settings.lua
local opt = vim.opt

---@class me.config.options
local M = {}

--- Setup leader keys
function M.setup_leaders()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
end

--- Setup colorscheme options
function M.setup_colorscheme()
  vim.o.background = 'light'
end

--- Setup editor options
function M.setup_editor()
  -- stylua: ignore start
  opt.clipboard     = 'unnamedplus' -- clipboard
  opt.hlsearch      = false         -- Set highlight on search
  opt.mouse         = 'a'           -- Enable mouse mode
  opt.swapfile      = false         -- No swap file
  opt.backup        = false         -- No backup file
  opt.undofile      = true
  opt.undodir       = vim.fn.stdpath('state') .. '/undodir'
  opt.undolevels    = 10000
  opt.ignorecase    = true          -- Case insensitive searching UNLESS /C or capital in search
  opt.smartcase     = true          -- Case insensitive searching UNLESS /C or capital in search
  opt.signcolumn    = 'yes'         -- Signcolumn
  opt.breakindent   = true          -- Enable break indent
  opt.smartindent   = true          -- Insert indents automatically
  opt.shiftround    = true          -- Round indent
  opt.shiftwidth    = 2             -- Size of an indent
  opt.tabstop       = 2             -- Number of spaces tabs count for
  opt.expandtab     = true          -- Use spaces instead of tabs
  opt.cmdheight     = 1             -- More space for displaying messages
  opt.showtabline   = 0             -- Disable tabline
  opt.splitbelow    = true          -- Horizontal splits will automatically be below
  opt.splitright    = true          -- Vertical splits will automatically be to the right
  opt.laststatus    = 0             -- Always display the status line
  opt.showmode      = true          -- We don't need to see things like -- INSERT -- anymore
  opt.dictionary    = '/usr/share/dict/words' -- EN Dictionary - <CTRL-X><CTRL-K>
  opt.number        = false         -- set numbered lines
  opt.relativenumber= false         -- set relative numbered lines
  opt.timeoutlen    = 500           -- Time in milliseconds to wait for a mapped sequence to complete.
  opt.updatetime    = 200           -- Decrease update time
  opt.pumheight     = 18            -- Maximum number of entries in a popup
  opt.scrolloff     = 6             -- Lines of context
  opt.sidescrolloff = 6             -- Lines of context
  opt.wrap          = false         -- Disable line wrap
  opt.termguicolors = true          -- True color support
  opt.spelllang     = { 'en_us', 'es' } -- spellcheck
  opt.cursorline    = false         -- Enable highlighting of the current line
  opt.grepformat    = '%f:%l:%c:%m' -- grep
  opt.grepprg       = 'rg --vimgrep --color=never' -- grep
  opt.wildignore:append(Core.defaults.wildignore)
  opt.conceallevel  = 1             -- Hide * markup for bold and italic
  opt.wildmode      = 'longest:full,full' -- Command-line completion mode
  opt.winminwidth   = 5             -- Minimum window width
  opt.pumblend      = 10            -- Popup blend
  opt.splitkeep     = 'cursor'      -- cursor, screen, topline, scroll behavior when opening, closing or resizing horizontal splits
  opt.list          = false         -- Show some invisible characters (tabs...
  opt.listchars     = { tab = '» ', trail = '·', nbsp = '␣' }
  opt.inccommand    = "nosplit"     -- preview incremental substitute
  opt.confirm       = true          -- Confirm to save changes before exiting modified buffer
  opt.showbreak     = '↪'
  opt.smoothscroll  = true
  -- stylua: ignore end
end

--- Setup folding options
function M.setup_folding()
  opt.foldmethod = 'expr'
  opt.foldexpr = 'v:lua.Core.fold.expr(v:lnum)'
  opt.foldtext = 'v:lua.Core.fold.text()'
  opt.foldenable = false
end

--- Setup UI and display options
function M.setup_ui()
  -- see :h shortmess
  opt.shortmess:append({
    W = true, -- don't give "written" or "[w]" when writing a file
    I = false, -- don't give the intro message when starting Vim
    c = true, -- don't give |ins-completion-menu| messages
    C = true, -- don't give messages while scanning for ins-completion items, for instance "scanning tags"
  })

  opt.fillchars = Core.icons.fillchars

  opt.formatoptions = 'jcroqlnt'
  -- j – auto-remove comment leaders when joining lines (e.g., removes -- in Lua).
  -- c – auto-wrap comments using textwidth.
  -- r – insert comment leader (--, #, etc.) automatically when pressing <Enter> in a comment.
  -- o – insert comment leader when using o or O in normal mode.
  -- q – allow gq to format comments with textwidth.
  -- l – do not break lines that are longer than textwidth if they have a long word.
  -- n – recognize numbered lists and indent properly.
  -- t – auto-wrap normal text (not in comments) to textwidth.

  opt.winborder = 'rounded' -- Defines the default border style of floating windows
end

--- Setup cursor appearance
function M.setup_cursor()
  vim.opt.guicursor =
    'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
end

--- Setup providers and external tools
function M.setup_providers()
  vim.g.python3_host_prog = os.getenv('HOME') .. '/.local/debugpy/bin/python'
  vim.g.loaded_perl_provider = 0
  vim.g.enable_autoformat = false
end

--- Setup custom filetypes
function M.setup_filetypes()
  vim.filetype.add({
    extension = {
      rasi = 'rasi',
      rofi = 'rasi',
      gomarks = 'gomarks',
      scratchpad = 'scratchpad',
    },
    pattern = {
      ['%.gomarks$'] = 'gomarks',
      ['%.scratchpad$'] = 'scratchpad',
      ['%.env%.[%w_.-]+'] = 'sh',
      ['.*/dunst/.+%.defaults'] = 'cfg',
    },
    filename = {
      ['Scratchpad'] = 'scratchpad',
      ['vifmrc'] = 'vim',
    },
  })
end

--- Initialize all settings
function M.setup()
  M.setup_leaders()
  M.setup_colorscheme()
  M.setup_editor()
  M.setup_folding()
  M.setup_ui()
  M.setup_cursor()
  M.setup_providers()
  M.setup_filetypes()
end

return M
