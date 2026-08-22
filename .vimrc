" echo "My best vim == >^.^< =="

" Quick Start
" -----------
" 1) clone vim-plug for vim plugin magager
" >>>>> curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" 2) add your vim settings here and copy it to
" >>>>> cp .vimrc ~/
"
" 3) open your vim and run command for plugin install
" >>>>> :PlugInstall



" ========加载默认设置========
source $VIMRUNTIME/defaults.vim

" ==========override defaults.vim========== {{{
set ttimeout		" time out for key codes
set ttimeoutlen=30	" wait up to ms after Esc for special key
set scrolloff=0     " 上下滚动时光标距离边界的偏移
" }}}



" ==========core settings========== {{{
" 启动时自动加载matchit插件，用于%配对标签间跳转, 如html标签，但是(),{}等是默认支持的
runtime macros/matchit.vim

set history=200         "设置命令回朔历史为200条，默认为50

set ignorecase          "开启大小写不敏感，作用于查找和补全
set smartcase           "开启智能大小写敏感，输入大写则匹配大写，否则使用ignorecase

set number              " 显示行号
set incsearch           " 查找是预览第一处匹配
set hlsearch            " 高亮查找匹配项

" tab settings
set tabstop=4           " tab/制表符 四个空格
set shiftwidth=4        " >> << 四个空格
set expandtab           " tab/制表符 展开为四个空格
set softtabstop=4       " 连续4个空格视为一个tab/制表符
" retab命令可以按照上面设置的规则格式化代码

" ==========file encode settings========== {{{
set fileformat=unix             "unix 文件格式，\n为行结束符，实际测试无效，创建文件时与系统一致!!! 可以打开文件后手动设置生效
set fileformats=unix,dos,mac    "设置vim支持的系统文件格式
set nobomb                      "utf-8标准格式，bomb微软用的多
set encoding=utf-8              "vim 内部使用的字符编码方式，包括缓冲区、菜单文本、消息文本等
set fileencoding=utf-8          "vim 当前编辑的文件字符编码方式，保存和新建都是这种编码格式
set fileencodings=utf-8,gbk,ucs-bom,default,latin1
" termencoding: vim工作终端的编码方式
" vim启动时按照列表进行探测，并将fileencoding设置为此编码方式，
" 这很好理解，即打开文件和保存文件默认情况下应该保持编码方式不变
" 可以理解为设置vim支持的文件编码格式，类似fileformats
" }}}

" tab 命令补全模式, 此模式tab会显示补全列表
set wildmenu
set wildmode=full

" 设置补全行为
" menuone: 只有一个选项也弹出
" noinsert: 不自动插入第一项
" noselect: 不自动选中第一项
" preview: 弹出预览窗口显示更多信息
set completeopt=menuone,noselect,noinsert,preview,popup
set completeopt-=noselect
set completeopt-=noinsert
set completeopt-=preview

" 插入模式和命令行模式禁用退格删除键，防止不良习惯
inoremap <backspace> <nop>
cnoremap <backspace> <nop>

" %% 映射为 %:h, 即当前活动缓冲区文件路径（去掉文件名）
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" &映射为&&, 即重复上次替换命令带flag
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" 重映射<C-d>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间,也可理解为向下翻动半页
nnoremap <C-d> Lzz
" 重映射<C-u>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间,也可理解为向上翻动半页
nnoremap <C-u> Hzz

" space进入可视模式并选中单词
nnoremap <space> viw

" visual search for */# settings
" 可视模式按*/#对选中文本进行查询
" 注意符号:, 这是一条命令行映射，而命令行或插入模式下<C-u>代表清除至行首
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" :nohlearch 命令暂时关闭高亮模式，直到执行新的或重复的查找命令
" <C-l>原是清屏重绘快捷键，将其和nohlearch一起作用
" nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
" 但是清屏会使屏幕闪烁一下，效果非常差，所以重映射<C-p>为暂时关闭高亮模式
" 并重映射<leader><C-l>为清屏，因为我们想将<C-l>用于其他功能
nnoremap <silent> <C-p> :<C-u>nohlsearch<CR>
nnoremap <silent> <leader><C-l> :<C-u>nohlsearch<CR><C-l>

