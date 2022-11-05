" echo "My best vim == >^.^< =="

" ==========translator proxy setting========== {{{
let g:translator_proxy_url = 'socks5://127.0.0.1:1080'
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

" ==========global variables========== {{{
let g:quickfix_l_is_open = 0

let g:v_beg = 0
let g:v_mid = 0
let g:v_end = 0
let g:v_last_p = 0

let g:h_beg = 0
let g:h_mid = 0
let g:h_end = 0
let g:h_last_p = 0
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
" nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
" 但是清屏会使屏幕闪烁一下，效果非常差，所以重映射<C-p>为暂时关闭高亮模式
" 并重映射<leader><C-l>为清屏，因为我们想将<C-l>用于其他功能
nnoremap <silent> <C-p> :<C-u>nohlsearch<CR>
nnoremap <silent> <leader><C-l> :<C-u>nohlsearch<CR><C-l>

" 定义快捷键前缀<Leader>, todo: 有冲突
" let mapleader=";"
" 设置快捷键将选中文本复制到系统剪切板
vnoremap <Leader>y "+y
" 设置快捷键将系统剪切板内容粘贴至vim
nnoremap <Leader>p "+p
" 设置快捷键打开vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
" 设置快捷键应用vimrc
nnoremap <Leader>sv :source $MYVIMRC<CR>:<C-u>nohlsearch<CR>:echo "run source vimrc ok!"<CR>

" 插入模式下转换光标前单词/字符串大小写
" inoremap <C-y> <esc>m0bviw~`0a
" inoremap <C-f> <esc>m0BviW~`0a
" 改进版本，考虑命名空间god::VIM,
" 现在想在中间加一个命名空间变成god::EDITOR::VIM
" 于是编辑成这样god::editorVIM,
" 光标在editor的末尾，<C-y>将其转换为大写，可是VIM也被转换了
" 但是这又引入了另一个bug, 当光标位于单词首字母时，只有光标下的字母会被转换
inoremap <C-y> <esc>mzvgew~`za
inoremap <C-f> <esc>mzvgEW~`za

" multi map for esc, But i dont iwe it
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

" map Y to yank text from cursor to the end of line
nnoremap Y y$
" }}}

" ==========fold setting========== {{{
" no fold when open file
set foldlevelstart=99

" vim fold setting
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" cpp fold setting
augroup filetype_cpp
    autocmd!
    autocmd FileType cpp setlocal foldmethod=syntax
    autocmd FileType c setlocal foldmethod=syntax
augroup END

" toggle foldcolumn
nnoremap <leader>d :call <SID>FoldColumnToggle()<CR>
function! s:FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction
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
" traverse quickfix window history
nnoremap <leader>q :lolder<CR>
nnoremap <leader>Q :lnewer<CR>
" better use than <leader>Q
nnoremap <leader><leader>q :lnewer<CR>

" command completement of search
nnoremap <leader>ss /<C-r><C-w>
nnoremap <leader><leader>ss /\<<C-r><C-w>\><Left><Left>

" command completement of grep
nnoremap <leader>sa :lvimgrep // ./**/*.cpp ./**/*.cc ./**/*.c ./**/*.h<C-f>:call cursor(0,11)<CR>
nnoremap <leader>sc :lvimgrep // ./**/*.cpp ./**/*.cc ./**/*.c<C-f>:call cursor(0,11)<CR>
nnoremap <leader>sh :lvimgrep // ./**/*.h<C-f>:call cursor(0,11)<CR>
nnoremap <leader>s% :lvimgrep // %<C-f>:call cursor(0,11)<CR>
nnoremap <leader><leader>sa :lvimgrep /\<\>/ ./**/*.cpp ./**/*.cc ./**/*.c ./**/*.h<C-f>:call cursor(0,13)<CR>
nnoremap <leader><leader>sc :lvimgrep /\<\>/ ./**/*.cpp ./**/*.cc ./**/*.c<C-f>:call cursor(0,13)<CR>
nnoremap <leader><leader>sh :lvimgrep /\<\>/ ./**/*.h<C-f>:call cursor(0,13)<CR>
nnoremap <leader><leader>s% :lvimgrep /\<\>/ %<C-f>:call cursor(0,13)<CR>

