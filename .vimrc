set nocompatible              " be iMproved, required
filetype off                  " required

" This walks up the file tree until it finds a virtualenv to activate
" You should scope this for only python files
py3 << EOF
import os
import sys
while not os.getcwd() == os.environ['HOME']:
   if '.venv' in os.listdir():
       activate = os.path.join(os.getcwd(), '.venv/bin/activate_this.py')
       exec(open(activate).read(), {'__file__': activate})
       break
   else:
       os.chdir('..')
EOF

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
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'w0rp/ale'
Plugin 'sheerun/vim-polyglot'
Plugin 'simnalamburt/vim-mundo'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'svermeulen/vim-easyclip'
" Snippet plugins
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'mattn/emmet-vim'
"" For better delimiters
Plugin 'raimondi/delimitmate'
" Javascript, React
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

" LaTex
Plugin 'lervag/vimtex'

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
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP"

" Vim Easy clip
" remap the set mark key
nnoremap gm m
" Insert mode paste
imap <c-v> <plug>EasyClipInsertModePaste
" Command mode paste
cmap <c-v> <plug>EasyClipCommandModePaste
" Share yanks among instances of vim
let g:EasyClipShareYanks = 1
" use EasyClip substitution defaults
let g:EasyClipUseSubstituteDefaults = 1
" use system clipboard
"set clipboard=unnamed

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

" some sensible defaults for YAML
autocmd FileType yaml setlocal ts=2 sw=2

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

autocmd FileType python map <buffer> <Leader>r :!python3 %<Enter>

" YouCompleteMe Conf
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_goto_buffer_command = 'split'
let g:ycm_confirm_extra_conf = 0
let g:ycm_add_preview_to_completeopt = 1
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>t :YcmCompleter GetType<CR>
nnoremap <leader>r :YcmCompleter GoToReferences<CR>
nnoremap <leader>d :YcmCompleter GetDoc<CR>

" Utilisnips conf
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-a>"

" Delimitmate
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1

" Ale config
nmap <silent> <leader>j <Plug>(ale_next_wrap)
nmap <silent> <leader>k <Plug>(ale_previous_wrap)
let g:ale_python_auto_pipenv = 1
let g:ale_linters = {'python': ['flake8', 'pylint']}
" For more configuration options check :h ale-python-options

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

" Tab blocks of text
vmap <Tab> >gv
vmap <S-Tab> <gv

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

" LaTex Config
let g:polyglot_disabled = ['latex']
let g:tex_flavor = 'latex'
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme
" First use brew to install Skim
let g:vimtex_view_method =  'skim'
