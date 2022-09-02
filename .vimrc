" echo "My best vim == >^.^< =="

" ==========enable vim folding========== {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" ==========vim plugin manager========== {{{
" ==================使用Vundle管理插件========================
set nocompatible        " be iMproved, required
filetype off            " required

" polyglot插件语法包冲突解决方案
" let g:polyglot_disabled = ['markdown']          "禁用个人插件语法
" let g:polyglot_disabled = ['markdown.plugin']   "禁用polyglot中的语法
" let g:polyglot_disabled = ['plantuml.plugin']   "禁用polyglot中的语法
" let g:polyglot_disabled = ['sensible']          "关闭polyglot的default设置
" let g:polyglot_disabled = ['ftdetect']          "禁用polyglot中的文件探测

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('$VIM/vimfiles/bundle')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'               "插件管理
Plugin 'tpope/vim-surround'                 "可使块surroud, 如给word -> {word}
Plugin 'tpope/vim-unimpaired'               "缓冲区、参数、quickfix、位置、标签列表的遍历快捷键
Plugin 'tpope/vim-commentary'               "代码注释gc
Plugin 'tpope/vim-bundler'                  "gf跳转path的设置相关, 以及tags, 好像没啥效果，待研究
Plugin 'iamcco/mathjax-support-for-mkdp'    "markdown数学公式
Plugin 'iamcco/markdown-preview.nvim'       "markdown预览
Plugin 'aklt/plantuml-syntax'               "plantuml语法高亮
Plugin 'weirongxu/plantuml-previewer.vim'   "plantuml预览, need sudo apt-get install graphviz
Plugin 'tyru/open-browser.vim'              "浏览器预览渲染图, plantuml用
Plugin 'octol/vim-cpp-enhanced-highlight'   "cpp语法高亮
Plugin 'voldikss/vim-translator'            "vim翻译工具
" Plugin 'scrooloose/vim-slumlord'            "plantuml预览, 使用ASCII码在vim内部预览，效果很差
" Plugin 'sheerun/vim-polyglot'               "语法包，包含大量语法如c++、cmake、glsl、markdown、plantuml... 太过重量级，内部会修改很多配置
" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" ==================使用Vundle管理插件========================
" }}}

" ==========normal settings========== {{{
" 让配置变更立即生效, 使用快捷键运行source感觉更好
" autocmd BufWritePost $MYVIMRC source $MYVIMRC

" 启动时自动加载matchit插件，用于%配对标签间跳转, 如html标签，但是(),{}等是默认支持的
runtime macros/matchit.vim

" colorscheme morning   " 设置配色方案

filetype indent on      " 自适应不同语言的智能缩进
filetype on             " 开启文件检测
syntax on               " 开启语法高亮

set pastetoggle=<f5>    " paste与paste!的切换，启用paste在使用系统粘贴命令时可以防止奇怪的缩进

" tab 命令补全模式, 此模式tab会显示补全列表
set wildmenu
set wildmode=full

set ignorecase          "开启大小写不敏感，作用于查找和补全
set smartcase           "开启智能大小写敏感，输入大写则匹配大写，否则使用ignorecase

set history=200         "设置命令回朔历史为200条，默认为50

set number              " 显示行号
set incsearch           " 查找是预览第一处匹配
set hlsearch            " 高亮查找匹配项
" :nohlearch 命令暂时关闭高亮模式，直到执行新的或重复的查找命令
" <C-l>原是清屏重绘快捷键，将其和nohlearch一起作用
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" 定义快捷键前缀<Leader>, todo: 有冲突
" let mapleader=";"
" 设置快捷键将选中文本复制到系统剪切板
vnoremap <Leader>y "+y
" 设置快捷键将系统剪切板内容粘贴至vim
nnoremap <Leader>p "+p
" 设置快捷键打开vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
" 设置快捷键应用vimrc
nnoremap <Leader>sv :source $MYVIMRC<CR>

" 插入模式下转换光标前单词/字符串大小写
inoremap <C-y> <esc>m0bviw~`0a
inoremap <C-f> <esc>m0BviW~`0a

" multi map for esc, but i dont like it
" inoremap jk <esc>

" 设置快捷键当前缓冲区关键字补全，当普通关键字太多时使用，
" 又因为当前缓冲区关键字补全默认<C-x><C-n>太麻烦，所以进行自定义
" 下面同理, todo: <C-m>有冲突
" inoremap <C-m><C-n> <C-x><C-n> "当前缓冲区关键字
" inoremap <C-m><C-i> <C-x><C-i> "include文件关键字
" inoremap <C-m><C-]> <C-x><C-]> "标签文件关键字
" inoremap <C-m><C-k> <C-x><C-k> "字典查找
" inoremap <C-m><C-l> <C-x><C-l> "整行补全
" inoremap <C-m><C-f> <C-x><C-f> "文件名补全
" inoremap <C-m><C-o> <C-x><C-o> "智能补全

" 重映射<C-d>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间,也可理解为向下翻动半页
nnoremap <C-d> Lzz
" 重映射<C-u>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间,也可理解为向上翻动半页
nnoremap <C-u> Hzz
" 映射<C-j>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间, 也可理解为向下翻动半页
" nnoremap <C-j> Lzz
" 映射<C-k>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间, 也可理解为向上翻动半页
" nnoremap <C-k> Hzz

" %% 映射为 %:h, 即当前活动缓冲区文件路径（去掉文件名）
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" f7 执行!ctags -R
nnoremap <f7> :!ctags -R<CR>
" 每次保存文件时自动调用ctags -R, 这种方式不好，它会使得保存变慢，并且不需要tags的项目在保存时也会生成
" autocmd BufWritePost * call system("ctags -R")

" &映射为&&, 即重复上次替换命令带flag
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" space进入可视模式并选中单词
nnoremap <space> viw
" }}}

" ==========tab setting========== {{{
set tabstop=4           " tab/制表符 四个空格
set shiftwidth=4        " >> << 四个空格
set expandtab           " tab/制表符 展开为四个空格
set softtabstop=4       " 连续4个空格视为一个tab/制表符
" retab命令可以按照上面设置的规则格式化代码
" }}}

" ==========file encode setting========== {{{
set fileformat=unix             "unix 文件格式，\n为行结束符，实际测试无效，创建文件时与系统一致!!! 可以打开文件后手动设置生效
set fileformats=unix,dos,mac    "设置vim支持的系统文件格式
set nobomb                      "utf-8标准格式，bomb微软用的多
set encoding=utf-8              "vim 内部使用的字符编码方式，包括缓冲区、菜单文本、消息文本等
set fileencoding=utf-8          "vim 当前编辑的文件字符编码方式，保存和新建都是这种编码格式
" vim启动时按照列表进行探测，并将fileencoding设置为此编码方式，
" 这很好理解，即打开文件和保存文件默认情况下应该保持编码方式不变
" 可以理解为设置vim支持的文件编码格式，类似fileformats
set fileencodings=utf-8,gbk,ucs-bom,default,latin1
" termencoding: vim工作终端的编码方式
" }}}

" ==========statusline setting========== {{{
" set statusline
" set statusline=%f   "path to the file
" set statusline+=%=  "switch to the right side
" set statusline+=%l  "current line number
" set statusline+=/   "separator
" set statusline+=%L  "total line number
" set statusline+=%y  "file type
" }}}

" ==========abbreviations setting========== {{{
" 缩略句abbreviations类似map, 插入模式下输入x@可以快速替换为对应邮箱
" 不用担心所有x@都被替换，因为有iskeyword保护
iabbrev @f wonderful27x@126.com
iabbrev @g wonderful27x@gmail.com
iabbrev @w wonderful27x@outlook.com
iabbrev @y wangdef@xxxxxxx.com
" }}}

" ==========forbiden key setting========== {{{
" 插入模式和命令行模式禁用退格删除键，防止不良习惯
inoremap <backspace> <nop>
cnoremap <backspace> <nop>
" }}}

" ==========more operator-pending mappings for markdown========== {{{
" more operator-pending mappings
" for markdown "change inside/around heading"
" for example in markdown:
" Topic one
" =========
" run normal command: cih
" Topic one will be deleted and change to insert mode
" what does the map do? seperate as heres:
" ?^==\+$
" :nohlsearch
" kvg_
augroup markdown_group
    autocmd!
    autocmd FileType markdown onoremap <buffer> ih :<c-u>execute "normal! ?\\(^==\\+$\\\|^--\\+$\\)\r:nohlsearch\rkvg_"<CR>
    autocmd FileType markdown onoremap <buffer> ah :<c-u>execute "normal! ?\\(^==\\+$\\\|^--\\+$\\)\r:nohlsearch\rg_vk0"<CR>
augroup END
" }}}

" ==========visual search for */# setting========== {{{
" 可视模式按*/#对选中文本进行查询
" 注意符号:, 这是一条命令行映射，而命令行或插入模式下<C-u>代表清除至行首
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
    function! s:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction
" }}}

" ==========convenient map for grep searching========== {{{
" g@: call the function set by the 'operatorfunc'
" <SID>: use for function namespace
" <c-u>: clear the command line to the begin
" visualmode(): vim inside function to get the last visual mode type: v, V, <C-v>
" the two map below are for nomal mode, visual mode
" how to use: <localleader>giw, viw<localleader>g ...
augroup grep_group
    autocmd!
    autocmd FileType cpp nnoremap <buffer> <localleader>g :set operatorfunc=<SID>GrepOperatorCpp<CR>g@
    autocmd FileType cpp vnoremap <buffer> <localleader>g :<c-u>call <SID>GrepOperator(visualmode(), "cpp")<CR>
augroup END

function! s:GrepOperatorCpp(type)
    call <SID>GrepOperator(a:type, "cpp")
endfunction

" s: use namespace s
function! s:GrepOperator(type, filetype)
    " save the unnamed register before use
    let saved_unnamed_register = @@

    " visual mode: characterwise
    " copy the visual selected text to unnamed register
    " ==#: case-sensitive
    if a:type ==# 'v'
        normal! `<v`>y
    " normal mode: characterwise motion
    " copy the motion text(like iw/i[) to unnamed register
    elseif a:type ==# 'char'
        normal! `[v`]y
    " others right return for the reson grep can not deal with
    else
        return
    endif

    " execute the grep for searching
    " !: do not go to the first result, just fill the quickfix list
    " :copen<CR>: open the quickfix window
    " silent: do not display the message when running command
    " shellescape: to deal whit kind like words <that's> which contain single quote in grep
    if(a:filetype ==# 'cpp')
        silent execute "lgrep! -R " . shellescape(@@) . " --include=*.{cpp,h,cc} ."
    else
        silent execute "lgrep! -R " . shellescape(@@) . " ."
    endif
    " open the quickfix list window
    silent execute "normal! :lopen\<CR>"

    " restore the unnamed register after use
    let @@ = saved_unnamed_register
endfunction

" }}}

" ==========cursor shape and color setting========== {{{
" Set cursor shape and color
" before . setting shape, after . setting color
" 1 -> blinking block  闪烁的方块
" 2 -> solid block  不闪烁的方块
" 3 -> blinking underscore  闪烁的下划线
" 4 -> solid underscore  不闪烁的下划线
" 5 -> blinking vertical bar  闪烁的竖线
" 6 -> solid vertical bar  不闪烁的竖线
if &term =~ "xterm"
    let &t_SI = "\<Esc>[1 q"    "start INSERT mode
    let &t_SR = "\<Esc>[1 q"    "start REPLACE mode
    let &t_EI = "\<Esc>[2 q"    "end insert or replace mode
    let &t_VS = "\<Esc>[2 q"    "NORMAL mode
    " let &t_SI = "\<Esc>[1 q" . "\<Esc>]12;rgb:CD/B3/8B\x7"
    " let &t_SR = "\<Esc>[1 q" . "\<Esc>]12;rgb:CD/B3/8B\x7"
    " let &t_EI = "\<Esc>[2 q" . "\<Esc>]12;rgb:CD/B3/8B\x7"
    " let &t_VS = "\<Esc>[2 q" . "\<Esc>]12;rgb:CD/B3/8B\x7"
endif
" }}}
