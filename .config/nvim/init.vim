let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'  			" Modify inside brackets
Plug 'jiangmiao/auto-pairs' 			" Autopair brackets, quotations...
Plug 'scrooloose/nerdtree'                         " Nerdtree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'     " Highlighting Nerdtree
Plug 'junegunn/goyo.vim'  			" Environment for writing
Plug 'jreybert/vimagit'  			" Git workflow
Plug 'lukesmithxyz/vimling' 			" Prose
Plug 'vimwiki/vimwiki' 				" Personal wiki
Plug 'bling/vim-airline' 			" Airline and tabline
Plug 'vim-airline/vim-airline-themes' 			" Airline and tabline
Plug 'tpope/vim-commentary' 			" Easy code commenting
Plug 'ap/vim-css-color' 			" Color support
Plug 'ryanoasis/vim-devicons' 			" Icon support
Plug 'mhinz/vim-startify'                 	" Vim Start Page
Plug 'qpkorr/vim-bufkill' 			" Kill buffer while preserving splits
Plug 'urbainvaes/vim-ripple' 			" REPLs
Plug 'cjrh/vim-conda'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'chrisbra/csv.vim'
Plug 'ThePrimeagen/vim-be-good'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'drewtempelmeyer/palenight.vim'
Plug 'joshdick/onedark.vim'
Plug 'justinmk/vim-sneak'
Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vista.vim'
Plug 'unblevable/quick-scope'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'lervag/vimtex'
call plug#end()

" Basics
	syntax enable
	set hidden
	" set nowrap
	set encoding=utf-8
	set fileencoding=utf-8
	" set pumheight=10
	set cmdheight=2
	set splitbelow splitright
	set t_Co=256
	set smarttab
	set autoindent
	set smartindent
	set laststatus=0
	set cursorline
	set noshowmode
	set noshowcmd
	set go=a
	set mouse=a
	set nohlsearch
	set clipboard+=unnamedplus
	set nobackup                    	" No auto backups
	set nowritebackup
	set noswapfile                  	" No swap
	set scrolloff=20                        " let 10 lines before/after cursor during scroll
	set scl=yes 				" Always show sign columns
	set updatetime=300
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	set number relativenumber
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
	set wildmode=longest,list,full
	autocmd BufEnter * silent! lcd %:p:h
	let g:tex_flavor = 'latex'
	let g:vimtex_view_method = 'zathura'
	syntax on
	" set title

" Theming
	au ColorScheme * hi Normal ctermbg=None
	" colorscheme onedark
	colorscheme dracula
	set background=dark
	let g:onedark_hide_enfofbuffer = 1
	let g:termcolors = 256
	let g:onedark_terminal_italics = 1
	let g:airline_theme='deus'
	" let g:airline_theme="one"
	let g_airline_powerline_fonts = 1
	let g:airline_left_sep = ''
	let g:airline_right_sep = ''
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#left_sep = ''
	let g:airline#extensions#tabline#left_alt_sep = ''
	let g:airline#extensions#tabline#right_sep = ''
	let g:airline#extensions#tabline#right_alt_sep = ''
	highlight CursorLine 	ctermbg=8   cterm=none
	highlight CursorLineNr     ctermfg=15    ctermbg=8       cterm=none

" Windows
" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Make adjusing split sizes a bit more friendly
	noremap <silent> <C-Left> :vertical resize +3<CR>
	noremap <silent> <C-Right> :vertical resize -3<CR>
	noremap <silent> <C-Up> :resize +3<CR>
	noremap <silent> <C-Down> :resize -3<CR>

" Change 2 split windows from vert to horiz or horiz to vert
	map <Leader>th <C-w>t<C-w>H
	map <Leader>tk <C-w>t<C-w>K

" Python stuff
	let g:python_highlight_all = 1
	let g:python3_host_prog = '/home/jah/.config/miniconda3/envs/neovim3/bin/python'
	let $VIRTUAL_ENV = $CONDA_PREFIX



     " _             _   _  __
 " ___| |_ __ _ _ __| |_(_)/ _|_   _
