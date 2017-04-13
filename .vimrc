set nocompatible
filetype plugin indent on

" keys
map <Space> :noh<cr>

" appearance
syn on se title
color torte
set ruler
set number

" formatting
set ai
set si
set et
set ts=4
set sw=4
set softtabstop=4

" search
set hls

" Fix the delete key
fixdel
set backspace=indent,eol,start

" Move cursor to last line
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Remove trailing whitespace in the specified file types
autocmd FileType c,cpp,java,php,python autocmd BufWritePre <buffer> %s/\s\+$//e
