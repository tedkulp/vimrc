set nocompatible

set number
set ruler
syntax on

let mapleader=","

" Set encoding
set encoding=utf-8

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Status bar
set laststatus=2

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=72
endfunction

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

au BufRead,BufNewFile *.txt call s:setupWrapping()

" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79 expandtab

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Use modeline overrides
set modeline
set modelines=10

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Turn off jslint errors by default
let g:JSLintHighlightErrorLine = 0

" Show (partial) command in the status line
set showcmd

" PHP file handling
au Filetype php set tabstop=4
au Filetype php set shiftwidth=4
au Filetype php set softtabstop=4
au Filetype php set noexpandtab

" Turn off backup and swap files
set nobackup
set noswapfile

" Various stuff
set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.pyc,*.class
set title
set visualbell
set noerrorbells

" Ack-grep for Debian/Ubunut
if !has("gui_macvim")
  let g:ackprg="ack-grep -H --nocolor --nogroup --column"
endif

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Get $ not to be selected when double clicking in php
au FileType php         set iskeyword=@,48-57,_,192-225

" Jekyll stuff
let g:jekyll_path = "/Users/tedkulp/ruby/jekyll/_source"
let g:jekyll_posts_path = "/Users/tedkulp/Dropbox/tedkulp.com/_posts"
let g:jekyll_drafts_path = "/Users/tedkulp/Dropbox/tedkulp.com/_drafts"
let g:jekyll_prompt_tags = "true"
let g:jekyll_post_date = "true"

map <Leader>jn  :JekyllPost<CR>
map <Leader>jd  :JekyllDraft<CR>
map <Leader>jl  :JekyllList<CR>

let g:fuf_coveragefile_prompt = '>GoToFile[]>'
let g:fuf_coveragefile_exclude = '\v\~$|' .
\                                '\.(o|exe|dll|bak|swp|log|sqlite3|png|gif|jpg)$|' .
\                                '(^|[/\\])\.(hg|git|bzr|bundle)($|[/\\])|' .
\                                '(^|[/\\])(log|tmp|vendor|system|doc|coverage|build|generated)($|[/\\])'

let g:fuf_keyOpenTabpage = '<D-CR>'

nmap <Leader>t :FufCoverageFile<CR>
nmap <Leader>b :FufBuffer<CR>
nmap <Leader>f :FufRenewCache<CR>
nmap <Leader>T :FufTagWithCursorWord!<CR>

" Ack in text mode
map g/ :Ack<space>

" Too slow!!!
if has("gui_macvim")
  autocmd FileType ruby,eruby set noballooneval
  " set noballooneval
  " set balloondelay=100000
endif