" / __| __/ _` | '__| __| | |_| | | |
" \__ \ || (_| | |  | |_| |  _| |_| |
" |___/\__\__,_|_|   \__|_|_|  \__, |
     "                         |___/

	let g:startify_session_dir = '~/.config/nvim/session'
	let g:startify_lists = [
		\ { 'type': 'files', 	'header': [' 	Files'] 	},
		\ { 'type': 'dir', 	'header': [' 	Current Directory '. getcwd()] },
		\ { 'type': 'sessions',	'header': [' 	Sessions'] 	 },
		\ { 'type': 'bookmarks','header': [' 	Bookmarks'] 	 },
		\ ]

	let g:startify_bookmarks = [
	 	\ { 'i': '~/.config/nvim/init.vim' },
		\ { 'q': '~/.config/qtile/config.py' },
		\ ]

	let g:startify_session_autoload = 1
	let g:startify_session_delete_buffers = 1
	let g:startify_change_to_vcs_root = 1
	let g:startify_fortune_use_unicode = 1
	let g:startify_session_persistence = 1
	let g:startify_enable_special = 0
	let g:startify_padding_left = 5
	let g:startify_ascii = [
    	            \ "      .            .      ",
    	            \ "    .,;'           :,.    ",
    	            \ "  .,;;;,,.         ccc;.  ",
    	            \ ".;c::::,,,'        ccccc: ",
    	            \ ".::cc::,,,,,.      cccccc.",
    	            \ ".cccccc;;;;;;'     llllll.",
    	            \ ".cccccc.,;;;;;;.   llllll.",
    	            \ ".cccccc  ';;;;;;'  oooooo.",
    	            \ "'lllllc   .;;;;;;;.oooooo'",
    	            \ "'lllllc     ,::::::looooo'",
    	            \ "'llllll      .:::::lloddd'",
    	            \ ".looool       .;::coooodo.",
    	            \ "  .cool         'ccoooc.  ",
    	            \ "    .co          .:o:.    ",
    	            \ "      .           .'      ",
		    \ "Neovim - armoutihansen.xyz ",
    	            \]
	function! s:center(lines) abort
  		let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  		let centered_lines = map(copy(a:lines),
        		\ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  		return centered_lines
	endfunction
	let g:startify_custom_header = s:center(map(g:startify_ascii, '"     ".v:val'))
	let g:startify_custom_footer = s:center(startify#fortune#cowsay())

  " ____ ___   ____
 " / ___/ _ \ / ___|
" | |  | | | | |
" | |__| |_| | |___
 " \____\___/ \____|

 " Explorer
 	nmap <leader>e :CocCommand explorer<CR>
	autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

" Snippets
	imap <C-l> <Plug>(coc-snippets-expand)
	vmap <C-j> <Plug>(coc-snippets-select)
	let g:coc_snippet_next = '<c-j>'
	let g:coc_snippet_previous = '<c-k>'
	imap <C-j> <Plug>(coc-snippets-expand-jump)


 " ____                   _
" / ___| _ __   ___  __ _| | __
" \___ \| '_ \ / _ \/ _` | |/ /
 " ___) | | | |  __/ (_| |   <
" |____/|_| |_|\___|\__,_|_|\_\

	let g:sneak#label = 1
	let g:sneak#use_ic_scs = 1
	let g:sneak#s_next = 1
	map gS <Plug>Sneak_,
	map gs <Plug>Sneak_;
	let g:sneak#prompt = '🕵 '
	let g:sneak#prompt = '🔎'
	highlight Sneak guifg=black guibg=#00C7DF ctermfg=black ctermbg=cyan
	highlight SneakScope guifg=red guibg=yellow ctermfg=red ctermbg=yellow


" __        ___     _      _       _
" \ \      / / |__ (_) ___| |__   | | _____ _   _
"  \ \ /\ / /| '_ \| |/ __| '_ \  | |/ / _ \ | | |
"   \ V  V / | | | | | (__| | | | |   <  __/ |_| |
"    \_/\_/  |_| |_|_|\___|_| |_| |_|\_\___|\__, |
"                                           |___/
	" Map leader to which_key
	nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
	vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

	" Create map to add keys to
	let g:which_key_map =  {}
	" Define a separator
	let g:which_key_sep = '→'
	" set timeoutlen=100


	" Not a fan of floating windows for this
	let g:which_key_use_floating_win = 0

	" Change the colors if you want
	highlight default link WhichKey          Operator
	highlight default link WhichKeySeperator DiffAdded
	highlight default link WhichKeyGroup     Identifier
	highlight default link WhichKeyDesc      Function

	" Hide status line
	autocmd! FileType which_key
	autocmd  FileType which_key set laststatus=0 noshowmode noruler
	  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

	" Single mappings
	" let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle'  , 'comment' ]
	let g:which_key_map['e'] = [ ':CocCommand explorer'       , 'explorer' ]
	let g:which_key_map['f'] = [ ':Files'                     , 'search files' ]
	let g:which_key_map['h'] = [ '<C-W>s'                     , 'split below']
	let g:which_key_map['p'] = [ '<Plug>(ripple_open_repl)'	  , 'Ipython REPL' ]
	let g:which_key_map['r'] = [ ':Ranger'                    , 'ranger' ]
	let g:which_key_map['S'] = [ ':Startify'                  , 'start screen' ]
	let g:which_key_map['T'] = [ ':Rg'                        , 'search text' ]
	let g:which_key_map['v'] = [ '<C-W>v'                     , 'split right']
	let g:which_key_map['z'] = [ 'Goyo'                       , 'zen' ]
	let g:which_key_map['w'] = [ ':Vista!!'                    , 'Vista' ]

	" s is for search
	let g:which_key_map.s = {
	      \ 'name' : '+search' ,
	      \ '/' : [':History/'     , 'history'],
	      \ ';' : [':Commands'     , 'commands'],
	      \ 'a' : [':Ag'           , 'text Ag'],
	      \ 'b' : [':BLines'       , 'current buffer'],
	      \ 'B' : [':Buffers'      , 'open buffers'],
	      \ 'c' : [':Commits'      , 'commits'],
	      \ 'C' : [':BCommits'     , 'buffer commits'],
	      \ 'f' : [':Files'        , 'files'],
	      \ 'g' : [':GFiles'       , 'git files'],
	      \ 'G' : [':GFiles?'      , 'modified git files'],
	      \ 'h' : [':History'      , 'file history'],
	      \ 'H' : [':History:'     , 'command history'],
	      \ 'l' : [':Lines'        , 'lines'] ,
	      \ 'm' : [':Marks'        , 'marks'] ,
	      \ 'M' : [':Maps'         , 'normal maps'] ,
	      \ 'p' : [':Helptags'     , 'help tags'] ,
	      \ 'P' : [':Tags'         , 'project tags'],
	      \ 's' : [':Snippets'     , 'snippets'],
	      \ 'S' : [':Colors'       , 'color schemes'],
	      \ 't' : [':Rg'           , 'text Rg'],
	      \ 'T' : [':BTags'        , 'buffer tags'],
	      \ 'w' : [':Windows'      , 'search windows'],
	      \ 'y' : [':Filetypes'    , 'file types'],
	      \ 'z' : [':FZF'          , 'FZF'],
	      \ }

	" Register which key map
	call which_key#register('<Space>', "g:which_key_map")


" __     ___     _
" \ \   / (_)___| |_ __ _
"  \ \ / /| / __| __/ _` |
"   \ V / | \__ \ || (_| |
"    \_/  |_|___/\__\__,_|

	" let g:vista_default_executive = 'coc'
	let g:vista_fzf_preview = ['right:50%']

	let g:vista#renderer#enable_icon = 1

	let g:vista#renderer#icons = {
	\   "function": "\uf794",
	\   "variable": "\uf71b",
	\  }


  " ___        _      _
 " / _ \ _   _(_) ___| | _____  ___ ___  _ __   ___
" | | | | | | | |/ __| |/ / __|/ __/ _ \| '_ \ / _ \
" | |_| | |_| | | (__|   <\__ \ (_| (_) | |_) |  __/
 " \__\_\\__,_|_|\___|_|\_\___/\___\___/| .__/ \___|
  "                                     |_|

	let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
	highlight QuickScopePrimary ctermfg=155 cterm=underline
	highlight QuickScopeSecondary ctermfg=81 cterm=underline
	let g:qs_max_chars=150




" Goyo plugin makes text more readable when writing prose:
	" map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
	map <leader>f :Goyo<CR>

" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>



nnoremap <silent> <C-p> :FZF<CR>
" Tabs / Buffers settings
	tab sball
	set switchbuf=useopen
	nmap <F9> :bprev<CR>
	nmap <F10> :bnext<CR>


" vimling:
	nm <leader>d :call ToggleDeadKeys()<CR>
	imap <leader>d <esc>:call ToggleDeadKeys()<CR>a
	nm <leader>i :call ToggleIPA()<CR>
	imap <leader>i <esc>:call ToggleIPA()<CR>a
	nm <leader>q :call ToggleProse()<CR>


" Replace ex mode with gq
	map Q gq

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck %<CR>

" Open my bibliography file in split
	map <leader>b :vsp<space>$BIB<CR>
	map <leader>r :vsp<space>$REFER<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler <c-r>%<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	" map <leader>v :VimwikiIndex
	" let g:vimwiki_list = [{'path': '~/Documents/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	" let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	let g:vimwiki_list = [{
				\ 'path': '~/Dropbox/vimwiki',
				\ 'template_path': '~/.config/nvim',
				\ 'template_default': 'default',
				\ 'template_ext': '.html'}]
	let g:vimwiki_folding='custom'
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex
	autocmd BufRead,BufNewFile *.wiki set foldmethod=indent
	autocmd BufWritePost *.wiki :VimwikiAll2HTML
	autocmd VimLeave *.wiki !rsync -uvrP --delete-after ~/Dropbox/vimwiki_html/ root@armoutihansen.xyz:/var/www/vimwiki_html

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writting
	" autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=100
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo
	autocmd BufRead,BufNewFile /tmp/neomutt* :set cursorline!
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save.
 	autocmd BufWritePre * %s/\s\+$//e
 	autocmd BufWritePre * %s/\n\+\%$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost files,directories !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
" Update binds when sxhkdrc is updated.
	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" " Auto completion settings
" 	let g:deoplete#enable_at_startup = 1
" 	let g:jedi#completions_enabled = 0
" 	let g:jedi#use_splits_not_buffers = "left"
" 	let g:jedi#rename_command = "<leader>rr"
" 	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" " Start from beginning in auto completion menu
" 	let g:SuperTabDefaultCompletionType = "<c-n>"

" Toggle tagbar
	nmap <F8> :TagbarToggle<CR>

" Toggle relative numbering off/on
	nnoremap <F4> :set relativenumber!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Uncomment to autostart the NERDTree
" autocmd vimenter * NERDTree
" map <C-n> :NERDTreeToggle<CR>
" map <C-m> :NERDTreeCWD<CR>
" let g:NERDTreeDirArrowExpandable = '►'
" let g:NERDTreeDirArrowCollapsible = '▼'
" let NERDTreeShowLineNumbers=1
" let NERDTreeShowHidden=1
" let NERDTreeMinimalUI = 1
" let g:NERDTreeWinSize=30
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" REPL appear below
	let g:ripple_winpos="below"

let g:UltiSnipsExpandTrigger = "<M-TAB>"
let g:UltiSnipsListSnippets = "<c-tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsEditSplit="vertical"

let g:vim_be_good_floating = 0


  " ___ ___   ___
 " / __/ _ \ / __|
" | (_| (_) | (__
 " \___\___/ \___|

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
