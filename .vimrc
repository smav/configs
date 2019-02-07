""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 'Minimal' vim config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pre-reqs
set nocompatible                " disable vi compatibility
filetype plugin on              " enable filetype recognition
filetype indent on              " enable filetype specific indentation
syntax enable                   " enable syntax highlighting


" Basics
set history=100                 " vim command history
set hidden                      " Allow for easier buffer save
set timeoutlen=450              " Shorten timeouts
set ttyfast                     " Faster redraw
set lazyredraw                  " Dont update screen when running macros
set showmode                    " Show if in insert, visual etc modes
set showcmd                     " Show comand entered in last line
set matchtime=1                 " Show matching bracket fast
set autoread                    " Read a file if it changes outside of vim
set autoindent                  " Start new line with current lines indent
set copyindent                  " Use same formatting/tabs as previous indent
set smartindent
"set scrolloff=999               " Scroll X lines from screen edge
set cmdheight=2                 " Helps avoid 'hit enter'
set helpheight=10               " Help window min size
set laststatus=2                " Always show status line
set modeline
set modelines=10
set ruler                       " Line numbering for y/d command spacing
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " more complex ruler
set nonumber                    " No line numbers, its in the status bar
"set number
"set relativenumber              " Relative line numbers
set pastetoggle=<Ins>           " Paste toggle key, insert
set clipboard=unnamed           " make pasting more integrated
"" Copy/Paste/Cut
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif


" 'Sound'
set noerrorbells
set novisualbell
set t_vb=
set tm=500


" System specific settings
set shell=/bin/bash             " Default shell to start with :shell
set shellslash                  " Unix path char
set fileformats=unix,dos,mac    " detect all


" Whitespace
set listchars=tab:»·,trail:·    " Show tabs and trailing spaces.
"set list                       " show whitespace by default
set nolist                      " dont show whitespace by default
set diffopt+=iwhite             " Add ignorance of whitespace to diff
set fillchars=""                " Remove the bar gap in diff output


" Tabs, spaces, wrapping
set shiftwidth=4                " Number of spaces used for autoindent
set tabstop=4                   " Number of spaces a <Tab> counts for
set softtabstop=4               " Number of spaces that a <Tab> counts for while editing
"set noexpandtab                 " Tab inserts <Tab> not N spaces
set expandtab                   " Tab inserts N spaces
set smarttab                    "
set shiftround                  " Use a multiple of shiftwidth indenting with '<' and '>'"
set wrap                        " Wrap long lines
set textwidth=79                " Adhere to good console code style
set formatoptions=tcroqln1j       " Text auto-formatting options
" t       Auto-wrap text using textwidth
" c       Auto-wrap comments using textwidth, inserting the current comment
"         leader automatically.
" r       Automatically insert the current comment leader after hitting
"         <Enter> in Insert mode.
" o       Automatically insert the current comment leader after hitting 'o' or
"         'O' in Normal mode.
" q       Allow formatting of comments with "gq".
"         Note that formatting will not change blank lines or lines containing
"         only the comment leader.  A new paragraph starts after such a line,
"         or when the comment leader changes.
" l       Long lines are not broken in insert mode: When a line was longer than
"         'textwidth' when the insert command started, Vim does not
"         automatically format it.
" n       When formatting text, recognize numbered lists.
" 1       Don't break a line after a one-letter word.  It's broken before it
"         instead (if possible).
" j       Where it makes sense, remove a comment leader when joining lines.  For
"         example, joining:


" Searching
"
" Use Power search
nnoremap / /\v
vnoremap / /\v
set ignorecase " ignore case on search
set smartcase  " unless search term has caps in it
set incsearch  " find match as term is typed
set hlsearch   " highlight all matches
set wrapscan   " Search wraps to start of file

" Next/Previous term - center screen on searhTerm line
nnoremap n nzzzv
nnoremap N Nzzzv


" Look and Feel
"set synmaxcol=16384             " Dont syntax highlight big files
"set background=dark             " Dont blind me
"colorscheme iria256             " Use colorscheme X

" Statusline
set statusline=                               " clear the statusline
set statusline+=%1*                           " normal colouring
set statusline+=%-n\                          " buffer number
set statusline+=%-F\                          " file name
set statusline+=[%{strlen(&ft)?&ft:'none'}     " filetype
set statusline+=:                             " normal colouring
set statusline+=%{strlen(&fenc)?&fenc:&enc}]\ " encoding
set statusline+=%{'!'[&ff=='unix']}\          " ! if not unix format
set statusline+=%h%m%r%w                      " flags
set statusline+=%=                            " right align
set statusline+=[C:%c,%b]\                    " char count/ascii code"
set statusline+=[L:%l/%L\ %p%%]               " line info


" Movement fixes
"
" Modify j/k to jump to next editor row, rather than next line - long line fix
nnoremap j gj
nnoremap k gk
set backspace=indent,eol,start  " Backspace over everything
set virtualedit=all             " Allow cursor to move to 'illegal' areas