" map Y to yank text from cursor to the end of line
nnoremap Y y$

" 定义快捷键前缀<Leader>, todo: 有冲突
" let mapleader=";"
" 设置快捷键将选中文本复制到系统剪切板
vnoremap <Leader>y "+y
nnoremap <Leader>y "+yiw
nnoremap <Leader>Y "+y$
nnoremap <Leader><Leader>y "+yy
" 设置快捷键将系统剪切板内容粘贴至vim
nnoremap <Leader>p "+p

" 让配置变更立即生效, 使用快捷键运行source感觉更好
" autocmd BufWritePost $MYVIMRC source $MYVIMRC
" 设置快捷键打开vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>:<c-u>resize 9999<CR>:<c-u>vertical resize 9999<CR>:echo "edit vimrc ..."<CR>
" 设置快捷键应用vimrc
nnoremap <Leader>sv :source $MYVIMRC<CR>:<C-u>nohlsearch<CR>:echo "run source vimrc ok!"<CR>

" colorscheme morning   " 设置配色方案

" ==========cursor shape and color settings========== {{{
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

"==========window settings========== {{{
" set window size to 0 but not close
nnoremap <leader>x :<c-u>vertical resize 0<CR>
nnoremap <leader><leader>x :<c-u>resize 0<CR>
" max window size
nnoremap <leader>o :<c-u>resize 9999<CR>:<c-u>vertical resize 9999<CR>:echo "max window size"<CR>
" add/reduce window size
nnoremap <S-Up> :<c-u>resize -1<CR>
nnoremap <S-Down> :<c-u>resize +1<CR>
nnoremap <S-Left> :<c-u>vertical resize -1<CR>
nnoremap <S-Right> :<c-u>vertical resize +1<CR>
" }}}

" ==========toggle case========== {{{
" 插入模式下转换光标前单词/字符串大小写
" inoremap <C-y> <esc>viw~gi
" inoremap <C-f> <esc>viW~gi
" 考虑命名空间god::VIM,
" 现在想在中间加一个命名空间变成god::EDITOR::VIM
" 于是编辑成这样god::editorVIM,
" 光标在editor的末尾，<C-y>将其转换为大写，可是VIM也被转换了
" 改进版本:
" inoremap <C-y> <esc>vgew~gi
" inoremap <C-f> <esc>vgEW~gi
" 但是这又引入了另一个bug, 当光标位于单词首字母时，只有光标下的字母会被转换
" 改进版本2:
" inoremap <C-y> <esc>vb~gi
" inoremap <C-f> <esc>vB~gi
" 这个版本也有问题，输入: abc y, <C-y>变成: ABC Y,
" 而且上两个版本在文本第一行首单词的转换也有问题
" 终极版本: (先插入一个零时字符*再删除）
" inoremap <C-y> *<esc>vb~f*s
" inoremap <C-f> *<esc>vB~gi<backspace>
" 上面的版本也有问题，那就是会打断.的记录，导致后续执行.命令不能获得完整表达
" 终终极版本: (1.先获取和转换单词 2.用<C-h>删除要转换的单词 " 3.重新插入转换的单词 全程没有离开插入模式，.能完美重放)
let g:toggle_case_word = ''
inoremap <C-y> <C-r>=<SID>ToggleCase("word")<CR><C-r>=<SID>DeleteToggleWord()<CR><C-r>=<SID>InsertToggleWord()<CR>
inoremap <C-f> <C-r>=<SID>ToggleCase("WORD")<CR><C-r>=<SID>DeleteToggleWord()<CR><C-r>=<SID>InsertToggleWord()<CR>
" }}}

