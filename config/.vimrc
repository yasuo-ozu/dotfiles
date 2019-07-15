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
nnoremap /<Esc> :nohlsearch<CR>
nnoremap /<Up>	/<Up>
nnoremap ?<Esc> :nohlsearch<CR>
inoremap <C-w> <Esc><C-w>
cnoremap <C-n> <Tab>
" 全角スペース可視化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/
let g:netrw_liststyle=3

noremap <C-]> <C-]>zt
noremap <C-w>] <C-w>]z12<CR>
nnoremap <CR> o<ESC>

" for gtags
nnoremap <C-\> :GtagsCursor<CR>

" 矢印キーを使った場合、同じ行中を含めて移動
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>

function! s:AddParenHook()
	let commands = ['c', 'd']
	let ranges = ['i', 'a']
	let paren = ['(', '[', '{', '<', '"', "'", '`']

	for a in commands
		for b in ranges
			for c in paren
				exe "nnoremap " . a . b . c . " :if stridx(getline('.')[0:col('.')],'" . c . "')==-1<CR>normal! f" . c . "<CR>endif<CR>" . a . b . c
			endfor
		endfor
	endfor
endfunction
call s:AddParenHook()

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

" inoremap ( ()<C-g>U<Left>
" inoremap [ []<C-g>U<Left>
" inoremap { {}<C-g>U<Left>
" inoremap " ""<C-g>U<Left>
" inoremap ' ''<C-g>U<Left>
" inoremap ` ``<C-g>U<Left>

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

function! BeginInsert()
	"let s:touch_status = system('/home/yasuo/.local/bin/toggle-touchpad.sh status')
	"call system('/home/yasuo/.local/bin/toggle-touchpad.sh disable --silent')
endfunction

function! EndInsert()
	call system('ibus engine xkb:jp::jpn')
	" if exists('s:touch_status') == 1
	" 	call system('/home/yasuo/.local/bin/toggle-touchpad.sh ' . s:touch_status . ' --silent')
	" endif
endfunction

autocmd vimrc VimEnter,InsertLeave * call EndInsert()
autocmd vimrc VimLeave,InsertEnter * call BeginInsert()


" <Tab>が効かなくなるため無効化
" inoremap <expr><C-i>     neocomplete#complete_common_string()

" source ~/.vim/rc/*.vim

" set spell
au BufRead,BufNewFile *.txt set syntax=hybrid

" TypeScript
let g:js_indent_typescript = 1

" vim-clang
let g:clang_c_completeopt = 'longest,menuone'
let g:clang_cpp_completeopt = 'longest,menuone'
"let g:clang_c_completeopt = 'menu,menuone'
"let g:clang_cpp_completeopt = 'menu,menuone'
let g:clang_c_options = '--std=gnu11'
let g:clang_cpp_options = '--std=c++11'
" let g:clang_format_auto = 1
" let g:clang_check_syntax_auto = 1
let g:clang_verbose_pmenu = 1
let g:clang_distringagsopt = ''
set conceallevel=2
set concealcursor=vin
let g:clang_snippets=1
let g:clang_conceal_snippets=1
let g:clang_snippets_engine='clang_complete'
let g:SuperTabDefaultCompletionType='<c-x><c-u><c-p>'

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
set conceallevel=0

" dein setting
if isdirectory(expand('~/.cache/dein'))
	let plugin_dir = expand('~/.cache/dein')
	let install_dir = expand('~/.cache/dein/repos/github.com/Shougo/dein.vim')
	let &runtimepath = &runtimepath . ',' . install_dir
	if dein#load_state(plugin_dir)
		call dein#begin(plugin_dir)
		call dein#add(install_dir)

		call dein#add('leafgarland/typescript-vim')

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

autocmd vimrc ColorScheme * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=237
autocmd vimrc ColorScheme * highlight Comment cterm=NONE ctermfg=100 ctermbg=NONE
autocmd vimrc ColorScheme * highlight Tag cterm=NONE ctermfg=NONE ctermbg=52
autocmd vimrc ColorScheme * highlight Todo cterm=NONE ctermfg=NONE ctermbg=100
autocmd vimrc ColorScheme * highlight LineNr cterm=NONE ctermfg=242 ctermbg=NONE
autocmd vimrc ColorScheme * highlight CursorLineNr cterm=underline ctermfg=250 ctermbg=NONE

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
function! s:InsertSpaceIndent()
	let sts = &softtabstop == 0 ? &tabstop : &softtabstop
	let col = col('.') - 1
	if col == 0 || getline('.')[col - 1] != ' '
		return "	"
	else
		let s = ""
		let c = (virtcol('.') - 1) % sts
		while c < sts
			let s = s . " "
			let c = c + 1
		endwhile
		return s
	endif
endfunction
function! s:CopyIndent(r)
	let ts = &tabstop
	let l = line('.')
	let r = a:r + l
	let ls = getline(l)
	let lm = strlen(ls)
	let rs = getline(r)
	let rm = strlen(rs)
	echo ls
	let c = 0
	let d = 0
	let i = 0
	let j = 0
	while i < lm
		let lc = ls[i]
		if lc == ' '
			let c = c + 1
		elseif lc == '	'
			let c = c + ts - ( c % ts )
		else
			break
		endif
		let i = i + 1
	endwhile
	while j < rm && d < c
		let rc = rs[j]
		if rc == ' '
			let d = d + 1
		elseif rc == '	' && d + ts - ( d % ts ) <= c
			let d = d + ts - ( d % ts )
		else
			break
		endif
		let j = j + 1
	endwhile
	let rs = strpart(rs, 0, j)
	while d < c
		if &expandtab == 0 && d + ts - ( d % ts ) <= c
			let rs = rs . '	'
			let d = d + ts - ( d % ts )
		else
			let rs = rs . ' '
			let d = d + 1
		endif
	endwhile
	let rs = rs . strpart(ls, i)
	call setline('.', rs)
endfunction

inoremap <expr> <C-i> <SID>InsertSpaceIndent()
inoremap <CR> <CR>a<BS><ESC>:call <SID>CopyIndent(-1)<CR>A
nnoremap o oa<BS><Esc>:call <SID>CopyIndent(-1)<CR>A
nnoremap O Oa<BS><Esc>:call <SID>CopyIndent(1)<CR>A

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
		execute "make! " . base . ".pdf"
	else
		execute "make! " . base
	endif
endfunction

set exrc
nnoremap <C-g>m :call <SID>RunMake()<CR>
