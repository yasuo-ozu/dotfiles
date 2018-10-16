set directory=~/.vim/swap
set backupdir=~/.vim/temp
set tabstop=4
set shiftwidth=4
set number
set modeline
set foldmethod=marker
set wrapscan
set whichwrap=b,s,<,>,[,]
set mouse=ar
set autoindent
set noexpandtab
set smartindent
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
augroup swapchoice-readonly
  autocmd!
    autocmd SwapExists * let v:swapchoice = 'o'
augroup END

" ビルドエラー時Quickfixを開く
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep if len(getqflist()) != 0 | copen | else | cclose | endif

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

autocmd VimEnter,InsertLeave * call EndInsert()
autocmd VimLeave,InsertEnter * call BeginInsert()


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

function! s:InsertSpaceIndent()
	let col = col('.') - 1
	if col == 0 || getline('.')[col - 1] != ' '
		return "	"
	else
		let s = ""
		let c = (virtcol('.') - 1) % &tabstop
		while c < 4
			let s = s . " "
			let c = c + 1
		endwhile
		return s
	endif
endfunction
inoremap <expr> <C-i> <SID>InsertSpaceIndent()

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

filetype plugin on
filetype indent on

augroup vimrcHighlight
	autocmd ColorScheme * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=237
	autocmd ColorScheme * highlight Comment cterm=NONE ctermfg=100 ctermbg=NONE
	autocmd ColorScheme * highlight Tag cterm=NONE ctermfg=NONE ctermbg=52
	autocmd ColorScheme * highlight Todo cterm=NONE ctermfg=NONE ctermbg=100
	autocmd ColorScheme * highlight LineNr cterm=NONE ctermfg=242 ctermbg=NONE
	autocmd ColorScheme * highlight CursorLineNr cterm=underline ctermfg=250 ctermbg=NONE
augroup END

colorscheme darkblue
syntax on


