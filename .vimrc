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

Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
  set laststatus=2 " always display the powerline
  set t_Co=256  " full color support

Plugin 'kien/ctrlp.vim'
  " ctrlp show dotfiles
  let g:ctrlp_show_hidden = 1

Plugin 'ntpeters/vim-better-whitespace'
  " strip whitespace automagically
  autocmd FileType ruby,javascript,html,css autocmd BufWritePre <buffer> StripWhitespace

Plugin 'tpope/vim-rails'

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

"stupid autoindent
set noautoindent

"smerter line nummers
set number
autocmd InsertEnter * :set number
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
autocmd Winleave * :set number
autocmd WinLeave * :set norelativenumber
autocmd WinEnter * :set relativenumber

"alternate escape sequence
imap jj <Esc>

"easier save
imap fj <Esc>:w<CR>i
nmap fj :w<CR>

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
