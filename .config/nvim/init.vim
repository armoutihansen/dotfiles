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
Plug 'PotatoesMaster/i3-vim-syntax' 		" Syntax support for i3 config
Plug 'jreybert/vimagit'  			" Git workflow
Plug 'lukesmithxyz/vimling' 			" Prose
Plug 'vimwiki/vimwiki' 				" Personal wiki
Plug 'bling/vim-airline' 			" Airline and tabline
Plug 'tpope/vim-commentary' 			" Easy code commenting
Plug 'kovetskiy/sxhkd-vim' 			" Syntax support for sxhkd
Plug 'ap/vim-css-color' 			" Color support
Plug 'ervandew/supertab' 			" Use tab in auto complete menu
Plug 'majutsushi/tagbar' 			" Right-side bar showing tags
Plug 'ryanoasis/vim-devicons' 			" Icon support
Plug 'mhinz/vim-startify'                 	" Vim Start Page
Plug 'qpkorr/vim-bufkill' 			" Kill buffer while preserving splits
Plug 'urbainvaes/vim-ripple' 			" REPLs
Plug 'davidhalter/jedi-vim' 			" Goto (e.g ., assignments, definitions...)
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "Autocompletion
Plug 'deoplete-plugins/deoplete-jedi' 		" Deoplete soouce for jedi
Plug 'vim-python/python-syntax' 		" Python syntax support
Plug 'vim-scripts/indentpython.vim' 		" Proper python indention
Plug 'neomake/neomake' 				" Linting
Plug 'sbdchd/neoformat' 			" Auto formating off code
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'chrisbra/csv.vim'
Plug 'ThePrimeagen/vim-be-good'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" some basics
	colorscheme dracula
	au ColorScheme * hi Normal ctermbg=None
	set cursorline
	set go=a
	set mouse=a
	set nohlsearch
	set clipboard+=unnamedplus
	set laststatus=2
	set noshowmode
	set noshowcmd
	set nobackup                    	" No auto backups
	set noswapfile                  	" No swap
	syntax enable
	set scrolloff=20                        " let 10 lines before/after cursor during scroll
	set scl=yes 				" Always show sign columns
	set updatetime=50
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	let g:python_highlight_all = 1
	syntax on
	set encoding=utf-8
	set number relativenumber
	let g:python3_host_prog = '/home/jah/.config/miniconda3/envs/neovim3/bin/python'
	let $VIRTUAL_ENV = $CONDA_PREFIX
	" let g:python3_host_prog = 'python'
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>

" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" AirLine settings
	" let g:airline#extensions#tabline#enabled=1
	" let g:airline#extensions#tabline#formatter='unique_tail'
	let g:airline_powerline_fonts=1

" Colors and Theming
	" highlight Comment 	cterm=italic
	" highlight Pmenu 	ctermbg=8
	" highlight PmenuSel 	ctermbg=6
	" highlight PmenuSbar 	ctermbg=0
	" highlight SignColumn 	ctermbg=none
	" highlight VertSplit        ctermfg=0    ctermbg=8       cterm=none
	" highlight LineNr           ctermfg=8    ctermbg=none    cterm=none
	" highlight CursorLineNr     ctermfg=7    ctermbg=8       cterm=none

	highlight SignColumn 	ctermbg=none
	highlight LineNr           ctermfg=8    ctermbg=none    cterm=none
	highlight CursorLine 	ctermbg=8
	highlight CursorLineNr     ctermfg=7    ctermbg=8       cterm=none
	highlight VertSplit        ctermfg=0    ctermbg=8       cterm=none
	" highlight Statement        ctermfg=2    ctermbg=none    cterm=none
	" highlight Directory        ctermfg=4    ctermbg=none    cterm=none
	" highlight StatusLine       ctermfg=7    ctermbg=8       cterm=none
	" highlight StatusLineNC     ctermfg=7    ctermbg=8       cterm=none
	" highlight NERDTreeClosable ctermfg=2
	" highlight NERDTreeOpenable ctermfg=8
	" highlight Comment          ctermfg=4    ctermbg=none    cterm=italic
	" highlight Constant         ctermfg=12   ctermbg=none    cterm=none
	" highlight Special          ctermfg=4    ctermbg=none    cterm=none
	" highlight Identifier       ctermfg=6    ctermbg=none    cterm=none
	" highlight PreProc          ctermfg=5    ctermbg=none    cterm=none
	" highlight String           ctermfg=12   ctermbg=none    cterm=none
	" highlight Number           ctermfg=1    ctermbg=none    cterm=none
	" highlight Function         ctermfg=1    ctermbg=none    cterm=none




nnoremap <silent> <C-p> :FZF<CR>
" Tabs / Buffers settings
	tab sball
	set switchbuf=useopen
	nmap <F9> :bprev<CR>
	nmap <F10> :bnext<CR>

" Navigating tabs
	nnoremap <A-Left> :tabprevious<CR>
	nnoremap <A-Right> :tabnext<CR>

" vimling:
	nm <leader>d :call ToggleDeadKeys()<CR>
	imap <leader>d <esc>:call ToggleDeadKeys()<CR>a
	nm <leader>i :call ToggleIPA()<CR>
	imap <leader>i <esc>:call ToggleIPA()<CR>a
	nm <leader>q :call ToggleProse()<CR>

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
	map <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/Documents/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writting
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=100
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

" Auto completion settings
	let g:deoplete#enable_at_startup = 1
	let g:jedi#completions_enabled = 0
	let g:jedi#use_splits_not_buffers = "left"
	let g:jedi#rename_command = "<leader>rr"
	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Start from beginning in auto completion menu
	let g:SuperTabDefaultCompletionType = "<c-n>"

" Toggle tagbar
	nmap <F8> :TagbarToggle<CR>

" Toggle relative numbering off/on
	nnoremap <F4> :set relativenumber!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Uncomment to autostart the NERDTree
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38
" NeoMake settings
	let g:neomake_python_enabled_makers = ['pylint']
	map <leader>lo :lopen<CR>
	map <leader>lc :lclose<CR>
	map <leader>lp :lprev<CR>
	map <leader>ln :lnext<CR>

	function! MyOnBattery()
	  return readfile('/sys/class/power_supply/AC0/online') == ['0']
	  return 0
	endfunction

	if MyOnBattery()
	  call neomake#configure#automake('w')
	else
	  call neomake#configure#automake('nw', 1000)
	endif

" Enable formaters
	let g:neoformat_enabled_python = ['autopep8', 'yapf', 'docformatter']

" Enable alignment
	let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
	let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
	let g:neoformat_basic_format_trim = 1

" REPL appear below
	let g:ripple_winpos="below"

let g:UltiSnipsExpandTrigger = "<M-TAB>"
let g:UltiSnipsListSnippets = "<c-tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsEditSplit="vertical"

let g:vim_be_good_floating = 0
