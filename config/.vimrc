augroup vimrc
  autocmd!
augroup END

set directory=~/.vim/swap
set backupdir=~/.vim/temp
set number
set modeline
set foldmethod=marker
set wrapscan
set whichwrap=b,s,<,>,[,]
set mouse=ar
set hlsearch
set incsearch
set wildmenu
set display=lastline
set pumheight=10
set browsedir=buffer
" 対応するカッコを表示
set showmatch
set matchtime=1
" 行を強調表示
set cursorline
set completeopt=menuone,preview
set splitbelow
set splitright
let g:netrw_altv = 1
let g:netrw_alto = 1
set scrolloff=2
set showcmd
"noremap <nowait> /<Esc> :nohlsearch<CR>
""nnoremap /<Up>	/<Up>
"nnoremap <nowait> ?<Esc> :nohlsearch<CR>
inoremap <C-w> <Esc><C-w>
cnoremap <C-n> <Tab>
" 全角スペース可視化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/
let g:netrw_liststyle=3

noremap <C-]> <C-]>zt
noremap <C-w>] <C-w>]z12<CR>
"nnoremap <CR> o<ESC>
"nnoremap <C-m> o<ESC>

" for gtags
nnoremap <C-\> :GtagsCursor<CR>

" 矢印キーを使った場合、同じ行中を含めて移動
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>

vnoremap < <gv
vnoremap > >gv
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv
nnoremap <C-w><S-Up> <C-w>K
nnoremap <C-w><S-Down> <C-w>J
nnoremap <C-w><S-Left> <C-w>H
nnoremap <C-w><S-Right> <C-w>L
" nnoremap <C-w>> <C-w>><C-w>
" nnoremap <C-w>< <C-w><<C-w>
"nnoremap <S-q> :cclose<CR>:mks!<CR>:wa<CR>:qa<CR>


"inoremap ( ()<C-g>U<Left>
"inoremap [ []<C-g>U<Left>
"inoremap { {}<C-g>U<Left>
"inoremap " ""<C-g>U<Left>
"inoremap ' ''<C-g>U<Left>
"inoremap ` ``<C-g>U<Left>

"" で行番号を相対表示
"function! ToggleRelative()
"	if &relativenumber == 1
"		set norelativenumber
"	else
"		set relativenumber
"	endif
"endfunction
"nnoremap <C-j> :call ToggleRelative()<CR>
""nnoremap <Tab> :call ToggleRelative()<CR>
"augroup relativenumber
"	autocmd!
"	autocmd TextChanged * set norelativenumber
"augroup END

" スワップ発見時roで開く
autocmd vimrc SwapExists * let v:swapchoice = 'o'

" ビルドエラー時Quickfixを開く
autocmd vimrc QuickfixCmdPost make,grep,grepadd,vimgrep if len(getqflist()) != 0 | copen | else | cclose | endif

"set shellpipe="1>\dev\null 2>&1 | sed -e '/^||/d'"
set shellpipe=2>

" Quickfix エンターでファイルに飛ぶ
"function! OpenModifiableQF()
"        cw
"        set modifiable
"        set nowrap
"endfunction
"autocmd QuickfixCmdPost vimgrep call OpenModifiableQF()

" function! BeginInsert()
" 	"let s:touch_status = system('/home/yasuo/.local/bin/toggle-touchpad.sh status')
" 	"call system('/home/yasuo/.local/bin/toggle-touchpad.sh disable --silent')
" endfunction
" 
" function! EndInsert()
" 	call system('ibus engine xkb:jp::jpn')
" 	" if exists('s:touch_status') == 1
" 	" 	call system('/home/yasuo/.local/bin/toggle-touchpad.sh ' . s:touch_status . ' --silent')
" 	" endif
" endfunction
" 
" autocmd vimrc VimEnter,InsertLeave * call EndInsert()
" autocmd vimrc VimLeave,InsertEnter * call BeginInsert()

" set spell
au BufRead,BufNewFile *.txt set syntax=hybrid

" vim 8.0
set breakindent
set showbreak=>
set briopt=shift:-1
set nofixendofline
set nrformats=bin,hex
set emoji
" set termguicolors

let g:vimfiler_as_default_explorer = 1
"let g:vimfiler_enable_auto_cd = 1
":set autochdir

nnoremap い i
nnoremap あ a
nnoremap お o

" tex
let g:tex_fold_enabled=1
"set foldmethod=syntax
let g:tex_no_error=1

