" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

" This must be first, because it changes other options as a side effect.
if has("multi_byte")
   if &termencoding == ""
      let &termencoding = &encoding
   endif
   set encoding=utf-8
   setglobal fileencoding=utf-8
   setglobal bomb
   set fileencodings=ucs-bom,utf-8,latin1
endif

" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if $TERM == 'linux' || $TERM == 'screen' || $TERM == 'rxvt'
  colorscheme impact
else
  set t_Co=256
  colorscheme lucius
endif

set number
set laststatus=2
set ruler    " show the cursor position all the time
set showcmd    " display incomplete commands
set showmode
set statusline=%<%F\ %h%m%r%=[%03.3b]\ %Y/%{&ff}\ (%l\/%L,%c%V)\ #%n\ %P
set lazyredraw
set ttyfast
set scrolloff=5
set cursorline
set title

" Displays unprintable characters
set list
set listchars=eol:¶,tab:→→,trail:»,extends:↓,precedes:←,nbsp:·

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
"if has('mouse')
"  set mouse=a
"endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File type
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if has("autocmd")
  filetype plugin indent on
  autocmd! BufNewFile * call LoadTemplate()

  augroup vimrcEx
    au!
    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

    autocmd! BufWritePost .\?vimrc source ~/.vimrc
  augroup END
endif

au BufRead,BufNewFile *.jinja2 set filetype=html.javascript.jinja2
au BufRead,BufNewFile *.cc,*.h,*.hpp,*.cpp set filetype=cpp.doxygen
au BufRead,BufNewFile *.cmake set filetype=cmake
au BufRead,BufNewFile *.md set filetype=markdown

" File management
set suffixes=.jpg,.png,.jpeg,.gif,.bak,~,.swp,.swo,.log,.pyc,.pyo,.o

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent    " always set autoindenting on
set copyindent
set smartindent

" Indent management
set expandtab
set shiftwidth=2
set softtabstop=2
set smarttab

set autochdir

" Backup
set history=500    " keep 50 lines of command line history
set undolevels=500
set noswapfile
set nobackup

" Search
set incsearch    " do incremental searching
set noignorecase
set smartcase
set infercase
set showmatch
set showfulltag

" Folding
set foldenable
set foldmethod=syntax

set timeoutlen=500
set autoread " Read changes on a file by a different application
set linebreak
set clipboard+=unnamed,unnamedplus
set tabpagemax=15
set wildmenu
set wildignore=*.o,*~,*.dll,*.so,*.a,*.pyc,*.pyo,*.swp,*.bak,*.class
set wildmode=longest,list,full
set fillchars="" " split separators
set diffopt+=iwhite " what to consider as a diff
set shortmess=atI " Shorten vim messages
set whichwrap=b,s,h,l,<,>,[,] " Easier navigation
set hidden " don't close buffers, just hide them
set key=
set nostartofline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key binding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set pastetoggle=<F2>
let mapleader="," "leader controls
cmap w!! w !sudo tee % >/dev/null
nmap <cr> o<esc>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

if has("spell")
  setlocal spell spelllang=
  nmap <silent> <leader>lf :setlocal spell spelllang=fr<cr>
  nmap <silent> <leader>le :setlocal spell spelllang=en<cr>
  nmap <silent> <leader>ll :setlocal spell spelllang=<cr>
endif
set spellsuggest=5