" ==========binary cursor location========== {{{
" This is the most powerful cursor moving action created by wonderful!!!
" As its name shows the cursor moving acts in binary search mode
" <C-j> <C-k> binary move the cursor in vertical direction
" <C-h> <C-k> binary move the cursor in horizontal direction
" The cursor will always be in middle when first moving
" If you miss the target call <leader>c or just move with [h j k l] to clear the location and try again
" The binary location is especially useful when edit with which is not English,
" beacuse it will be difficult to use f to find where you want to go

let g:c_jkhl_binary_called = 0

let g:v_beg = 0
let g:v_mid = 0
let g:v_end = 0
let g:v_last_p = 0

let g:h_beg = 0
let g:h_mid = 0
let g:h_end = 0
let g:h_last_p = 0

" 映射成<Plug>方便别的地方用
nnoremap <Plug>(N_BinaryLocationDown)   :<c-u>call <SID>BinaryLocationV("down", "null")<CR>
nnoremap <Plug>(N_BinaryLocationUp)     :<c-u>call <SID>BinaryLocationV("up", "null")<CR>
nnoremap <Plug>(N_BinaryLocationLeft)   :<c-u>call <SID>BinaryLocationH("left", "null")<CR>
nnoremap <Plug>(N_BinaryLocationRight)  :<c-u>call <SID>BinaryLocationH("right", "null")<CR>
" -------------------------------------------------
vnoremap <Plug>(V_BinaryLocationDown)   :<c-u>call <SID>BinaryLocationV("down", "visual")<CR>
vnoremap <Plug>(V_BinaryLocationUp)     :<c-u>call <SID>BinaryLocationV("up", "visual")<CR>
vnoremap <Plug>(V_BinaryLocationLeft)   :<c-u>call <SID>BinaryLocationH("left", "visual")<CR>
vnoremap <Plug>(V_BinaryLocationRight)  :<c-u>call <SID>BinaryLocationH("right", "visual")<CR>
" ------------------------------------------
nmap <C-j> <Plug>(N_BinaryLocationDown)
nmap <C-k> <Plug>(N_BinaryLocationUp)
nmap <C-h> <Plug>(N_BinaryLocationLeft)
nmap <C-l> <Plug>(N_BinaryLocationRight)
" -------------------------------------------------
nnoremap v vmv
vmap <C-j> <Plug>(V_BinaryLocationDown)
vmap <C-k> <Plug>(V_BinaryLocationUp)
vmap <C-h> <Plug>(V_BinaryLocationLeft)
vmap <C-l> <Plug>(V_BinaryLocationRight)
" ------------------------------------------
nnoremap <silent> j j: <c-u>call <SID>BinaryClearFast()<CR>
nnoremap <silent> k k: <c-u>call <SID>BinaryClearFast()<CR>
nnoremap <silent> l l: <c-u>call <SID>BinaryClearFast()<CR>
nnoremap <silent> h h: <c-u>call <SID>BinaryClearFast()<CR>
noremap <leader>c :<c-u>call <SID>BinaryClear("false")<CR>
" }}}

" ================functions================ {{{
" ==========functions for visual search for */# settings========== {{{
function! s:VSetSearch(cmdtype) abort
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction
" }}}

" ==========functions for toggle case========== {{{
" 插入转换单词
function! s:InsertToggleWord() abort
     return g:toggle_case_word
endfunction

" 删除转换处单词
function! s:DeleteToggleWord() abort
     let len = strlen(g:toggle_case_word)
     return repeat("\<C-h>", len)
endfunction

" 光标前单词大小写转换
function! s:ToggleCase(mode) abort
    let g:toggle_case_word = ''

    let line = getline('.')
    let pos = col('.') - 1
    let start = pos

    " '\k': iskeyword
    " '\S': non-whitespace
    let key = a:mode ==# 'WORD' ? '\S' : '\k'
    while start > 0 && line[start-1] =~ key
        let start -= 1
    endwhile

    if start == pos
        return ""
    endif

    let word = line[start : pos-1]

    for char in split(word, '\zs')
        if char =~ '\u'
            let g:toggle_case_word .= tolower(char)
        else
            let g:toggle_case_word .= toupper(char)
        endif
    endfor

    return ""
