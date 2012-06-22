" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

" This must be first, because it changes other options as a side effect.
if has("multi_byte")
   if &termencoding == ""
      let &termencoding = &encoding
   endif
   set encoding=utf-8
   setglobal fileencoding=utf-8
   " setglobal bom
   set fileencodings=ucs-bom,utf-8,latin1
endif

" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
if !exists("g:loaded_pathogen")
  call pathogen#helptags()
  call pathogen#runtime_append_all_bundles()
endif

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
set relativenumber
set laststatus=2
set ruler    " show the cursor position all the time
set showcmd    " display incomplete commands
set showmode
set statusline=%<%F\ %h%m%r%=[%03.3b]\ %Y/%{&ff}\ (%l\/%L,%c%V)\ #%n\ %P
set lazyredraw
set ttyfast
set scrolloff=2
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

set splitright
set splitbelow

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

  augroup END
endif
autocmd! BufWritePost ~/.vimrc bufdo source $MYVIMRC

au BufRead,BufNewFile *.jinja2 set filetype=html.javascript.jinja2
au BufRead,BufNewFile *.cc,*.h,*.hpp,*.cpp set filetype=cpp.doxygen
au BufRead,BufNewFile *.cmake set filetype=cmake
au BufRead,BufNewFile *.md set filetype=markdown
autocmd FileType make setlocal noexpandtab

" File management
set suffixes=.jpg,.png,.jpeg,.gif,.bak,~,.swp,.swo,.log,.pyc,.pyo,.o

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent    " always set autoindenting on
set nocopyindent  " if set to True, creates tabs instead of spaces
set smartindent

" Indent management
set expandtab " uses spaces instead of tabs
set smarttab
function! Indent(size)
  let &shiftwidth=a:size " beginning of line with smarttab
  let &tabstop=a:size " everything else with smarttab
  let &softtabstop=a:size
endfunction

call Indent(2)

set autochdir

" Backup
set history=500    " keep 50 lines of command line history
set undolevels=500
set noswapfile
set nobackup

" Search
set incsearch    " do incremental searching
set smartcase
set infercase
set wildignorecase " file name case insensitive completion
set showmatch
set showfulltag
set gdefault " substitutes are global by default

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=1

set timeoutlen=500
set autoread " Read changes on a file by a different application
set linebreak
set clipboard+=unnamed,unnamedplus
set tabpagemax=15
set wildmenu
set wildignore=*.o,*~,*.dll,*.so,*.a,*.pyc,*.pyo,*.swp,*.bak,*.class
set wildmode=list:longest,list:full
set fillchars="" " split separators
set diffopt+=iwhite " what to consider as a diff
set shortmess=atI " Shorten vim messages
set whichwrap=b,s,h,l,<,>,[,] " Easier navigation
set hidden " don't close buffers, just hide them
set key=
set nostartofline

" shutdown error bells
set noerrorbells
set visualbell
set t_vb=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key binding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set pastetoggle=<F2>
let mapleader="," "leader controls

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

" search
nnoremap / /\v
vnoremap / /\v
nmap <silent> <C-N> :silent noh<CR>

"diff
nmap dc ]czz

nmap > >>
nmap < <<
vnoremap < <gv
vnoremap > >gv

