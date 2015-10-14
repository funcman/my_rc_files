" Vundle配置
"
" 加载Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" 
" Vundle命令
" =======
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" Vundle插件配置格式
" =======
" vim-scripts仓库里的，按下面格式填写:
" Plugin 'taglist.vim'
" Github网站上非vim-scripts仓库的插件，按下面格式填写
" Plugin 'Lokaltog/vim-powerline'
" 非上面两种情况的，按下面格式填写
" Plugin 'git://git.wincent.com/command-t.git'
"
" 插件列表:
" 必要插件
Plugin 'VundleVim/Vundle.vim'
" 功能插件
Plugin 'Lokaltog/vim-powerline'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
" 配色插件
Plugin 'crusoexia/vim-monokai'
"
call vundle#end()
filetype plugin indent on

" vim自己的配置
" =======
" 非一致性模式
set nocompatible
" 检测文件类型
filetype on
" 记录历史行数
set history=1024
" 高亮当前行
set cursorline
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
hi CursorColumn	cterm=NONE ctermbg=darkred ctermfg=white
" 显示行号
set nu
" 语法高亮
syntax enable
" 设置Tab、折行为4空格
set tabstop=4
set shiftwidth=4
set expandtab
" 设置退格键
set backspace=indent,eol,start
" 自动对齐、智能缩进、括号匹配等
set autoindent
set cindent
set smartindent
set ai!
set showmatch 
" 设置换行格式为UNIX
set fileformat=unix
" 以EOL结尾
set endofline
" 默认使用UTF-8
set encoding=utf8
" 依次尝试UTF-8、GBK、GB18030
set fencs=utf-8,gbk,gb18030
" 查找是忽略大小写
set ignorecase
" 查找输入中自动匹配
set incsearch

" 实用函数
function! MySys()
    if has("win32")
        return "windows"
    else
        return "posix"
    endif
endfunction

" vim-powerline
set laststatus=2
set t_Co=256
let g:Powerline_symbols = 'unicode'

" tagbar
if MySys() == "windows"
    let g:tagbar_ctags_bin='ctags'
else
    let g:tagbar_ctags_bin='/usr/local/Cellar/ctags/5.8_1/bin/ctags'
endif
map t :TagbarToggle<CR>
let g:tagbar_left=1
let g:tagbar_width=30
let g:tagbar_type_objc = {
    \ 'ctagstype': 'objc',
    \ 'ctagsargs': [
        \ '-f',
        \ '-',
        \ '--excmd=pattern',
        \ '--extra=',
        \ '--format=2',
        \ '--fields=nksaSmt',
        \ '--options=' . expand('~/.vim/objctags'),
        \ '--objc-kinds=-N',
    \ ],
    \ 'sro': ' ',
    \ 'kinds': [
        \ 'c:constant',
        \ 'e:enum',
        \ 't:typedef',
        \ 'i:interface',
        \ 'P:protocol',
        \ 'p:property',
        \ 'I:implementation',
        \ 'M:method',
        \ 'g:pragma',
    \ ],
\ }

" nerdtree
map w :NERDTreeToggle<CR>
nn <silent><F2> :exec("NERDTree ".expand('%:h'))<CR>
let NERDTreeWinPos='right'