" key easier access for Azerty keyboards
noremap é ~
nnoremap à @
nnoremap ù %
noremap ç ^
noremap è `
noremap ² [
noremap & ]

nmap dc ]czz
nmap <silent> <C-N> :silent noh<CR>
nmap > >>
nmap < <<

"paste shortcuts
nmap <leader>p "+p
nmap <leader>P "*p
nmap <leader>0 "0p
nmap <leader>1 "1p
nmap <leader>2 "2p
nmap <leader>3 "3p
nmap <leader>4 "4p
nmap <leader>5 "5p
nmap <leader>6 "6p
nmap <leader>7 "7p
nmap <leader>8 "8p
nmap <leader>9 "9p

" config files

nmap <leader>av :split ~/.vimrc<cr>
nmap <leader>ab :split ~/.bashrc<cr>
nmap <leader>az :split ~/.zshrc<cr>
nmap <leader>ac :split ~/.commonrc<cr>
nmap <leader>ap :split ~/.profile<cr>
nmap <leader>as :split ~/.subversion/config<cr>
nmap <leader>ag :split ~/.gitconfig<cr>

" windows related controls
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" allow command line editing like emacs
cnoremap <C-A>      <Home>
cnoremap <C-B>      <Left>
cnoremap <C-E>      <End>
cnoremap <C-F>      <Right>
cnoremap <C-N>      <End>
cnoremap <C-P>      <Up>
cnoremap <ESC>b     <S-Left>
cnoremap <ESC><C-B> <S-Left>
cnoremap <ESC>f     <S-Right>
cnoremap <ESC><C-F> <S-Right>
cnoremap <ESC><C-H> <C-W>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Conque
let g:ConqueTerm_FastMode = 1
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_InsertOnEnter = 1
map <silent><leader>s <esc>:ConqueTerm zsh<CR>

" LustyJuggler
let g:LustyJugglerDefaultMappings = 0
let g:LustyJugglerSuppressRubyWarning = 1
nmap <silent> <Leader>b :LustyJuggler<CR>

" Tagbar
let g:tagbar_usearrows = 1
nnoremap <silent><leader>t :TagbarToggle<CR>

"  Command-t
noremap <leader>f <Esc>:call ProjectRoot()<CR>

" Syntastic
noremap <leader>x <Esc>:Errors<CR>

" Indent-guides
noremap <leader>ig <nop>
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=None
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=234
let g:indent_guides_enable_on_vim_startup = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! LoadTemplate()
  silent! 0r ~/.vim/templates/tmpl.%:e
  syn match Todo "¤\w\+¤" containedIn=ALL
  silent! /¤w\+¤
endfunction

function! CleanExtraSpaces()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  retab
  set ff=unix
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction

function! DelimitColumns()
  if &colorcolumn == ''
    set colorcolumn=80,81,82
  else
    set colorcolumn=
  endif
endfunction

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

function! ProjectRoot()
  let dest=""
  let parent="."
  while isdirectory(parent . "/.svn")
    let dest=parent
    let parent=parent . "/.."
  endwhile
  if dest == ""
    let parent="."
    while isdirectory(parent)
      if isdirectory(parent . "/.git")
        let dest=parent
        break
      else
        let parent=parent . "/.."
      endif
    endwhile
  endif
  if dest == ""
    let current_dir=getcwd()
    for folder in split($PROJECTPATH, ":")
      if current_dir =~ folder . "/"
        let dest = substitute(current_dir, folder . "\\/\\([^/]\\+\\).*", folder . "\\/\\1", "g")
        break
      endif
    endfor
  endif
  if dest == ""
    let dest="~"
  endif
  exec "cd" dest
  CommandT
endfunction

function! Shortcuts()
  echo ",e : explorer"
  echo ",c : clean extra spaces"
  echo ",d : delimit columns"
  echo ",o : diff with origin"
  echo ",s : shell"
  echo ",b : buffers"
  echo ",t : tags"
  echo ",f : file explorer"
  echo ",x : syntax"
  echo ",l e/f/l : language"
endfunction

" Shortcuts
nmap <silent> <leader>e :Explore<CR>
nmap <silent><leader>c <esc>:keepjumps call CleanExtraSpaces()<CR>
nmap <silent><leader>d <esc>:call DelimitColumns()<CR>
nmap <silent><leader>o <esc>:DiffOrig<CR>
nmap <leader>h <esc>:call Shortcuts()<CR>
