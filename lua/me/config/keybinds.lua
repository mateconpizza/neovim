-- me.config.keymaps

---@class me.config.keybinds
local M = {}

local nmap = vim.keymap.set
local map = Core.keymap
local toggle = Core.toggle

-- Common options
local opts = { noremap = true, silent = true }
local silent = { silent = true }

--- Setup window resize keymaps
function M.setup_window_resize()
  -- use ctrl + hjkl to resize windows:
  nmap('n', '<C-h>', ':vertical resize -2<CR>', opts)
  nmap('n', '<C-l>', ':vertical resize +2<CR>', opts)
  nmap('n', '<C-J>', ':horizontal resize -2<CR>', opts) -- conflict with luasnip
  nmap('n', '<C-K>', ':horizontal resize +2<CR>', opts) -- conflict with luasnip
end

--- Setup search and navigation keymaps
function M.setup_search_nav()
  -- keep search results centred
  nmap('n', 'n', 'nzzzv', silent)
  nmap('n', 'N', 'Nzzzv', silent)

  -- c-d 'n c-u centred
  nmap('n', '<C-d>', '<C-d>zz', silent)
  nmap('n', '<C-u>', '<C-u>zz', silent)
end

--- Setup text manipulation keymaps
function M.setup_text_manipulation()
  -- make y yank to end of the line
  nmap('n', 'Y', 'y$', silent)

  -- move lines
  nmap('v', 'K', ":move '<-2<CR>gv-gv", {})
  nmap('v', 'J', ":move '>+1<CR>gv-gv", {})
end

--- Setup buffer navigation keymaps
function M.setup_buffer_nav()
  map('<M-}>', '<CMD>bnext<CR>', 'next buffer')
  map('<M-{>', '<CMD>bprevious<CR>', 'previous buffer')
  map('<C-Left>', '<CMD>bprevious<CR>', 'previous buffer')
  map('<C-Right>', '<CMD>bnext<CR>', 'next buffer')
end

--- Setup file editing keymaps
function M.setup_file_editing()
  map('<leader>e', '', '+edit')
  map('<leader>ez', '<CMD>edit ~/.config/zsh/.zshrc<CR>', 'edit zshrc')
  map('<leader>ex', '<CMD>edit ~/.config/X11/xresources<CR>', 'edit xresources')
  map('<leader>es', '<CMD>edit ~/.config/sxhkd/sxhkdrc<CR>', 'edit sxhkdrc')
end

--- Setup quickfix keymaps
function M.setup_quickfix()
  map('<leader>q', '', '+quickfix')
  map('<leader>qc', '<CMD>cclose<CR>', 'quickfix close')
  map('<leader>qo', '<CMD>copen<CR>', 'quickfix open')
  map('<leader>qg', '<CMD>cfirst<CR>', 'quickfix first')
  map('<leader>qG', '<CMD>clast<CR>', 'quickfix last')
end

--- Setup toggle keymaps
function M.setup_toggles()
  map('<leader>bb', toggle.scrollsync, 'scrolling synchronously')
  map('<leader>bC', '<CMD>TSContext toggle<CR>', 'toggle treesitter context')
  map('<leader>bi', toggle.inlay_hints, 'toggle inlay hints')
  map('<leader>bg', toggle.gitsings, 'toggle git signs')
  map('<leader>bL', toggle.laststatus, 'set laststatus')
  map('<leader>bM', toggle.minimalist, 'toggle minimalist')
  map('<leader>bn', toggle.numbers, 'toggle numbers')
  map('<leader>bs', toggle.diagnostic_signs, 'toggle diagnostics signs')
  map('<leader>bS', toggle.signcolumn, 'toggle signcolumn')
  map('<C-w>m', toggle.maximize, 'toggle max')
  map('<leader>br', Core.set_root, 'set root')

  map('<leader>bB', function()
    vim.o.background = (vim.o.background == 'dark' and 'light' or 'dark')
  end, 'set background')
end

--- Setup miscellaneous keymaps
function M.setup_misc()
  -- map('<leader>bdA', function() vim.cmd('bufdo bd') end, 'close all')
  -- map('<leader>bda', function() vim.cmd('%bd|e#|bd#') end, 'close all but this one')
  map('<leader>mb', Core.misc.banner, 'insert banner')
  map('=ap', "ma=ap'a", 'auto-indents the paragraph under the cursor')
end

--- Setup blackhole register shortcuts
function M.setup_blackhole_register()
  nmap('v', 'd', '"_d', opts)
  nmap('v', 'D', '"_D', opts)
  nmap('v', 'c', '"_c', opts)
  nmap('v', 'C', '"_C', opts)
  nmap('v', 'x', '"_x', opts)
  nmap('v', 'X', '"_X', opts)
  nmap('n', 'd', '"_d', opts)
  nmap('n', 'D', '"_D', opts)
  nmap('n', 'c', '"_c', opts)
  nmap('n', 'C', '"_C', opts)
  nmap('n', 'x', '"_x', opts)
  nmap('n', 'X', '"_X', opts)
end

--- Setup word wrap navigation
function M.setup_word_wrap()
  nmap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  nmap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
end

--- Initialize all keymaps
function M.setup()
  M.setup_window_resize()
  M.setup_search_nav()
  M.setup_text_manipulation()
  M.setup_buffer_nav()
  M.setup_file_editing()
  M.setup_quickfix()
  M.setup_toggles()
  M.setup_misc()
  M.setup_word_wrap()
end

return M