endfunction
" }}}

" ==========functions for binary cursor location========== {{{
function! s:ResetV() abort
    let g:v_beg = line('w0')
    let g:v_end = line('w$') + 1
    let g:v_mid = g:v_beg + (g:v_end - g:v_beg) / 2
    let g:v_last_p = 0
endfunction

function! s:ResetH() abort
    let g:h_beg = 1
    let g:h_end = col('$')
    let g:h_mid = g:h_beg + (g:h_end - g:h_beg) / 2
    let g:h_last_p = 0
endfunction

function! s:BinaryClearFast() abort
    if g:c_jkhl_binary_called == 0
        return
    endif
    call <SID>ResetV()
    call <SID>ResetH()
    let g:c_jkhl_binary_called = 0
endfunction

function! s:BinaryClear(quiet) abort
    call <SID>ResetV()
    call <SID>ResetH()
    let g:c_jkhl_binary_called = 0
    if a:quiet !=? 'true'
        echom "Binary location has been cleared!"
    endif
endfunction

function! s:VisualMark()
    silent execute "normal! mw`vv`w"
endfunction

function! s:BinaryLocationV(direction, type) abort
    let g:c_jkhl_binary_called += 1

    let v_p = line('w0')
    if v_p != g:v_last_p
       call <SID>ResetV()
       call cursor(g:v_mid, 0)
       let g:v_last_p = v_p
       if a:type ==? 'visual'
           call <SID>VisualMark()
       endif
       echom "call BinaryLocationV(\"" . a:direction . "\")" . " -> beg: " .  g:v_beg . " end: " . g:v_end . " mid: " . g:v_mid
       return
   endif

   if a:direction ==? 'down'
       let g:v_beg = g:v_mid
   elseif a:direction ==? 'up'
       let g:v_end = g:v_mid
   endif

   let g:v_mid = g:v_beg + (g:v_end - g:v_beg) / 2

   call cursor(g:v_mid, 0)

   if a:type ==? 'visual'
       call <SID>VisualMark()
   endif

   echom "call BinaryLocationV(\"" . a:direction . "\")" . " -> beg: " .  g:v_beg . " end: " . g:v_end . " mid: " . g:v_mid
endfunction

function! s:BinaryLocationH(direction, type) abort
    let g:c_jkhl_binary_called += 1

    let h_p = line('.')
    if h_p != g:h_last_p
        call <SID>ResetH()
        call cursor(0, g:h_mid)
        let g:h_last_p = h_p
        if a:type ==? 'visual'
           call <SID>VisualMark()
        endif
        echom "call BinaryLocationH(\"" . a:direction . "\")" . " -> beg: " .  g:h_beg . " end: " . g:h_end . " mid: " . g:h_mid
        return
    endif

    if a:direction ==? 'left'
        let g:h_end = g:h_mid
    elseif a:direction ==? 'right'
        let g:h_beg = g:h_mid
    endif

    let g:h_mid = g:h_beg + (g:h_end - g:h_beg) / 2

    call cursor(0, g:h_mid)

    if a:type ==? 'visual'
       call <SID>VisualMark()
    endif

    echom "call BinaryLocationH(\"" . a:direction . "\")" . " -> beg: " .  g:h_beg . " end: " . g:h_end . " mid: " . g:h_mid
endfunction
" }}}
" }}}
" }}}

" ==========nocore settings========== {{{
" ==========FN========== {{{
" f7 执行!ctags -R
nnoremap <F7> :!ctags -R<CR>
" 每次保存文件时自动调用ctags -R, 这种方式不好，它会使得保存变慢，并且不需要tags的项目在保存时也会生成
" autocmd BufWritePost * call system("ctags -R")
" }}}

" ==========fold settings========== {{{
" no fold when open file
set foldlevelstart=99

