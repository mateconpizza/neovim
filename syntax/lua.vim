" Only match literal <CMD> and <CR> inside Lua strings
syntax match luaCmdKey /<CMD>/ containedin=luaString
syntax match luaCRKey /<CR>/ containedin=luaString

hi def link luaCmdKey Keyword
hi def link luaCRKey Type
