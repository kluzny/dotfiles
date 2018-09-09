set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" My Plugins
Plugin 'YorickPeterse/happy_hacking.vim'
Plugin 'chrisbra/Colorizer'
  let g:colorizer_auto_filetype='css,html,scss,sass,js'

Plugin 'posva/vim-vue'

Plugin 'christoomey/vim-tmux-navigator'
Plugin 'mileszs/ack.vim'

Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
  set laststatus=2 " always display the powerline
  set t_Co=256  " full color support

Plugin 'kien/ctrlp.vim'
  " ctrlp show dotfiles
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_custom_ignore = {
  \ 'dir': '\v\/(\.git|tmp|node_modules)'
  \ }

Plugin 'ntpeters/vim-better-whitespace'
  " strip whitespace automagically
  autocmd FileType ruby,javascript,html,css autocmd BufWritePre <buffer> StripWhitespace

Plugin 'tpope/vim-rails'
Plugin 'jiangmiao/auto-pairs'

" some js stuff
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'nathanaelkane/vim-indent-guides'

" some template stuff
Plugin 'slim-template/vim-slim.git'

" Golang
Plugin 'fatih/vim-go'
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-install)
au FileType go nmap <Leader>d <Plug>(go-doc)
au FileType go nmap <Leader>i <Plug>(go-implements)
au FileType go setl noet ci pi sts=0 sw=2 ts=2

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" Syntax Checking
Plugin 'scrooloose/syntastic'

" Syntastic Config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_jump=0
let g:syntastic_enable_signs=1
let g:syntastic_loc_list_height=5

let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_filetype_map = { 'handlebars.html': 'handlebars' }
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go', 'handlebars']  }
let g:syntastic_eruby_ruby_quiet_messages = {'regex': 'possibly useless use of a variable in void context'}

" Sometime this is really annoying
nnoremap <leader>T <ESC>:SyntasticToggleMode<CR>
nnoremap <leader>t <ESC>:lclose<CR>

Plugin 'scrooloose/nerdcommenter'
let NERDSpaceDelims=1

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

" enable syntax highlighting
syntax on

"stupid autoindent
set noautoindent

"smerter line nummers 7.4+
set number
autocmd InsertEnter * :set number
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
autocmd Winleave * :set number
autocmd WinLeave * :set norelativenumber
autocmd WinEnter * :set relativenumber

"alternate escape sequence
imap jj <Esc>

"exit shortcut
imap qq <Esc>:q<CR>
nmap qq :q<CR>

"weird mac backspace issues
set backspace=indent,eol,start

" Backups
set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" 2 spaces is certainly the best tab
set tabstop=2 " size of a hard tabstop
set shiftwidth=2 " size of an "indent"
set softtabstop=2 " a combination of spaces and tabs are used to simulate tab stops
set smarttab " make tab insert indents instead of tabs at the beginning of a line
set expandtab " always uses spaces instead of tab characters

" python stuff
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" ctrl + hjkl split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" fold settings
set foldmethod=indent   "fold based on indent
set foldnestmax=8       "deepest fold is 10 levels
set foldminlines=0      "min"
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" show keypresses mid-command
set showcmd

" json formatting
command PPjson %!python -m json.tool

" xml formatting
command PPxml %!xmllint --encode UTF-8 --format -

" Invisible characters
set list
set listchars=tab:▸\ 

color happy_hacking
