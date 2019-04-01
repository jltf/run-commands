
" plugins are managed with vim-plug
" specify a directory for plugins:
" - for neovim: ~/.local/share/nvim/plugged
" - avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'jltf/vim-sensible'
Plug 'davidhalter/jedi-vim'
" Plug 'ambv/black'
Plug 'altercation/vim-colors-solarized'
Plug 'jlanzarotta/bufexplorer'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-commentary'  " use gc/gcc for commenting/uncomenting
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'

" initialize plugin system
call plug#end()

set nocompatible  " behave in more useful way

" Maintain undo history between sessions
if has("unix")
  set undofile
  set undodir=~/.vim/undodir
endif

if has('gui_running')
  set gfn=PT\ Mono\ 10
  set guioptions-=T  " remove toolbar
  set guioptions-=r  " remove right-hand scroll bar
else
  set t_Co=256
endif

set background=light
colorscheme solarized

set hidden  " switch between buffers without saving
            " (hide buffers when they are abandoned)

" status line format:
set stl=%L\ %f%m%r%h%w\ %y\ %4{&ff}\/%{&fenc}%=%2c%V\ %3p%%

set listchars=tab:»·,trail:· " symbols for witespace characters
set list             " make whitespace characters to be visible
set scrolloff=5      " number of lines to the cursor when moving vertically
set wildmenu         " turn on the wild menu
set noerrorbells     " no sound on errors
set novisualbell
set timeoutlen=700   " the time in milliseconds that is waited for a key code
                     " or mapped keysequence to complete
set cursorcolumn     " highlight current cursor column

set expandtab        " expand tab to spaces
set ignorecase       " ignore case in search patterns
set wrap             " string wraping
set hlsearch         " highlight search
set showcmd          " show command in the last line of the screen
set linebreak
set display=lastline
set matchpairs+=<:>  " show parired <>
set showmatch        " show bracket matches
set lazyredraw       " do not redraw screen while executing macros
set history=64       " how many lines of history to remember
set undolevels=128   " maximum number of changes that can be undone
set mouse=a

set clipboard=unnamed,unnamedplus  " copy to "+ register

set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//

set undofile  " Maintain undo history between sessions

set encoding=utf-8              " set char set translation encoding
set termencoding=utf-8          " set terminal encoding
set fileencoding=utf-8          " set save encoding
set fileencodings=utf-8,cp1251  " considered encodings
set ffs=unix,dos                " use unix as the standard file type

nnoremap <silent><F3>   :set fileformat=unix<cr>
nnoremap <silent><S-F3> :set fileformat=dos<cr>
nnoremap <silent><F4>   :set fileencoding=utf8<cr>
nnoremap <silent><S-F4> :set fileencoding=cp1251<cr>

let mapleader = ','

" don't use Ex mode, use Q for formatting
map Q gq

" toggle line numbers
nnoremap <silent> <F6> :set number!<cr>

" toggle show whitespace characters
nnoremap <silent> <F7> :set list!<cr>

" delete trailing whitespace and spaces before tabs
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<cr>

" clear selection pattern register
" nnoremap <leader>sa :let @/ = ''<cr>
nnoremap <leader>sa :nohlsearch<cr>

" switching buffers
nnoremap <M-F12> :b#<cr>
nnoremap <F12> :bn<cr>
nnoremap <S-F12> :bp<cr>
nmap <leader>q :bd<cr>

" map escape key
imap jj <esc>
imap kk <esc>

" improve up/down movement on wrapped lines
nnoremap j gj
nnoremap k gk

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" folding with space
nnoremap <space> za

" move through splits
nmap <silent> <C-k> :wincmd k<cr>
nmap <silent> <C-j> :wincmd j<cr>
nmap <silent> <C-h> :wincmd h<cr>
nmap <silent> <C-l> :wincmd l<cr>


" plugin specific settings

" syntastic configuration
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_python_flake8_post_args="--max-line-length=120"
" let g:syntastic_python_checkers = ['pylint']

" BufExplorer
nmap <silent> <leader>b :BufExplorer<cr>

" NERDTree
nmap <silent> <leader>t :NERDTreeToggle<cr>
let NERDTreeQuitOnOpen=1  " hide on open
let NERDTreeIgnore=['\.pyc', '\~$']

" Tagbar
nmap <silent> <leader>f :TagbarToggle<cr>

" CtrlP
nnoremap <leader>p :CtrlPMRU<cr>

" git gutter
let g:gitgutter_max_signs=1000


" jump to last position
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" highlight trailing spaces in annoying red
highlight ExtraWhitespace ctermbg=1 guibg=red
" autocmd BufRead,BufNewFile,InsertLeave * match ExtraWhitespace /\s\+$/

au FileType python setl
  \ tabstop=4
  \ softtabstop=4
  \ shiftwidth=4
  \ colorcolumn=80,120

autocmd FileType text setl
  \ textwidth=78
  \ colorcolumn=79

" convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" only define it when not defined already.
if !exists(":DiffOrig")
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
 \ | wincmd p | diffthis
endif

" toggle :copen/:cclose
function! GetBufferList()
  redir => buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'),
      \ 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo "Location List is Empty."
    return
  endif
  let winnr = winnr()
  exec(a:pfx.'open 34')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>w :call ToggleList("Location List", 'l')<cr>
nmap <silent> <leader>e :call ToggleList("Quickfix List", 'c')<cr>


" some old things
"
" autocmd BufRead *.pls,*.utl,*.plsql,*.bdy,*.pkg,*.prc,*.seq,*.tbl,*.trg,*.vie,
"   \ *.typ,*.sql,*.upg,*.fnc
"   \ set makeprg=c:\\cygwin\\bin\\bash\ d:\\bin\\util\\sql_compile.sh\ \"%\"
" autocmd BufRead *.pls,*.utl,*.plsql,*.bdy,*.pkg,*.prc,*.seq,*.tbl,*.trg,*.vie,
"   \ *.typ,*.sql,*.upg,*.fnc set efm=%E%l/%c%m,%C%m,%Z
" setlocal errorformat=line\ %l\ column\ %v\ -\ %m

" nmap <leader>b  :w<cr> :make<cr> :copen 18<cr>
" nmap <leader>dd :w<cr> :!python "%"
" nmap <leader>df :!python D:\Bin\util\tpl_scripts\RollUp.py -i "%"<cr>
" nmap <leader>db :!python D:\Bin\util\tpl_scripts\Deblock.py -i "%"<cr>
" nmap <leader>dr :!python D:\Bin\util\tpl_scripts\Block.py -i "%"<cr>
" nmap <leader>u :!bash upload_blocks.sh<cr>
" nmap <leader>pu :!bash block_n_upload.sh "%"<cr>

" nnoremap <leader>dt  I<!--!A!-->

" change tag names to lowercase
" nnoremap <leader>sz  :%s/<\/\?\zs\(\a\+\)\ze[ >]/\L\1/g<cr>

" change tag attributes to lowercase (multiple attributes supported)
" nnoremap <leader>sx :%s/\(<[^>]*\)\@<=\<\(\a*\)\ze=['"]/\L\2/g<cr>
