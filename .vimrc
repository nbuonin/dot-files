" My general thinking as of now is to use YCM only for completion, as it seems
" the fastest for that. For goto definitions, getting docs, getting types, and
" finding references I plan to use ALE. I think it makes sense for ALE to be
" the Language Server client for my setup for now. There are other options out
" there, and it may make sense to blow this up in the future. For example,
" Deoplete seems to be popular for completion, as well as LanguageServer to
" the things that ALE does.
set nocompatible              " be iMproved, required
filetype off                  " required

" Enable the virtualenv
py3 << EOF
import os
import site
import sys
path = os.getcwd()
# Add possible names for virtualenvs here
ve = ['.venv', 've']


def activate(bin_dir):
    """Taken from pypa/virtual_env:
    https://github.com/pypa/virtualenv/blob/master/virtualenv_embedded/activate_this.py """
    # prepend bin to PATH (this file is inside the bin directory)
    os.environ["PATH"] = os.pathsep.join([bin_dir] + os.environ.get("PATH", "").split(os.pathsep))

    base = os.path.dirname(bin_dir)

    # virtual env is right above bin directory
    os.environ["VIRTUAL_ENV"] = base

    # add the virtual environments site-package to the host python import mechanism
    IS_PYPY = hasattr(sys, "pypy_version_info")
    IS_JYTHON = sys.platform.startswith("java")
    if IS_JYTHON:
        site_packages = os.path.join(base, "Lib", "site-packages")
    elif IS_PYPY:
        site_packages = os.path.join(base, "site-packages")
    else:
        IS_WIN = sys.platform == "win32"
        if IS_WIN:
            site_packages = os.path.join(base, "Lib", "site-packages")
        else:
            site_packages = os.path.join(base, "lib", "python{}.{}".format(*sys.version_info), "site-packages")

    prev = set(sys.path)
    site.addsitedir(site_packages)
    sys.real_prefix = sys.prefix
    sys.prefix = base

    # Move the added items to the front of the path, in place
    new = list(sys.path)
    sys.path[:] = [i for i in new if i not in prev] + [i for i in new if i in prev]


while path != os.environ['HOME']:
    curr_dir = os.listdir(path)
    if any(el in ve for el in curr_dir):
        ve_root = set(ve).intersection(set(curr_dir)).pop()
        bin_root = os.path.join(path, ve_root + '/bin')
        activate(bin_root)
        break
    else:
        path = os.path.split(path)[0]
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
inoremap jk <ESC>
map <Space> :noh<cr>
map j gj
map k gk
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP"

" Mouse
set mouse=a
set ttymouse=xterm

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
let g:ycm_confirm_extra_conf = 0
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_language_server = [ {
    \ 'name': 'haskell',
    \ 'filetypes': [ 'haskell' ],
    \ 'cmdline': [ 'hie-wrapper' ],
    \ } ]
" To disable YCM
"let g:ycm_filetype_blacklist = { '*': 1 }


" Utilisnips conf
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-a>"

" Delimitmate
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 1

" Ale config
" Jump to errors
nmap <silent> <leader>j <Plug>(ale_next_wrap)
nmap <silent> <leader>k <Plug>(ale_previous_wrap)
" Underline errors
hi Error term=underline cterm=underline ctermfg=Red gui=undercurl guisp=Red
hi link ALEError Error
hi Warning term=underline cterm=underline ctermfg=Yellow gui=undercurl guisp=Gold
hi link ALEWarning Warning
hi link ALEInfo SpellCap
" Python linters
"let g:ale_python_auto_pipenv = 1
let g:ale_linters = {'python': ['pyls', 'flake8', 'pylint']}
" For more configuration options check :h ale-python-options
" Use the quickfix list
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1
" let g:ale_open_list = 1
let g:ale_completion_enabled = 0
let g:ale_set_balloons = 1
" GoTo definition
nnoremap <leader>g :ALEGoToDefinitionInSplit<CR>
nnoremap <leader>G :ALEGoToDefinitionInTab<CR>
" Get type
nnoremap <leader>t :ALEGoToTypeDefinitionInSplit<CR>
nnoremap <leader>T :ALEGoToTypeDefinitionInTab<CR>
" Find references
nnoremap <leader>r :ALEFindReferences<CR> 
" Get available documentation
nnoremap <leader>d :ALEHover<CR>
autocmd InsertEnter * if pumvisible() == 0 | pclose | endi
" Use :au ALEEvent to see possible events for ALE
" Taken from here:
" https://vi.stackexchange.com/questions/4056/is-there-an-easy-way-to-close-a-scratch-buffer-preview-window
"autocmd CursorMoved * if pumvisible() == 0 | pclose | endi

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

" Merlin: tooling for OCaml
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