" vim fold setting
augroup fold_filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" cpp fold setting
augroup fold_filetype_cpp
    autocmd!
    autocmd FileType c,cpp setlocal foldmethod=manual "手动折叠，性能最好
    " autocmd FileType c,cpp setlocal foldmethod=indent "缩进折叠
    " autocmd FileType c,cpp setlocal foldmethod=syntax "一些版本的vim可能造成无法忍受的卡顿!!!
augroup END

" toggle foldcolumn
nnoremap <leader>d :call <SID>FoldColumnToggle()<CR>
function! s:FoldColumnToggle() abort
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction
" }}}

" ==========statusline settings========== {{{
" set statusline
" set statusline=%f   "path to the file
" set statusline+=%=  "switch to the right side
" set statusline+=%l  "current line number
" set statusline+=/   "separator
" set statusline+=%L  "total line number
" set statusline+=%y  "file type
" }}}

" ==========abbreviations settings========== {{{
" 缩略句abbreviations类似map, 插入模式下输入@g<space>可以快速替换为对应邮箱
" 不用担心所有@g都被替换，因为有iskeyword保护
" iabbrev @g xxxxxx@gmail.com
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

" ==========toggle settings========== {{{
" toggle number
nnoremap <leader>N :setlocal number!<CR>

let g:quickfix_l_is_open = 0
" toggle open/close quickfix window
" TODO bug: when use command 'copen' g:quickfix_l_is_open cannot be updated
" learn what is wincmd w、winnr()
nnoremap <leader>w :call <SID>QuickfixToggle()<CR>
function! s:QuickfixToggle() abort
    if g:quickfix_l_is_open
        cclose
        let g:quickfix_l_is_open = 0
    else
        copen
        silent execute "normal! \<C-w>J"
        let g:quickfix_l_is_open = 1
    endif
endfunction
" }}}

" ==========hex show========== {{{
let g:hex_show = 0
nnoremap <silent> <F6> :call <SID>HexShowToggle()<CR>
function! s:HexShowToggle() abort
    let g:hex_show = !g:hex_show
    if g:hex_show
        silent execute "%!xxd"
        echo "hex show"
    else
        silent execute "%!xxd -r"
        echo "restore from hex"
    endif
endfunction
" }}}

" ==========convenient map for file finding========== {{{
nnoremap <leader>f :find ./**/
nnoremap <leader><leader>f :find ./**/<C-r><C-w>
" }}}

" ==========convenient map for grep searching========== {{{
" traverse quickfix window history
nnoremap <leader>q :colder<CR>
nnoremap <leader>Q :cnewer<CR>
" better use than <leader>Q
nnoremap <leader><leader>q :cnewer<CR>

" command completement of search
nnoremap <leader>sw /<C-r><C-w>
nnoremap <leader><leader>sw /\<<C-r><C-w>\><Left><Left>

" command completement of grep
nnoremap <leader>sa :vimgrep // ./**/*.cpp ./**/*.cc ./**/*.c ./**/*.h ./**/*.hpp<C-f>:call cursor(0,11)<CR>
nnoremap <leader>sc :vimgrep // ./**/*.cpp ./**/*.cc ./**/*.c<C-f>:call cursor(0,11)<CR>
nnoremap <leader>sh :vimgrep // ./**/*.h ./**/*.hpp<C-f>:call cursor(0,11)<CR>
nnoremap <leader>s% :vimgrep // %<C-f>:call cursor(0,11)<CR>
nnoremap <leader>ss :vimgrep // ./**/*<C-f>:call cursor(0,11)<CR>
nnoremap <leader><leader>sa :vimgrep /\<\>/ ./**/*.cpp ./**/*.cc ./**/*.c ./**/*.h ./**/*.hpp<C-f>:call cursor(0,13)<CR>
nnoremap <leader><leader>sc :vimgrep /\<\>/ ./**/*.cpp ./**/*.cc ./**/*.c<C-f>:call cursor(0,13)<CR>
nnoremap <leader><leader>sh :vimgrep /\<\>/ ./**/*.h ./**/*.hpp<C-f>:call cursor(0,13)<CR>
nnoremap <leader><leader>s% :vimgrep /\<\>/ %<C-f>:call cursor(0,13)<CR>
nnoremap <leader><leader>ss :vimgrep /\<\>/ ./**/*<C-f>:call cursor(0,13)<CR>

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
function! s:GrepOperator(type, recursion) abort
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
            silent execute "grep! -R " . shellescape(@@) . " --include=*.{c,cc,cpp,h,hpp} ."
        else
            silent execute "grep! " . shellescape(@@) . " %"
        endif
    else
        if a:recursion
            silent execute "grep! -R " . shellescape(@@) . " ."
        else
            silent execute "grep! " . shellescape(@@) . " %"
        endif
    endif
    " open the quickfix list window
    silent execute "copen"
    silent execute "normal! \<C-w>J"
    silent execute "normal! \<C-l>"
    let g:quickfix_l_is_open = 1

    " restore the unnamed register after use
    let @@ = saved_unnamed_register