" dein setting
let plugin_dir = expand('~/.cache/dein')
let install_dir = expand('~/.cache/dein/repos/github.com/Shougo/dein.vim')
if &runtimepath !~# '/dein.vim'
  if !isdirectory(install_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' install_dir
  endif
endif
"let g:dein#auto_recache = 1
if isdirectory(expand('~/.cache/dein'))
	let s:toml_file = expand('~/.vim/dein.toml')
	let &runtimepath = &runtimepath . ',' . install_dir
	if dein#load_state(plugin_dir)
		call dein#begin(plugin_dir)
		call dein#add(install_dir)

		if !has('nvim')
		  call dein#add('roxma/nvim-yarp')
		  call dein#add('roxma/vim-hug-neovim-rpc')
		endif
		call dein#load_toml(s:toml_file)
		call dein#local('~/Documents/vim-wisetab')
		call dein#end()
		call dein#save_state()
	endif
	if dein#check_install()
		call dein#install()
	endif
endif

filetype off
filetype plugin on
filetype indent on

autocmd vimrc ColorScheme * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=NONE
autocmd vimrc ColorScheme * highlight Comment cterm=NONE ctermfg=100 ctermbg=NONE
autocmd vimrc ColorScheme * highlight Tag cterm=NONE ctermfg=NONE ctermbg=52
autocmd vimrc ColorScheme * highlight Todo cterm=NONE ctermfg=NONE ctermbg=100
autocmd vimrc ColorScheme * highlight LineNr cterm=NONE ctermfg=242 ctermbg=NONE
autocmd vimrc ColorScheme * highlight CursorLineNr cterm=underline ctermfg=250 ctermbg=NONE
autocmd vimrc ColorScheme * highlight IncSearch ctermfg=4 ctermbg=0
autocmd vimrc ColorScheme * hi Pmenu ctermbg=235 guibg=gray ctermfg=250 guifg=#cccccc

colorscheme darkblue
syntax on

set noexpandtab
set autoindent
set smartindent
set tabstop=4
set shiftwidth=0
set list
set listchars=tab:»\ ,trail:-

highlight SpecialKey ctermfg=242

for file in split(glob("$HOME/.vim/template/*"), "\n")
	execute "autocmd vimrc BufNewFile *." . fnamemodify(file, ":e") ."  0r " . file
endfor

inoremap <C-H> <C-W>
inoremap <C-L> <C-[>u
ab \b \begin
ab \e \end

set wildmode=list:longest
set ttyfast
set mouse=a
set mousemodel=popup_setpos
"nnoremenu 1.40 PopUp.&Paste	"+gP
"

let g:netrw_liststyle=1
let g:netrw_banner=0
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_preview=1

noremap <C-w>+ <C-w>3+
noremap <C-w>- <C-w>3-
noremap <C-w>< <C-w>3<
noremap <C-w>> <C-w>3>

function! s:RunMake()
	let base = expand("%:r")
	let ext = expand("%:e")
	if ext ==? "tex"
		execute "make! OPEN=" . base . ".pdf"
	else
		execute "make! " . base
	endif
endfunction

set exrc
nnoremap <C-g>m :call <SID>RunMake()<CR>

let g:deoplete#enable_at_startup = 1
if has('nvim')
	set inccommand=split
endif

set smarttab
set tabstop=4
set softtabstop=4
set noexpandtab

nnoremap gh <C-w>h
nnoremap gj <C-w>j
nnoremap gk <C-w>k
nnoremap gl <C-w>l
nnoremap gw <C-w>w
nnoremap gp <C-w><C-p>
tnoremap <C-n> <C-w><S-n>
"tnoremap <C-w> <C-w><S-n><C-w>

autocmd ColorScheme * highlight NormalNC ctermfg=243 | highlight StatusLine ctermfg=0
autocmd WinEnter,BufWinEnter * set wincolor= | set cul
autocmd WinLeave * set wincolor=NormalNC | set nocul

highlight StatusLine ctermfg=0

function! s:MoveToTerm()
    if empty(term_list())
    	let oldwinnr=0
    	while oldwinnr != winnr()
			let oldwinnr = winnr()
			execute "wincmd j"
		endwhile
    	execute "wincmd j"
        execute "terminal"
    else
        let bufnr = term_list()[0]
        "execute bufwinnr(bufnr) . "wincmd w"
        call win_gotoid(win_findbuf(bufnr)[0])
        if mode() == 'n'
        	execute "normal i"
        endif
    endif
endfunction
nnoremap <silent> gc :call <SID>MoveToTerm()<CR>
let g:lsp_log_verbose = 5
let g:lsp_log_file = expand('~/vim-lsp.log')


nnoremap <silent> <C-x>a :LspCodeAction<CR>
nnoremap <silent> <C-x>d :LspPeekDefinition<CR>
nnoremap <silent> <C-x>h :LspHover<CR>
nnoremap <silent> <C-x>n :LspNextReference<CR>
nnoremap <silent> <C-x>p :LspPreviousReference<CR>
nnoremap <silent> <C-x>] :LspDefinition<CR>
nnoremap <silent> <C-x>[ :LspDeclaration<CR>
nnoremap <silent> <C-x>r :LspReferences<CR>
nnoremap <silent> <C-x>} :LspTypeDefinition<CR>

"hi clear LspWarningHighlight
"hi clear LspWarningLine
"hi clear LspWarningText
"hi clear LspErrorHighlight
"hi clear LspErrorLine
"hi clear LspErrorText
"hi clear LspInformationHighlight
"hi clear LspInformationLine
"hi clear LspInformationText
"hi clear LspHintHighlight
"hi clear LspHintLine
"hi clear LspHintText

set mouse=n
set ttymouse=xterm2
let g:lsp_async_completion = 1

"set grepprg=grep\ -InH
set undofile
set undodir=~/.vim/undo

au TerminalWinOpen set nonumber

nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
nmap <buffer> K <plug>(lsp-hover)
set conceallevel=0


nnoremap <silent> g] :cnext<CR>
nnoremap <silent> g[ :cprev<CR>
nnoremap <silent> cc :cclose<CR>:nohlsearch<CR>:pclose<CR>
nnoremap <silent> <C-x>p :LspPeekDefinition<CR>
nnoremap <silent> <C-x>m :make! OPEN=%<CR>

set switchbuf="split"
augroup QfAutoCommands
	autocmd!

	" Auto-close quickfix window
	autocmd WinEnter * if (winnr('$') == 1) && (getbufvar(winbufnr(0), '&buftype')) == 'quickfix' | quit | endif
augroup END
