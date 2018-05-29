set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-gitgutter'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'python-mode/python-mode'
Plugin 'w0rp/ale'
Plugin 'simnalamburt/vim-mundo'
" Snippet plugins
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
" For better delimiters
Plugin 'raimondi/delimitmate'
Plugin 'pangloss/vim-javascript'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
filetype plugin indent on
filetype plugin on

" keys
map <Space> :noh<cr>
map j gj
map k gk
" Vim undo
nnoremap <C-u> :MundoToggle<CR>

" appearance
syn on se title
color torte
set ruler
set number
set laststatus=2
set background=dark
set t_Co=256

" formatting
set ai
set si
set et
set ts=4
set sw=4
set softtabstop=4

" search
set hls
set incsearch

" Fix the delete key
fixdel
set backspace=indent,eol,start

" Move cursor to last line
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Remove trailing whitespace in the specified file types
autocmd FileType c,cpp,java,php,python,javascript,ocaml autocmd BufWritePre <buffer> %s/\s\+$//e

" Nerdtree commands
map <C-o> :NERDTreeToggle<CR>

" Git Gutter conf
let g:gitgutter_override_sign_column_highlight = 0
:autocmd BufNewFile,BufRead * highlight SignColumn ctermbg=black
:autocmd BufNewFile,BufRead * highlight GitGutterAdd ctermfg=green
:autocmd BufNewFile,BufRead * highlight GitGutterChange ctermfg=yellow
:autocmd BufNewFile,BufRead * highlight GitGutterDelete ctermfg=red
:autocmd BufNewFile,BufRead * highlight GitGutterChangeDelete ctermfg=red

" Set leader to comma
let mapleader = ","

" no code folding on open
set foldlevel=99

" Pymode conf
let g:pymode_python = 'python3'
let g:pymode_rope_regenerate_on_write = 0
   " Turns off auto documentation
let g:pymode_doc = 0
let g:pymode_doc_bind = 'D'
let g:pymode_lint_on_fly = 1
let g:pymode_lint_message = 1
let g:pymode_lint_cwindow = 0
let g:pymode_run_bind = '<leader>q'
autocmd FileType python map <buffer> <Leader>r :!python3 %<Enter>

" YouCompleteMe Conf
let g:ycm_autoclose_preview_window_after_completion = 1

" Utilisnips conf
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-a>"

" Turn off column ruler
let g:pymode_options_colorcolumn = 0

" Better col ruler, only highlight the 79th char
augroup collumnLimit
  autocmd!
  autocmd BufEnter,WinEnter,FileType scala,java,python,javascript
        \ highlight ColumnLimit ctermbg=DarkGrey guibg=DarkGrey
  let columnLimit = 79 " feel free to customize
  let pattern =
        \ '\%<' . (columnLimit+1) . 'v.\%>' . columnLimit . 'v'
  autocmd BufEnter,WinEnter,FileType scala,java,python,javascript
        \ let w:m1=matchadd('ColumnLimit', pattern, -1)
augroup END

" Spell checking
set spelllang=en

"Merlin: tooling for OCaml
filetype plugin indent on
syntax enable

" Vim needs to be built with Python scripting support, and must be
" able to find Merlin's executable on PATH.
if executable('ocamlmerlin') && has('python3')
    let s:ocamlmerlin = substitute(system('opam config var share'), '\n$', '', '''') . "/merlin"
    execute "set rtp+=".s:ocamlmerlin."/vim"
    execute "set rtp+=".s:ocamlmerlin."/vimbufsync"
    " remap type check for Merlin
    map <buffer> <C-t> :MerlinTypeOf<return>
    let no_ocaml_maps=1
endif
" endof Merlin

" ocp-indent
au BufEnter *.ml setf ocaml
au BufEnter *.mli setf ocaml
au BufEnter *.mll setf ocaml
"au FileType ocaml call FT_ocaml()
"function FT_ocaml()
    "set textwidth=80
    "set shiftwidth=2
    "set tabstop=2
    "" ocp-indent with ocp-indent-vim
    "autocmd FileType ocaml execute "set rtp+=" . substitute(system('opam config var share'), '\n$', '', '''') . "/ocp-indent/vim/indent/ocaml.vim"
    "filetype indent on
    "filetype plugin indent on
"endfunction