endfunction
" }}}

" ==========register macro record========== {{{
" 非常有用的宏保存到寄存器中，在开发时方便使用，就像工具箱一样
" [经典寄存器内容追加]，用于统计查找模式后的数据，比如有如下log日志：
" xxx
" time diff: 123
" xxx
" time diff: -23
" xxx
" time diff: 37
" ...
" 首先执行查找模式： '/time diff: '
" 然后串行执行宏：100@u
" 数据将保存到寄存器z中: '123 -23 37 '
let @u = 'gnl"ZyW'
" [相邻数据差值计算]，与@u类似
" 首先执行查找模式： '/time diff: '
" 然后串行执行宏：100@v
" 数据将保存到寄存器z中: '-146 60 '
" let @v = 'gnl"jyiWgnl"kyiW:let t = @k - @j:let @z = @z . t . " "Nh'
let @v = 'gnl"jyEgnl"kyE:let @j = RemoveLeftZero(@j):let @k = RemoveLeftZero(@k):let t = @k - @j:let @z = @z . t . " "Nh'
" [相邻时间差值计算]，时间格式应该形如: xxx时:分:秒.毫秒 例: I:time [17:12:39.638 11-03-2022]
" 首先执行查找模式： 'I:time ['
" 然后串行执行宏：100@w
" 一毫秒为单位的时间差数据将保存到寄存器z中
" let @w = 'gnl"tyiw:let i = @t * 60 * 60 * 1000f:w"tyiw:let i += @t * 60 * 1000;w"tyiw:let i += @t * 1000f.w"tyiw:let i += @tgnl"tyiw:let j = @t * 60 * 60 * 1000f:w"tyiw:let j += @t * 60 * 1000;w"tyiw:let j += @t * 1000f.w"tyiw:let j += @t:let t = j - i:let @z = @z . t . " "Nh'
let @w = 'gnl"jyEgnl"kyE:let @j = TimeToMillisecond(@j):let @k = TimeToMillisecond(@k):let t = @k - @j:let @z = @z . t . " "Nh'
" [以空格作为间隔符拼接所有行]
" 即把所有行以空格为间隔拼接到一行，或者将所有行的换行符替换为空格
" 直接串行执行宏：100@x
let @x = '"Zy$:let @z = @z . " "j'
" [拷贝整行数据] 在查看日志时使用grep，有时会显示很长的文件名前缀,
" 使用整行数据拷贝可以避免这种麻烦
" 先执行查找模式：'/[message]:'
" 执行宏一次: @y
" 数据将保存到寄存器z中，在一个缓冲区粘贴出来':put z'
let @y = ':global//yank Z'
" [长行后半部分截取] 是上面@y的加强版, 在一行很长的文本中截取后半部分有用的内容,
" 这在日志分析中当前缀内容太长时非常有用
" 先执行查找模式：'/message: '
" 然后串行执行宏：100@y
" 数据将保存到寄存器z中，在一个缓冲区粘贴出来':put z'
let @o = 'gnmmo"ty$:let @t = @t . "\n":let @z = @z . @t`ml'
" 提示：运行宏之前应该先清空寄存器z -> qzq