" g@: call the function set by the 'operatorfunc'
" <SID>: use for function namespace
" <c-u>: clear the command line to the begin
" visualmode(): vim inside function to get the last visual mode type: v, V, <C-v>
" the two map below are for nomal mode, visual mode
" how to use: <localleader>giw, viw<localleader>g ...
nnoremap <leader>g :set operatorfunc=<SID>GrepOperatorR<CR>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode(), 1)<CR>
nnoremap <leader>G :set operatorfunc=<SID>GrepOperatorNR<CR>g@
vnoremap <leader>G :<c-u>call <SID>GrepOperator(visualmode(), 0)<CR>
" better use than <leader>G
nnoremap <leader><leader>g :set operatorfunc=<SID>GrepOperatorNR<CR>g@
vnoremap <leader><leader>g :<c-u>call <SID>GrepOperator(visualmode(), 0)<CR>

function! s:GrepOperatorR(type)
    call s:GrepOperator(a:type, 1)
endfunction

function! s:GrepOperatorNR(type)
    call s:GrepOperator(a:type, 0)
endfunction

" s: use namespace s
function! s:GrepOperator(type, recursion)
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
    if(&l:filetype ==# 'cpp' || &l:filetype ==# 'c')
        if a:recursion
            silent execute "lgrep! -R " . shellescape(@@) . " --include=*.{c,cc,cpp,h} ."
        else
            silent execute "lgrep! " . shellescape(@@) . " %"
        endif
    else
        if a:recursion
            silent execute "lgrep! -R " . shellescape(@@) . " ."
        else
            silent execute "lgrep! " . shellescape(@@) . " %"
        endif
    endif
    " open the quickfix list window
    silent execute "normal! :lopen\<CR>"
    silent execute "normal! \<C-l>"
    let g:quickfix_l_is_open = 1

    " restore the unnamed register after use
    let @@ = saved_unnamed_register
endfunction

" }}}

" ==========convenient map for file finding========== {{{
nnoremap <leader>f :find ./**/
nnoremap <leader><leader>f :find ./**/<C-r><C-w>
" }}}

" ==========convenient map for translating========== {{{
nnoremap <leader>t :TranslateW <C-r><C-w>
nnoremap <leader><leader>t :TranslateW! 
vnoremap <leader>t :TranslateW
vnoremap <leader><leader>t :TranslateW!
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

" ==========toggle setting========== {{{
" toggle number
nnoremap <leader>N :setlocal number!<CR>

" toggle open/close quickfix window
" TODO bug: when use command 'lopen' g:quickfix_l_is_open cannot be updated
nnoremap <leader>w :call <SID>QuickfixToggle()<CR>
function! s:QuickfixToggle()
    if g:quickfix_l_is_open
        lclose
        let g:quickfix_l_is_open = 0
        " execute g:quickfix_return_to_window . "wincmd w"
    else
        " let g:quickfix_return_to_window = winnr()
        lopen
        let g:quickfix_l_is_open = 1
    endif
endfunction
" }}}

" ==========section movements========== {{{
" If your '{' or '}' are not in the first column, and you would like to use "[["
" and "]]" anyway, try these mappings: bug!
" map [[ ?{<CR>w99[{
" map ][ /}<CR>b99]}
" map ]] j0[[%/{<CR>
" map [] k$][%?}<CR>
" bug fix in my way
nmap [[ []%
nmap ]] %][%
" the same as below
" nmap <silent> ]] :<c-u>execute "normal! %"<CR>][:<c-u>silent execute "normal! %"<CR>
"
" 解释: 段路跳转[[、]]、[]、][，以c++为例进行讲解，符号{为函数的开始,符号}为函数的结束
" [[: 跳转到上一个函数的开始
" ]]: 跳转到下一个或当前函数的开始
" []: 跳转到上一个函数的结束
" ][: 跳转到下一个函数的结束
" 其中]]的行为是最特殊的，假设当前光标在函数体内部，]]反而会使光标向上移动到当前函数的开始{,
" 这与"下一个"的行为似乎有些矛盾，一方面是由于我们自己的实现造成的，但是只要把它理解为
" “跳转到下一个或当前函数的开始“就可以了，并且]]也是最常使用的，"跳转到下一个或当前函数的开始"
" 这一行为真的很棒，要想跳转到结束可以使用%

" }}}

"==========window setting========== {{{
" set window size to 0 but not close
nnoremap <leader>x :<c-u>vertical resize 0<CR>
nnoremap <leader><leader>x :<c-u>resize 0<CR>
" max window size
nnoremap <leader>o :<c-u>resize 1000<CR>:<c-u>vertical resize 1000<CR>:echo "max window size"<CR>
" add/reduce window size
nnoremap <S-Up> :<c-u>resize -1<CR>
nnoremap <S-Down> :<c-u>resize +1<CR>
nnoremap <S-Left> :<c-u>vertical resize -1<CR>
nnoremap <S-Right> :<c-u>vertical resize +1<CR>
" }}}

" ==========binary position========== {{{
" This is the most powerful cursor moving action created by wonderful!!!
" As its name shows the cursor moving acts in binary mode
" <C-j> <C-k> binary move the cursor in vertical direction
" <C-h> <C-k> binary move the cursor in horizontal direction
" The cursor will always be in middle when first moving
" If you miss the target call <leader>c to clear the position and try again
" The binary position is especially useful when edit with which is not English,
" beacuse it will be difficult to use f to find where you want to go
nnoremap <C-j> :<c-u>call <SID>BinaryPositionV("down")<CR>
nnoremap <C-k> :<c-u>call <SID>BinaryPositionV("up")<CR>
nnoremap <C-h> :<c-u>call <SID>BinaryPositionH("left")<CR>
nnoremap <C-l> :<c-u>call <SID>BinaryPositionH("right")<CR>
noremap <leader>c :<c-u>call <SID>BinaryClear()<CR>

function! s:ResetV()
    let g:v_beg = line('w0')
    let g:v_end = line('w$')
    let g:v_mid = g:v_beg + (g:v_end - g:v_beg) / 2
    let g:v_last_p = 0
endfunction

function! s:ResetH()
    let g:h_beg = 1
    let g:h_end = col('$')
    let g:h_mid = g:h_beg + (g:h_end - g:h_beg) / 2
    let g:h_last_p = 0
endfunction

function! s:BinaryClear()
    call <SID>ResetV()
    call <SID>ResetH()
    echom "Binary position has benn cleared!"
endfunction

function! s:BinaryPositionV(direction)
    let v_p = line('w0')
    if v_p != g:v_last_p
       call <SID>ResetV()
       call cursor(g:v_mid, 0)
       let g:v_last_p = v_p
       echom "call BinaryPositionV(\"" . a:direction . "\")" . " -> beg: " .  g:v_beg . " end: " . g:v_end . " mid: " . g:v_mid
       return
   endif

   if a:direction ==? 'down'
       let g:v_beg = g:v_mid
   elseif a:direction ==? 'up'
       let g:v_end = g:v_mid
   endif

   let g:v_mid = g:v_beg + (g:v_end - g:v_beg) / 2

   call cursor(g:v_mid, 0)

   echom "call BinaryPositionV(\"" . a:direction . "\")" . " -> beg: " .  g:v_beg . " end: " . g:v_end . " mid: " . g:v_mid
endfunction

function! s:BinaryPositionH(direction)
    let h_p = line('.')
    if h_p != g:h_last_p
        call <SID>ResetH()
        call cursor(0, g:h_mid)
        let g:h_last_p = h_p
        echom "call BinaryPositionH(\"" . a:direction . "\")" . " -> beg: " .  g:h_beg . " end: " . g:h_end . " mid: " . g:h_mid
        return
    endif

    if a:direction ==? 'left'
        let g:h_end = g:h_mid
    elseif a:direction ==? 'right'
        let g:h_beg = g:h_mid
    endif

    let g:h_mid = g:h_beg + (g:h_end - g:h_beg) / 2

    call cursor(0, g:h_mid)

    echom "call BinaryPositionH(\"" . a:direction . "\")" . " -> beg: " .  g:h_beg . " end: " . g:h_end . " mid: " . g:h_mid
endfunction
" }}}

" ==========tool functions========== {{{
" remove left zero: 050 -> 50
function! RemoveLeftZero(number)
    " echom 'input: ' . a:number
    let length = len(a:number)
    if length == 0
        return '0'
    endif
    let i = 0
    for n in a:number
        if n != '0'
            break
        endif
        let i += 1
    endfor
    if i == length
        return a:number
    else
        return a:number[i:length-1]
    endif
endfunction

" time to millisecond, input format: 23:03:55.998 or 03:55.998
function! TimeToMillisecond(time)
    " echom 'input: ' . a:time
    let length = len(a:time)
    if length == 0
        return 0
    endif
    let time_list = split(a:time, '\.')
    let front_time_list = split(time_list[0], ":")
    if len(front_time_list) == 2
        return RemoveLeftZero(front_time_list[0]) * 60 * 1000 + RemoveLeftZero(front_time_list[1]) * 1000 + RemoveLeftZero(time_list[1])
    elseif len(front_time_list) == 3
        return RemoveLeftZero(front_time_list[0]) * 60 * 60 * 1000 + RemoveLeftZero(front_time_list[1]) * 60 * 1000 + RemoveLeftZero(front_time_list[2]) * 1000 + RemoveLeftZero(time_list[1])
    else
        echo 'error time format!'
        return 0
    endif
endfunction
" }}}
