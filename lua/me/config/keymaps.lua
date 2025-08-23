-- me.config.keymaps
local nmap = vim.keymap.set
local map = Core.keymap
local toggle = Core.toggle
local options = { noremap = true, silent = true }
local silent = { silent = true }

-- shortcut to use blackhole register by default
-- nmap('v', 'd', '"_d', options)
-- nmap('v', 'D', '"_D', options)
-- nmap('v', 'c', '"_c', options)
-- nmap('v', 'C', '"_C', options)
-- nmap('v', 'x', '"_x', options)
-- nmap('v', 'X', '"_X', options)
-- nmap('n', 'd', '"_d', options)
-- nmap('n', 'D', '"_D', options)
-- nmap('n', 'c', '"_c', options)
-- nmap('n', 'C', '"_C', options)
-- nmap('n', 'x', '"_x', options)
-- nmap('n', 'X', '"_X', options)

-- remap for dealing with word wrap
-- nmap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- nmap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- use ctlr + hjkl to resize windows:
nmap('n', '<C-h>', ':vertical resize -2<CR>', options)
nmap('n', '<C-l>', ':vertical resize +2<CR>', options)
nmap('n', '<C-J>', ':horizontal resize -2<CR>', options) -- conflict with luasnip
nmap('n', '<C-K>', ':horizontal resize +2<CR>', options) -- conflict with luasnip

-- keep search results centred
nmap('n', 'n', 'nzzzv', silent)
nmap('n', 'N', 'Nzzzv', silent)

-- make y yank to end of the line
nmap('n', 'Y', 'y$', silent)

-- move lines
nmap('v', 'K', ":move '<-2<CR>gv-gv", {})
nmap('v', 'J', ":move '>+1<CR>gv-gv", {})

-- c-d 'n c-u centred
nmap('n', '<C-d>', '<C-d>zz', silent)
nmap('n', '<C-u>', '<C-u>zz', silent)

-- buffers
map('<M-}>', '<CMD>bnext<CR>', 'next buffer')
map('<M-{>', '<CMD>bprevious<CR>', 'previous buffer')
map('<C-Left>', '<CMD>bprevious<CR>', 'previous buffer')
map('<C-Right>', '<CMD>bnext<CR>', 'next buffer')

-- files
map('<leader>e', '', '+edit')
map('<leader>ez', '<CMD>edit ~/.config/zsh/.zshrc<CR>', 'edit zshrc')
map('<leader>ex', '<CMD>edit ~/.config/X11/xresources<CR>', 'edit xresources')
map('<leader>es', '<CMD>edit ~/.config/sxhkd/sxhkdrc<CR>', 'edit sxhkdrc')

-- quickfix
map('<leader>q', '', '+quickfix')
map('<leader>qc', '<CMD>cclose<CR>', 'quickfix close')
map('<leader>qo', '<CMD>copen<CR>', 'quickfix open')
map('<leader>qg', '<CMD>cfirst<CR>', 'quickfix first')
map('<leader>qG', '<CMD>clast<CR>', 'quickfix last')

-- toggle
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
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end, 'set background')

-- misc
-- stylua: ignore start
-- map('<leader>bdA', function() vim.cmd('bufdo bd') end, 'close all')
-- map('<leader>bda', function() vim.cmd('%bd|e#|bd#') end, 'close all but this one')
map('<leader>mb', function() Core.misc.banner() end, 'insert banner' )
-- stylua: ignore end