" ==========tool functions========== {{{
" remove left zero: 050 -> 50
function! RemoveLeftZero(number) abort
    " echom 'input: ' . a:number
    let length = strlen(a:number)
    if length == 0
        return '0'
    endif
    let i = 0
    for n in split(a:number, '\zs')
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
function! TimeToMillisecond(time) abort
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
" }}}
" }}}



" ==========plugin settings========== {{{
" ==========vim plugin manager========== {{{
" any issues see github!!!
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'
Plug 'rhysd/vim-healthcheck'                      "plugin helth check
" ------------------------------------------------------------
Plug 'tpope/vim-surround'                         "可使块surroud, 如给word -> {word}
Plug 'tpope/vim-unimpaired'                       "缓冲区、参数、quickfix、位置、标签列表的遍历快捷键
Plug 'tpope/vim-commentary'                       "代码注释gc
" ------------------------------------------------------------
Plug 'octol/vim-cpp-enhanced-highlight'           "cpp语法高亮
Plug 'tikhomirov/vim-glsl'                        "opengl着色器语言语法高亮
Plug 'plasticboy/vim-markdown'                    "markdown语法高亮
Plug 'aklt/plantuml-syntax'                       "plantuml语法高亮
" ------------------------------------------------------------
Plug 'mhinz/vim-signify'                          "git工具
Plug 'voldikss/vim-translator'                    "vim翻译工具
" ------------------------------------------------------------
Plug 'prabirshrestha/vim-lsp'                     "LSP core
Plug 'mattn/vim-lsp-settings'                     "LSP语言服务配置
Plug 'prabirshrestha/asyncomplete.vim'            "lsp自动补全
Plug 'prabirshrestha/asyncomplete-lsp.vim'        "lsp自动补全
" ------------------------------------------------------------
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
" ------------------------------------------------------------
" Plug 'weirongxu/plantuml-previewer.vim'           "plantuml预览, need sudo apt-get install graphviz
" Plug 'tyru/open-browser.vim'                      "浏览器预览渲染图, plantuml用
call plug#end()            " required
" }}}


" 插件特性设置: >>>

" ==========vim-cpp-enhanced-highlight settings========== {{{
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 0    " 性能太差
let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 0                     " Disable highlighting of user defined functions
" }}}

" ==========vim-signify settings========== {{{
" 默认禁用, 使用:SignifyEnable手动开启
let g:signify_disable_by_default = 1
" }}}

" ==========vim-translator settings========== {{{
" translator variable
" let g:translator_proxy_url = 'socks5://127.0.0.1:1080'
let g:translator_default_engines = ['bing', 'haici']
" convenient map for translating
nnoremap <leader>t :Translate <C-r><C-w>
nnoremap <leader><leader>t :Translate! 
vnoremap <leader>t :Translate
vnoremap <leader><leader>t :Translate!
" nnoremap <leader>t :TranslateW <C-r><C-w>
" nnoremap <leader><leader>t :TranslateW! 
" vnoremap <leader>t :TranslateW
" vnoremap <leader><leader>t :TranslateW!
" }}}

" ==========vim-lsp settings========== {{{
" 我们使用vim-lsp-settings插件来配置服务, 下面是手动配置示例
" if executable('pylsp')
"     " pip install python-lsp-server
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'pylsp',
"         \ 'cmd': {server_info->['pylsp']},
"         \ 'allowlist': ['python'],
"         \ })
" endif

" set updatetime=300

" 启用原生LSP
let g:lsp_use_native_client = 1

" 启动时禁用lsp
let g:lsp_auto_enable = 0

" 手动开关lsp
let g:_lsp_saved_signcolumn = &signcolumn
command! LspEnable  let g:_lsp_saved_signcolumn = &signcolumn | call lsp#enable()  | set signcolumn=yes
command! LspDisable call lsp#disable() | let &signcolumn = get(g:, '_lsp_saved_signcolumn', 'auto')

