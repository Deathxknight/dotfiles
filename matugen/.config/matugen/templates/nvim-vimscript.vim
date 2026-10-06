" Matugen-generated nvim highlight groups
" Transparency: all guibg=None so terminal background shows through

" --- Syntax base groups ---
hi Comment     guibg=None guifg={{colors.outline.default.hex}}
hi Delimiter   guibg=None guifg={{ colors.on_surface_variant.default.hex }}
hi Operator    guibg=None guifg={{colors.on_surface_variant.default.hex}}

hi Todo        guibg=None guifg={{colors.secondary.default.hex}}

hi Identifier  guibg=None guifg={{colors.on_surface.default.hex}}
hi Constant    guibg=None guifg={{colors.primary.default.hex}}
hi Type        guibg=None guifg={{colors.tertiary.default.hex}}
hi String      guibg=None guifg={{ colors.secondary.default.hex }}
hi Special     guibg=None guifg={{ colors.tertiary_fixed_dim.default.hex }}
hi PreProc     guibg=None guifg={{ colors.primary_fixed_dim.default.hex }}
hi Function    guibg=None guifg={{colors.primary.default.hex}}
hi Statement   guibg=None guifg={{colors.tertiary.default.hex}}
hi Keyword     guibg=None guifg={{colors.primary.default.hex}}
hi Number      guibg=None guifg={{colors.tertiary.default.hex}}
hi Boolean     guibg=None guifg={{colors.tertiary.default.hex}}
hi Character   guibg=None guifg={{ colors.secondary.default.hex }}

" --- UI groups (with subtle backgrounds for contrast) ---
hi Normal      guibg=None guifg={{colors.on_surface.default.hex}}
hi NormalFloat guibg={{colors.surface_container.default.hex}} guifg={{colors.on_surface.default.hex}}
hi LineNr      guibg=None guifg={{colors.outline.default.hex}}
hi CursorLineNr guibg=None guifg={{colors.primary.default.hex}}

hi Cursor      guibg={{colors.primary.default.hex}} guifg={{colors.background.default.hex}}
hi CursorLine  guibg={{colors.surface_container.default.hex}}
hi Visual      guibg={{colors.primary_container.default.hex}} guifg={{colors.on_primary_container.default.hex}}
hi Search      guibg={{colors.tertiary_container.default.hex}} guifg={{colors.on_tertiary_container.default.hex}}
hi IncSearch   guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}

hi Pmenu       guibg={{colors.surface_container.default.hex}} guifg={{colors.on_surface.default.hex}}
hi PmenuSel    guibg={{colors.primary_container.default.hex}} guifg={{colors.on_primary_container.default.hex}}
hi PmenuSbar   guibg={{colors.surface_container_high.default.hex}}
hi PmenuThumb  guibg={{colors.primary.default.hex}}

hi StatusLine   guibg={{colors.surface_container.default.hex}} guifg={{colors.on_surface.default.hex}}
hi StatusLineNC guibg={{colors.surface_container_low.default.hex}} guifg={{colors.outline.default.hex}}
hi VertSplit    guibg=None guifg={{colors.outline_variant.default.hex}}

hi TabLine      guibg={{colors.surface_container_low.default.hex}} guifg={{colors.on_surface_variant.default.hex}}
hi TabLineSel   guibg={{colors.surface_container.default.hex}} guifg={{colors.on_surface.default.hex}}
hi TabLineFill  guibg={{colors.surface.default.hex}}

hi Error       guibg={{colors.error_container.default.hex}} guifg={{colors.on_error_container.default.hex}}
hi ErrorMsg    guibg=None guifg={{colors.error.default.hex}}
hi WarningMsg  guibg=None guifg={{colors.tertiary.default.hex}}
hi DiffAdd     guibg={{colors.primary_container.default.hex}}
hi DiffChange  guibg={{colors.secondary_container.default.hex}}
hi DiffDelete  guibg={{colors.error_container.default.hex}}
hi DiffText    guibg={{colors.primary.default.hex}} guifg={{colors.on_primary.default.hex}}

hi MatchParen  guibg={{colors.tertiary_container.default.hex}} guifg={{colors.on_tertiary_container.default.hex}}
hi Folded      guibg={{colors.surface_container_low.default.hex}} guifg={{colors.outline.default.hex}}
hi FoldColumn  guibg=None guifg={{colors.outline.default.hex}}
hi SignColumn  guibg=None guifg={{colors.outline.default.hex}}

" --- Treesitter links (Vim 8 doesn't have these natively) ---
hi link @comment Comment
hi link @string String
hi link @function Function
hi link @keyword Keyword
hi link @variable Identifier
hi link @constant Constant
hi link @type Type
hi link @operator Operator
