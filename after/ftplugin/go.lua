vim.o.makeprg = 'go build'
vim.opt.textwidth = 79
vim.opt.formatprg = ''

local hl = vim.api.nvim_set_hl

hl(0, '@constant.go', { link = 'Purple', default = true })
hl(0, '@lsp.typemod.variable.readonly.go', { link = 'Purple' })
-- hl(0, '@keyword.conditional.go', { link = 'RedItalic' })
-- hl(0, '@lsp.type.namespace.go', { link = 'Purple' })
-- hl(0, "@lsp.typemod.variable.bool.go", { link = "Purple" })
-- hl(0, "@lsp.typemod.variable.pointer.go", { link = "Orange" })
-- hl(0, "@lsp.mod.readonly.go", { link = "Purple" })

-- - @lsp.type.variable.go links to Fg   priority: 125
-- - @lsp.mod.defaultLibrary.go links to @lsp   priority: 126
-- - @lsp.mod.readonly.go links to @lsp   priority: 126
-- - @lsp.typemod.variable.defaultLibrary.go links to @lsp   priority: 127
-- - @lsp.typemod.variable.readonly.go links to @lsp   priority: 127
