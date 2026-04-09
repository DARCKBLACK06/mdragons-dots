call plug#begin()
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" ─── General ───────────────────────────────────────────
set encoding=UTF-8
set number
set relativenumber
set cursorline
set nowrap
set scrolloff=8
set signcolumn=yes
set termguicolors
set hidden
set splitright
set splitbelow

" ─── Indentación ───────────────────────────────────────
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

" ─── Búsqueda ──────────────────────────────────────────
set ignorecase
set smartcase
set incsearch
set hlsearch

" ─── Leader ────────────────────────────────────────────
let mapleader=" "

" ─── Keymaps ───────────────────────────────────────────
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :wq<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>l :bnext<CR>
nnoremap <leader>k :bprevious<CR>
nnoremap <leader>c :bd<CR>
nnoremap <leader>e :NERDTreeFocus<CR>
nnoremap <leader>r :source ~/.vimrc<CR>
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" ─── NERDTree ──────────────────────────────────────────
let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeWinPos = "left"
let g:NERDTreeWinSize = 30
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" ─── Git icons ─────────────────────────────────────────
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Ignored"   : "☒",
    \ "Unknown"   : "?"
    \ }

" ─── Airline ───────────────────────────────────────────
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dark'
let g:airline_statusline_ontop = 1

" ─── Autocomandos ──────────────────────────────────────
" UN solo autocmd que maneja ambos casos
autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * if !exists('s:std_in') |
  \ if argc() == 0 |
  \   NERDTree | wincmd p |
  \ elseif argc() == 1 && isdirectory(argv()[0]) |
  \   execute 'cd ' . fnameescape(argv()[0]) |
  \   NERDTree | wincmd p |
  \ endif |
  \ endif

" Cerrar vim si solo queda NERDTree
autocmd BufEnter * if winnr('$') == 1 && &filetype ==# 'nerdtree' |
  \ quit |
  \ endif
