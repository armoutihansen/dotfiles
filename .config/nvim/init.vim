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
" Plug 'bling/vim-airline' 			" Airline and tabline
Plug 'tpope/vim-commentary' 			" Easy code commenting
Plug 'kovetskiy/sxhkd-vim' 			" Syntax support for sxhkd
Plug 'ap/vim-css-color' 			" Color support
Plug 'ervandew/supertab' 			" Use tab in auto complete menu
Plug 'majutsushi/tagbar' 			" Right-side bar showing tags
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
" Plug 'itchyny/lightline.vim'
call plug#end()

" some basics
	" colorscheme dracula
	colorscheme palenight
	set background=dark
	au ColorScheme * hi Normal ctermbg=None
	set cursorline
	set go=a
	set mouse=a
	set nohlsearch
	set clipboard+=unnamedplus
	set laststatus=0
	set t_Co=256
	" set noshowmode
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

" 	let g:lightline = {
" 				\ 'colorscheme': 'wombat',
" 				\	}

" Colors and Theming
	" highlight Comment 	cterm=italic ctermfg=7
	" highlight Pmenu 	ctermbg=8
	" highlight PmenuSel 	ctermbg=6
	" highlight PmenuSbar 	ctermbg=0
	" highlight SignColumn 	ctermbg=none
	" highlight VertSplit        ctermfg=0    ctermbg=8       cterm=none
	" highlight LineNr           ctermfg=8    ctermbg=none    cterm=none
	" highlight CursorLineNr     ctermfg=7    ctermbg=8       cterm=none
	highlight EndOfBuffer ctermfg=none ctermbg=none
	highlight SignColumn 	ctermbg=none
	highlight LineNr           ctermfg=8    ctermbg=none    cterm=none
	highlight CursorLine 	ctermbg=8   cterm=none
	highlight CursorLineNr     ctermfg=15    ctermbg=8       cterm=none
	highlight VertSplit        ctermfg=0    ctermbg=8       cterm=none




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
	" autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=100
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo
	" autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo
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
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38
" " NeoMake settings
" 	let g:neomake_python_enabled_makers = ['pylint']
" 	map <leader>lo :lopen<CR>
" 	map <leader>lc :lclose<CR>
" 	map <leader>lp :lprev<CR>
" 	map <leader>ln :lnext<CR>

" 	function! MyOnBattery()
" 	  return readfile('/sys/class/power_supply/AC0/online') == ['0']
" 	  return 0
" 	endfunction

" 	if MyOnBattery()
" 	  call neomake#configure#automake('w')
" 	else
" 	  call neomake#configure#automake('nw', 1000)
" 	endif

" " Enable formaters
" 	let g:neoformat_enabled_python = ['autopep8', 'yapf', 'docformatter']

" " Enable alignment
" 	let g:neoformat_basic_format_align = 1

" " Enable tab to spaces conversion
" 	let g:neoformat_basic_format_retab = 1

" " Enable trimmming of trailing whitespace
" 	let g:neoformat_basic_format_trim = 1

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