" 设置快捷键
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    " setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gD <plug>(lsp-definition)
    nmap <buffer> gY <plug>(lsp-type-definition)
    nmap <buffer> gR <plug>(lsp-references)
    nmap <buffer> gI <plug>(lsp-implementation)
    nmap <buffer> gH <plug>(lsp-type-hierarchy)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    " ----------------------------------------------
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover-float)
    nmap <buffer> gK <plug>(lsp-hover-preview)
    " ----------------------------------------------
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <leader>a <plug>(lsp-code-action-float)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" 语义高亮, 速度有些慢
let g:lsp_semantic_enabled = 0
let g:lsp_semantic_delay = 500

" 禁止光标停留自动高亮
let g:lsp_document_highlight_enabled = 0

" 禁止补全弹窗自动弹出
let g:asyncomplete_auto_popup = 0

" 禁止函数签名提示自动弹出在输入模式下
let g:lsp_signature_help_enabled = 0

" allow modifying the completeopt variable, or it will
" be overridden all the time
" 不自动设置补全行为
let g:asyncomplete_auto_completeopt = 0

" 补全额外信息显示
let g:lsp_completion_documentation_enabled = 1

" 手动弹出，用<C-i>就可以了
" imap <c-space> <Plug>(asyncomplete_force_refresh)
" For Vim 8 (<c-@> corresponds to <c-space>):
" imap <c-@> <Plug>(asyncomplete_force_refresh)

" 补全弹窗列表选择
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" 诊断信息
let g:lsp_diagnostics_enabled = 1                           " 启用诊断信息
let g:lsp_diagnostics_echo_cursor = 1                       " 命令行中输出错误信息
let g:lsp_diagnostics_echo_delay  = 0                       " 延迟显示
let g:lsp_diagnostics_float_cursor = 0                      " 悬浮窗口显示诊断信息
let g:lsp_diagnostics_float_delay = 500                     " 延迟显示
let g:lsp_diagnostics_float_insert_mode_enabled = 0         " 插入模式关闭悬浮
let g:lsp_diagnostics_highlights_enabled = 1                " 错误诊断高亮
let g:lsp_diagnostics_highlights_delay = 500                " 延迟高亮
let g:lsp_diagnostics_highlights_insert_mode_enabled = 1    " 插入模式高亮
let g:lsp_diagnostics_signs_enabled = 1                     " 启用侧边栏符号
let g:lsp_diagnostics_signs_insert_mode_enabled = 1         " 插入模式侧边符号显示
let g:lsp_diagnostics_signs_delay = 500                     " 延迟符号显示
" 设置符号样式
" let g:lsp_diagnostics_signs_error = {'text': '✗', 'texthl': 'DiagnosticSignError'}
" let g:lsp_diagnostics_signs_warning = {'text': '⚠', 'texthl': 'DiagnosticSignWarn'}
" 关闭错误诊断虚拟文本
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0

" 使用<C-j>/<C-k>上下滚动popup window
let g:CJ_cmd_nmap = maparg('<C-j>', 'n')
let g:CK_cmd_nmap = maparg('<C-k>', 'n')
if exists('*popup_list') && g:CJ_cmd_nmap =~# '^<Plug>' && g:CK_cmd_nmap =~# '^<Plug>'
    " 如果 maparg 返回的是 <Plug>(...)，把它变成可执行的特殊键形式："\<Plug>(...)"
    let g:CJ_cmd_nmap = "\<Plug>" . g:CJ_cmd_nmap[6:]
    let g:CK_cmd_nmap = "\<Plug>" . g:CK_cmd_nmap[6:]
    nnoremap <silent><expr> <C-j>
        \ empty(popup_list())
        \ ? g:CJ_cmd_nmap
        \ : lsp#scroll(+4)
    nnoremap <silent><expr> <C-k>
        \ empty(popup_list())
        \ ? g:CK_cmd_nmap
        \ : lsp#scroll(-4)
endif

" lsp log
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/logs/vim-lsp.log')
" let g:asyncomplete_log_file = expand('~/logs/asyncomplete.log')
" }}}
" }}}