cmap w!! w !sudo tee % >/dev/null
nmap <CR> o<esc>
nnoremap <leader>* [I

" splits
nmap <C-O> :split<CR>
nmap <C-E> :vsplit<CR>
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" tabs
nmap <C-T> :tabnew<CR>
nnoremap gt :tabprevious<CR>
nnoremap gr :tabnext<CR>

" nmap <BS> X
nmap <leader>d :bdelete #<cr>
nmap <leader>b :buffers<cr>:b 
nnoremap <leader>d "_d
nmap <leader>g :!egrep "/" *
nnoremap <leader>s :%s#/#
nmap <leader>S :bufdo %s#/#

"paste shortcuts
nmap <leader>p "+p
nmap <leader>P "*p

" config files
nmap <leader>av :vsplit ~/.vimrc<cr>
nmap <leader>ab :vsplit ~/.bashrc<cr>
nmap <leader>az :vsplit ~/.zshrc<cr>
nmap <leader>ac :vsplit ~/.commonrc<cr>
nmap <leader>au :vsplit ~/.uncommonrc<cr>

" allow command line editing like emacs
cnoremap <C-A>       <Home>
cnoremap <C-B>       <Left>
cnoremap <C-E>       <End>
cnoremap <C-F>       <Right>
cnoremap <C-N>       <End>
cnoremap <C-P>       <Up>
cnoremap <C-j>       <t_kd>
cnoremap <C-k>       <t_ku>
cnoremap <M-B>       <S-Left>
cnoremap <ESC><C-B>  <S-Left>
cnoremap <M-B>       <S-Right>
cnoremap <ESC><C-F>  <S-Right>
cnoremap <ESC><C-H>  <C-W>

cnoremap s# s#\v

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Conque
"let g:ConqueTerm_FastMode = 1
"let g:ConqueTerm_ReadUnfocused = 1
"let g:ConqueTerm_InsertOnEnter = 1
"map <silent><leader>s <esc>:ConqueTerm zsh<CR>

" LustyJuggler
"let g:LustyJugglerDefaultMappings = 0
"let g:LustyJugglerSuppressRubyWarning = 1
"nmap <silent> <Leader>b :LustyJuggler<CR>

" Tagbar
let g:tagbar_usearrows = 1
nnoremap <silent><leader>t :TagbarToggle<CR>

" Yankring
"let g:yankring_history_dir = "~/config/data/vim/yankring"
"let g:yankring_enabled = 0

" Syntastic
let g:syntastic_mode_map = {'mode': 'active',
      \'active_filetypes': [],
      \'passive_filetypes': ['python']}

noremap <leader>x <Esc>:Errors<CR>

" UltiSnips
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsListSnippets = "<C-s>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:ultisnips_python_style = "sphinx"
noremap <leader>as :UltiSnipsEdit<cr>

" Quicksilver
let g:QSMatchFn = "fuzzy"
let g:QSIgnored = "\\.pyc$;\\.swp$"

" detectindent
autocmd bufReadPost * :DetectIndent
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 2

" Indent-guides
"noremap <leader>ig <nop>
"let g:indent_guides_auto_colors = 0
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=None
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=234
"let g:indent_guides_enable_on_vim_startup = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! Refresh()
  syntax on
  silent! syntax sync fromstart
  if &diff
     diffupdate
  endif
endfunction

function! PrintMode()
  set list!
  set number!
endfunction

function! LoadTemplate()
  silent! 0r ~/.vim/templates/tmpl.%:e
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
  CommandTFlush
endfunction

"""""""""""""""""""""""""""""""""""""""
" Search for selected text.
" http://vim.wikia.com/wiki/VimTip171
let s:save_cpo = &cpo | set cpo&vim
if !exists('g:VeryLiteral')
  let g:VeryLiteral = 0
endif

function! s:VSetSearch(cmd)
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  normal! gvy
  if @@ =~? '^[0-9a-z,_]*$' || @@ =~? '^[0-9a-z ,_]*$' && g:VeryLiteral
    let @/ = @@
  else
    let pat = escape(@@, a:cmd.'\')
    if g:VeryLiteral
      let pat = substitute(pat, '\n', '\\n', 'g')
    else
      let pat = substitute(pat, '^\_s\+', '\\s\\+', '')
      let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
      let pat = substitute(pat, '\_s\+', '\\_s\\+', 'g')
    endif
    let @/ = '\V'.pat
  endif
  normal! gV
  call setreg('"', old_reg, old_regtype)
endfunction

vnoremap <silent> * :<C-U>call <SID>VSetSearch('/')<CR>/<C-R>/<CR>
vnoremap <silent> # :<C-U>call <SID>VSetSearch('?')<CR>?<C-R>/<CR>
vmap <kMultiply> *

nmap <silent> <Plug>VLToggle :let g:VeryLiteral = !g:VeryLiteral
  \\| echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<CR>
if !hasmapto("<Plug>VLToggle")
  nmap <unique> <Leader>vl <Plug>VLToggle
endif
let &cpo = s:save_cpo | unlet s:save_cpo

"""""""""""""""""""""""""""""""""""""
" Shortcuts
"""""""""""""""""""""""""""""""""""""

nmap <silent><leader>f :Explore<CR>
nmap <silent><leader>c <esc>:keepjumps call CleanExtraSpaces()<CR>
nmap <silent><leader>o <esc>:DiffOrig<CR>
nmap <silent><leader>h <esc>:nmap <leader><CR>
nmap <silent><F5> :call Refresh()<cr>
nmap <silent><F6> :call PrintMode()<cr>
nmap ,i :call Indent()<left>
