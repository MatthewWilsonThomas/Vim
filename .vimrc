"--------------------------------------------------------------------
" Basic Configurations
"--------------------------------------------------------------------
filetype plugin indent on
syntax enable
set autoindent
set clipboard=unnamedplus
set foldmethod=indent
set expandtab
set list
set listchars=tab:\ \ ,trail:.,precedes:←,extends:→,nbsp:·
set nofoldenable
set nowrap
set number
set relativenumber
set shiftwidth=4
set tabstop=4
set textwidth=80
set viminfo='100,h,n~/.vim/viminfo
set hlsearch

"--------------------------------------------------------------------
" Custom Mappings
"--------------------------------------------------------------------
" This function makes the Home button take you to the indent at the beginning of
" a line as opposed to the actual beginning, and if you are already at the
" indent, then it takes you to the beginning of the line.
function ExtendedHome()
    let column = col('.')
    normal! ^
    if column == col('.')
        normal! 0
    endif
endfunction
" This function is now mapped to home, both in normal mode and in insert mode.
noremap <Home> :call ExtendedHome() <CR>
"inoremap <silent> <Home> <Esc> :call ExtendedHome() <CR>   <--- This doesn't work!!

map <F5> :setlocal spell! spelllang=en_us<CR>

" Make <F9> enter a mode where only the current paragraph is highlighted, and
" lines are auto-wrapped (good for editing multi-line comments)
map <F9> :Limelight!! <bar> :TogglePencil <CR>

" Make o and O not enter insert mode
nnoremap o o<Esc>
nnoremap O O<Esc>

" Command to auto-fit paragraph to 80 columns
nnoremap # V}gq

" Command to toggle zoomed views
function SwitchZoom()
    if &guifont == "Source\ Code\ Pro\ 16"
        set guifont=Source\ Code\ Pro\ 24
    elseif &guifont == "Source\ Code\ Pro\ 24"
        set guifont=Source\ Code\ Pro\ 10
    else
        set guifont=Source\ Code\ Pro\ 16
    endif
endfunction
noremap zo :call SwitchZoom() <CR>

" Make ctrl-h switch from "tab mode" to "space mode" and vice-versa
function SwitchTabMode()
    " If it's in "space mode"
    if &expandtab == 1
        echo "Switching to tab mode"
    " If it's in "tab mode"
    else
        echo "Switching to space mode"
    endif
    " Switch modes
    set expandtab!
endfunction
noremap <C-h> :call SwitchTabMode() <CR>

" Make ctrl-h switch from "tab mode" to "space mode" and vice-versa
function GetFileAndLine()
    silent let @+ = join([expand('%'), line(".")], ':')
    echo @+
endfunction
noremap <silent> ^^ :call GetFileAndLine() <CR>

"--------------------------------------------------------------------
" Advanced Configuration
"--------------------------------------------------------------------
" Strip Whitespace on Save
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Treat *.md as markdown
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Treat *.ixx as C++
autocmd BufNewFile,BufFilePre,BufRead *.ixx set filetype=cpp

" Stop Vim beep noises
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Go to previous cursor location when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif
"--------------------------------------------------------------------
" Install Plugin Manger
"--------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fsLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"--------------------------------------------------------------------
" Plugin Configurations
"--------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
    Plug 'altercation/vim-colors-solarized'
    " For some reason this doesn't work with vim 8.2, so had to manually
    " install.
    Plug 'preservim/nerdtree'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-sensible'
    Plug 'bling/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'pboettch/vim-cmake-syntax'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'reedes/vim-pencil'
    Plug 'lervag/vimtex'
    Plug 'chriskempson/base16-vim'
    Plug 'JuliaEditorSupport/julia-vim'
    " Plugin for Vim autocomplete snippets
    Plug 'sirVer/ultisnips'
    Plug 'KeitaNakamura/tex-conceal.vim'
    " Plugin for go-to-definition and other things
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'dylanaraps/wal'
    Plug 'sonph/onehalf', { 'rtp': 'vim' }

call plug#end()

" Latex editing config
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

"setlocal spell
"set spelllang=en_uk
"inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u


" Snippets config
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories=["~/linux-setup/config/"]

" COC extensions
let g:coc_global_extensions = ['coc-clangd', 'coc-pyright']
" Remap keys for gotos
nmap gd <Plug>(coc-definition)
nmap gt <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
" Turn off autocomplete
let b:coc_suggest_disable = 1

" Map toggle for NERDTree
noremap <C-n> :NERDTreeToggle<CR>
" Move up and down in tree
map <C-PageUp> <C-w><Left><Up><CR>
map <C-PageDown> <C-w><Left><Down><CR>
" Resize window
:let g:NERDTreeWinSize=20
" Fix line delimiter variable
let g:NERDTreeNodeDelimiter = "\u00a0"
" Open NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"--------------------------------------------------------------------
" Appearance
"--------------------------------------------------------------------
" Use Solarized colorscheme and Source Code Pro font
if has("gui_running")
    syntax on
    set t_Co=256
    set cursorline
    colorscheme onehalfdark
    let g:airline_theme='onehalfdark'
    " lightline
    " let g:lightline = { 'colorscheme': 'onehalfdark' }
    " set background=dark
    " colorscheme solarized
    set guifont=DejaVu\ Sans\ Mono\ 11
    set guioptions-=T
    set guioptions-=r
    set guioptions-=m
endif

" Color of signcolumn, which is where warnings/errors show using COC
hi SignColumn guibg=#073642
