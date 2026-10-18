" vim9script

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
set fileformat=unix             "当前缓冲区用哪种换行符，写入时一致
set fileformats=unix,dos,mac    "读文件时“尝试识别”的行尾格式列表（探测顺序），并据此设置fileformat
set nobomb                      "utf-8标准格式，bomb微软用的多
set encoding=utf-8              "vim 内部使用的字符编码方式，包括缓冲区、菜单文本、消息文本等
set fileencoding=utf-8          "vim 当前编辑的文件字符编码方式，保存和新建都是这种编码格式
set fileencodings=ucs-bom,utf-8,gb18030,gbk,default,latin1
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

" " 重映射<C-d>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间,也可理解为向下翻动半页
" nnoremap <C-d> Lzz
" " 重映射<C-u>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间,也可理解为向上翻动半页
" nnoremap <C-u> Hzz
" 重映射<C-l>插入模式下光标右移一位
inoremap <C-l> <Right>

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
nnoremap <Leader>Y "+y$
nnoremap <Leader>yy "+yy
nnoremap <Leader><Leader>y "+yy
nnoremap <silent> <leader>y :set operatorfunc=<SID>Yank2Clipboard<CR>g@
" " 设置快捷键将系统剪切板内容粘贴至vim
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

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

"==========window settings========== {{{
" set window size to 0 but not close
nnoremap <leader>x :<c-u>vertical resize 0<CR>
nnoremap <leader><leader>x :<c-u>resize 0<CR>
" max window size
nnoremap <leader>o :<c-u>resize 9999<CR>:<c-u>vertical resize 9999<CR>:echo "max window size"<CR>
" increase/decrease window size
nnoremap <S-Up> :<c-u>resize +1<CR>
nnoremap <S-Down> :<c-u>resize -1<CR>
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
nmap <silent> <C-j> <Plug>(N_BinaryLocationDown)
nmap <silent> <C-k> <Plug>(N_BinaryLocationUp)
nmap <silent> <C-h> <Plug>(N_BinaryLocationLeft)
nmap <silent> <C-l> <Plug>(N_BinaryLocationRight)
" -------------------------------------------------
nnoremap v vmv
vmap <silent> <C-j> <Plug>(V_BinaryLocationDown)
vmap <silent> <C-k> <Plug>(V_BinaryLocationUp)
vmap <silent> <C-h> <Plug>(V_BinaryLocationLeft)
vmap <silent> <C-l> <Plug>(V_BinaryLocationRight)
" ------------------------------------------
" nnoremap <silent> j j:<c-u>call <SID>BinaryClearFast()<CR>
" nnoremap <silent> k k:<c-u>call <SID>BinaryClearFast()<CR>
" nnoremap <silent> l l:<c-u>call <SID>BinaryClearFast()<CR>
" nnoremap <silent> h h:<c-u>call <SID>BinaryClearFast()<CR>
" 上面的方法在<C-o>的情况下会触发bug!!!
" nnoremap <silent> j <Cmd>call <SID>KEY_J()<CR>
" nnoremap <silent> k <Cmd>call <SID>KEY_K()<CR>
" nnoremap <silent> l <Cmd>call <SID>KEY_L()<CR>
" nnoremap <silent> h <Cmd>call <SID>KEY_H()<CR>
" <Cmd>需要vim9支持
nnoremap <silent> j :<c-u>call <SID>KEY_J(v:count1)<CR>
nnoremap <silent> k :<c-u>call <SID>KEY_K(v:count1)<CR>
nnoremap <silent> l :<c-u>call <SID>KEY_L(v:count1)<CR>
nnoremap <silent> h :<c-u>call <SID>KEY_H(v:count1)<CR>
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

" ==========functions for clipboard yank========== {{{
function! s:Yank2Clipboard(type) abort
    " yank selected text
    if a:type ==# 'v'
        normal! `<v`>"+y
    elseif a:type ==# 'char'
        normal! `[v`]"+y
    elseif a:type ==# 'line'
        normal! `[V`]"+y
    else
        return
    endif
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
function! s:KEY_J(count) abort
    " 执行原义j, 带数量功能
    execute 'normal! ' . a:count . 'j'
    " 清理标记
    call s:BinaryClearFast()
endfunction

function! s:KEY_K(count) abort
    execute 'normal! ' . a:count . 'k'
    call s:BinaryClearFast()
endfunction

function! s:KEY_L(count) abort
    execute 'normal! ' . a:count . 'l'
    call s:BinaryClearFast()
endfunction

function! s:KEY_H(count) abort
    execute 'normal! ' . a:count . 'h'
    call s:BinaryClearFast()
endfunction

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
        echo "Binary location has been cleared!"
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
       " echo "call BinaryLocationV(\"" . a:direction . "\")" . " -> beg: " .  g:v_beg . " end: " . g:v_end . " mid: " . g:v_mid
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

   " echo "call BinaryLocationV(\"" . a:direction . "\")" . " -> beg: " .  g:v_beg . " end: " . g:v_end . " mid: " . g:v_mid
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
        " echo "call BinaryLocationH(\"" . a:direction . "\")" . " -> beg: " .  g:h_beg . " end: " . g:h_end . " mid: " . g:h_mid
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

    " echo "call BinaryLocationH(\"" . a:direction . "\")" . " -> beg: " .  g:h_beg . " end: " . g:h_end . " mid: " . g:h_mid
endfunction
" }}}
" }}}
" }}}

" ==========nocore settings========== {{{
" ==========ctags========== {{{
let s:async_tick_ctr = {
    \ 'index': 0,
    \ 'static_count': 0,
    \ 'max_loop_times': 12,
    \ 'curr_loop_times': 0,
    \ 'loop_id': 0,
    \ 'min_id': 0,
    \ 'max_id': 0,
    \ 'timeout': 0,
    \ 'start_time': '',
    \}

let s:async_job_id = -1
let s:async_jobs = {}

" " 子任务
" let s:subjob = {
"     \ 'org': '',    "原始async命令
"     \ 'cmd': '',    "真正的program命令
"     \ 'len': '',    "cmd的长度
"     \ 'fmt': '',    "输出格式
"     \ 'fil': '',    "填充类型，none/all/out/err
"     \ 'o': v:false, "命令结束后是否打开quickfix
"     \ 'ts': '',     "命令执行起始时间
"     \ 'te': '',     "命令执行结束时间
"     \ 'sts': '',    "状态信息
" }

" " 每个AsyncJob包含一个subjobs列表，里面包含具体的命令参数，
" " subjob_id是当前job对象正在执行的子任务索引，当一个子任务执行结束后，
" " 如果subjobs里还有未执行的子任务，会重新创建一个job对象，同时subjob_id++
" " 注意id不会变，id是和AsyncJob绑定的，即一个AsyncJob + id + subjobs
" " 这样做是因为，有的工作可能需要多条命令才能完成，且这些命令有先后顺序
" let s:async_jobs[key] = {
"     \ 'id': -1,             "job id, 每个AsyncJob对应一个id，从0开始增长
"     \ 'job': v:null,        "job对象, 真正执行外部命令的对象
"     \ 'timer': v:null,      "计时器, 用于更新进度等信息
"     \ 'state': 'uninit',    "状态, 分为uninit/running/stopping/done/xdone, 用于时序控制
"     \ 'outs': [],           "标准输出
"     \ 'errs': [],           "错误输出
"     \ 'prog_idx': 0,        "进度索引
"     \ 'subjobs': [],        "子任务列表
"     \ 'subjob_id': 0        "当前子任务索引
" \ }

command! -nargs=+ Async call s:Async(<q-args>)
command! -nargs=* GenTags call s:GenTagsAsync(<q-args>)
command! -nargs=* GenCscope call s:GenCscopeAsync(<q-args>)
command! -nargs=1 AsyncSleep call s:AsyncSleep(<q-args>)
command! -nargs=* AsyncTest call s:AsyncTest(<q-args>)
command! -nargs=* AsyncQuery call s:AsyncQuery(<q-args>)
command! -nargs=+ -complete=customlist,s:AsyncStopComplete AsyncStop call s:AsyncStop(<q-args>)

function! s:Async(args) abort
    let l:cmd = a:args
    let l:subjobs = s:ParseAsyncArgs(a:args)
    let l:shell_cmd = [&shell, &shellcmdflag, l:subjobs[0].cmd]

    echom 'Async ' . l:cmd
    redraw
    if len(l:subjobs) == 0
        echom 'Async no subjobs to run!'
        return
    endif

    " " test
    " echom 'Async cmd: ' . l:cmd
    " echom 'Async subjobs: '
    " echom l:subjobs
    " echom 'Async subjobs[0].shell_cmd: ' . string(l:shell_cmd)
    " return

    if has_key(s:async_jobs, l:cmd)
        echom 'job for [' . s:async_jobs[l:cmd].job . "] 已存在!"
        return
    endif

    " 建字典
    let l:job_id = s:GenJobID()
    let s:async_jobs[l:cmd] = {
        \ 'id': job_id,
        \ 'job': v:null,
        \ 'timer': v:null,
        \ 'state': 'uninit',
        \ 'outs': [],
        \ 'errs': [],
        \ 'prog_idx': 0,
        \ 'subjobs': l:subjobs,
        \ 'subjob_id': 0
    \ }

    echo "Async-" . s:GetCurrSubjobProgram(l:cmd) . " running ... |"

    " 先把timer启动起来，防止job结束过快timer还没创建
    " 每 200 毫秒更新一次状态
    call s:StartAsyncTimer(l:cmd, 200)

    " 启动异步任务
    call s:StartAsyncSubjob(l:cmd)
endfunction

function! s:GenJobID() abort
    let s:async_job_id += 1
    return s:async_job_id
endfunction

function! s:GetSubjobs(key) abort
    return s:async_jobs[a:key].subjobs
endfunction

function! s:GetCurrSubjob(key) abort
    let l:id = s:async_jobs[a:key].subjob_id
    return s:async_jobs[a:key].subjobs[id]
endfunction

function! s:GetCurrSubjobCmd(key) abort
    return s:GetCurrSubjob(a:key).cmd
endfunction

function! s:GetCurrSubjobProgram(key) abort
    return split(s:GetCurrSubjobCmd(a:key))[0]
endfunction

function! s:IsLastSubJob(key) abort
    let l:subjob_size = len(s:GetSubjobs(a:key))
    return s:async_jobs[a:key].subjob_id == l:subjob_size - 1
endfunction

function! s:AsyncQuery(args) abort
    if index(split(a:args), '--table') >= 0
        call s:OpenCustomTimerWindow('Async jobs', 's:ScheduleAsyncQuery', 200)
    else
        " simple模式
        let l:msg = ''
        for [l:key, l:data] in items(s:async_jobs)
            let l:msg = l:msg . l:data.id . '-' . s:GetCurrSubjobProgram(l:key) . ' '
        endfor
        if !empty(l:msg)
            call s:PauseAsyncTick(5000)
            echom 'Async jobs [id-name]: ' . l:msg
        else
            echom 'No async job running!'
        endif
    endif
endfunction

function! s:OnJobOut(key, ch, msg) abort
    call add(s:async_jobs[a:key].outs, a:msg)
endfunction

function! s:OnJobErr(key, ch, msg) abort
    call add(s:async_jobs[a:key].errs, a:msg)

    " 如果err不会填充到quickfix，就打印它
    let l:fil = s:GetCurrSubjob(a:key).fil
    if l:fil !=# 'err' && l:fil !=# 'all'
        echom "Error: " . a:msg
    endif
endfunction

function! s:OnJobExit(key, job, code) abort
    if !has_key(s:async_jobs, a:key)
        echom 'job for [' . a:key .'] not exist!'
        return
    endif

    let l:curr_subjob = s:GetCurrSubjob(a:key)

    let s:async_jobs[a:key].job = a:job
    if s:async_jobs[a:key].state ==# 'uinit'
        let s:async_jobs[a:key].state = 'running'
        let l:curr_subjob.sts = 'running'
    endif

    try
        " 如果是最后一个subjob或发送了stopping信号才停止timer
        if s:IsLastSubJob(a:key) || s:async_jobs[a:key].state ==# 'stopping'
            let l:timer = get(s:async_jobs[a:key], 'timer', v:null)
            call s:StopTimer(l:timer, 'term')
            let s:async_jobs[a:key].timer = v:null
        endif

        " 执行后期处理任务
        call s:AsyncJobDone(a:key, a:code)
    finally

        " 更新状态
        let l:finish_type = s:async_jobs[a:key].state ==# 'stopping' ? 'xdone' : 'done'
        let s:async_jobs[a:key].state = l:finish_type
        let l:curr_subjob.sts = l:finish_type
        let l:time = printf('%.1f', reltimefloat(reltime(l:curr_subjob.ts)))
        let l:curr_subjob.te = l:time

        if s:IsLastSubJob(a:key) || s:async_jobs[a:key].state ==# 'stopping'
            " 如果是最后一个subjob或发送了停止命令清理整个AsyncJob
            call remove(s:async_jobs, a:key)
        else
            " 如果不是最后一个subjob，启动一个新的job执行后续任务
            " 先reset
            let s:async_jobs[a:key].state = 'uninit'
            let s:async_jobs[a:key].outs = []
            let s:async_jobs[a:key].errs = []
            let s:async_jobs[a:key].prog_idx = 0
            let s:async_jobs[a:key].subjob_id += 1

            echo "Async-" . s:GetCurrSubjobProgram(a:key) . " running ... |"
            call s:StartAsyncSubjob(a:key)
        endif
    endtry
endfunction

" 启动一个timer
function! s:StartAsyncTimer(key, tms) abort
    let l:timer = timer_start(
        \ a:tms,
        \ function('s:AsyncTick', [a:key]),
        \ {'repeat': -1}
        \ )

    let s:async_jobs[a:key].timer = l:timer
endfunction

" 启动一个子任务
function! s:StartAsyncSubjob(key) abort
    let l:curr_subjob = s:GetCurrSubjob(a:key)
    let l:shell_cmd = [&shell, &shellcmdflag, l:curr_subjob.cmd]

    let l:curr_subjob.ts = reltime()

    " 异步任务
    " out_mode/err_mode: nl: 按换行符切分输出，否则可能是半行
    " out_cb : 标准输出回调
    " err_cb : 标准错误回调
    " exit_cb: 进程退出回调
    let l:job = job_start(l:shell_cmd, {
            \ 'out_mode': 'nl',
            \ 'err_mode': 'nl',
            \ 'out_cb': {ch, msg -> s:OnJobOut(a:key, ch, msg)},
            \ 'err_cb': {ch, msg -> s:OnJobErr(a:key, ch, msg)},
            \ 'exit_cb': {job, code -> s:OnJobExit(a:key, job, code)}
            \ })

    " 把 job 对象填进字典
    " 由于OnJobExit可以在job返回前结束，所以使用一个状态来控制
    " OnJobExit是在vim进行执行的，所以和下面的逻辑是同步的
    if s:async_jobs[a:key].state != 'done' && s:async_jobs[a:key].state != 'xdone'
        let s:async_jobs[a:key].job = l:job
        let s:async_jobs[a:key].state = 'running'
        let l:curr_subjob.sts = 'running'
    endif

    call s:UpdateTickCtr()
endfunction

function! s:EchoMsg(lines) abort
    for l:line in a:lines
        echom l:line
    endfor
endfunction

function! s:AsyncDataProcess(key, code) abort
    let l:subjob = s:GetCurrSubjob(a:key)
    if l:subjob.fil ==? 'none'
        return
    endif

    let l:format = &errorformat
    " 如果指定了具体格式, 过滤空项
    if !empty(l:subjob.fmt)
        let l:errs = filter(s:async_jobs[a:key].errs, '!empty(v:val)')
        let l:outs = filter(s:async_jobs[a:key].outs, '!empty(v:val)')
        let l:format = l:subjob.fmt
    else
        let l:errs = s:async_jobs[a:key].errs
        let l:outs = s:async_jobs[a:key].outs
    endif

    let l:filled = v:false
    if l:subjob.fil ==? 'err' && !empty(l:errs)
        call setqflist([], ' ', {
                    \ 'title': l:subjob.cmd,
                    \ 'lines': l:errs,
                    \ 'efm': l:format
                    \ })
        let l:filled = v:true
    elseif l:subjob.fil ==? 'out' && !empty(l:outs)
        call setqflist([], ' ', {
                    \ 'title': l:subjob.cmd,
                    \ 'lines': l:outs,
                    \ 'efm': l:format
                    \ })
        let l:filled = v:true
    elseif l:subjob.fil ==? 'all' && (!empty(l:errs) || !empty(l:outs))
        call setqflist([], ' ', {
                    \ 'title': l:subjob.cmd,
                    \ 'lines': l:errs,
                    \ 'efm': l:format
                    \ })
        call setqflist([], 'a', {
                    \ 'lines': l:outs,
                    \ 'efm': l:format
                    \ })
        let l:filled = v:true
    elseif l:subjob.fil ==? 'asp'
        if !empty(l:outs)
            call setqflist([], ' ', {
                        \ 'title': l:subjob.cmd,
                        \ 'lines': l:outs,
                        \ 'efm': l:format
                        \ })
            let l:filled = v:true
        endif
        if !empty(l:errs)
            call setqflist([], ' ', {
                        \ 'title': l:subjob.cmd,
                        \ 'lines': l:errs,
                        \ 'efm': l:format
                        \ })
            let l:filled = v:true
        endif
    endif

    " 打开窗口
    if l:subjob.o && l:filled
        botright copen
    endif

    return {'n_outs': len(l:outs), 'n_errs': len(l:errs)}
endfunction

function! s:AsyncJobDone(key, code) abort
    echom "Async-" . s:GetCurrSubjobProgram(a:key) . " finish(" . a:code . "). Processing data ..."

    " call s:EchoMsg(s:async_jobs[a:key].outs)
    " call s:EchoMsg(s:async_jobs[a:key].errs)

    let l:num = s:AsyncDataProcess(a:key, a:code)
    let l:finish_type = s:async_jobs[a:key].state ==# 'stopping' ? ' xdone | ' : ' done | '
    let l:subjob = s:GetCurrSubjob(a:key)
    let l:time = printf('%.1f', reltimefloat(reltime(l:subjob.ts)))

    echom "Async-" . s:GetCurrSubjobProgram(a:key) . l:finish_type . l:num.n_outs . " outs + " . l:num.n_errs . ' errs | ' . l:time . 's'
endfunction

function! s:UpdateTickCtr() abort
    " 更新最大最小值
    let l:ids = map(values(s:async_jobs), 'v:val.id')
    let s:async_tick_ctr.min_id = min(l:ids)
    let s:async_tick_ctr.max_id = max(l:ids)
    " 限制范围
    if s:async_tick_ctr.loop_id < min(l:ids)
        let s:async_tick_ctr.loop_id = min(l:ids)
    endif
    if s:async_tick_ctr.loop_id > max(l:ids)
        let s:async_tick_ctr.loop_id = max(l:ids)
    endif
endfunction

function! s:PauseAsyncTick(timems)
    let s:async_tick_ctr.timeout = a:timems
    let s:async_tick_ctr.start_time = reltime()
endfunction

function! s:AsyncTick(key, timer) abort
    " stop and remove后可能仍然收到回调
    if !has_key(s:async_jobs, a:key)
        return
    endif

    " 检查 Vim 是否处于 more-prompt 或 hit-enter prompt 状态
    if state('s') != ''
        return
    endif

    " 暂停控制
    if s:async_tick_ctr.timeout > 0
        let l:time_ms = float2nr(reltimefloat(reltime(s:async_tick_ctr.start_time)) * 1000)
        if l:time_ms < s:async_tick_ctr.timeout
            return
        else
            let s:async_tick_ctr.timeout = 0
        endif
    endif

    " ================================================================== 
    " 每个job都有一个timer，如果不加控制地更新状态
    " 不同job的信息会在命令快速交替显示，效果很差
    " 引入轮询循环控制，每个job完成一个循环显示后才切换到下一个job的显示
    " s:async_tick_ctr做的就是这件事
    " ------------------------------------------------------------------
    " echom "min_id: " . s:async_tick_ctr.min_id
    "             \ . " max_id: " . s:async_tick_ctr.max_id
    "             \ . " loop_id:" . s:async_tick_ctr.loop_id
    "             \ . " max_loop_times:" . s:async_tick_ctr.max_loop_times
    "             \ . " curr_loop_times:" . s:async_tick_ctr.curr_loop_times
    "             \ . " static_count:" . s:async_tick_ctr.static_count

    " 如果不是当前循环id
    if s:async_tick_ctr.loop_id != s:async_jobs[a:key].id
        let s:async_tick_ctr.static_count += 1
        if s:async_tick_ctr.static_count > len(s:async_jobs)
            " 如何很久没有变化了，更新一下防止其中一个退出导致无法驱动loop
            call s:UpdateTickCtr()
        endif
        return
    endif

    " 驱动一次更新
    let s:async_tick_ctr.static_count = 0
    call s:UpdateTickCtr()

    " 当前id循环结束，切换到下一个循环id
    let s:async_tick_ctr.curr_loop_times += 1
    if s:async_tick_ctr.curr_loop_times == s:async_tick_ctr.max_loop_times - 1
        let s:async_tick_ctr.curr_loop_times = 0
        let s:async_tick_ctr.loop_id += 1
        if s:async_tick_ctr.loop_id > s:async_tick_ctr.max_id
            let s:async_tick_ctr.loop_id = s:async_tick_ctr.min_id
        endif
    endif
    " ================================================================== 

    " 执行一次状态更新
    let chars = ['|', '/', '-', '\']

    " let s:async_jobs[a:key].prog_idx = (s:async_jobs[a:key].prog_idx + 1) % len(chars)
    " " 在timer的回调中，echo后面不要有任何代码，否则光标会闪烁!!!
    " echo 'Async-' . s:GetCurrSubjobProgram(a:key) . ' running ... ' . chars[s:async_jobs[a:key].prog_idx]

    let s:async_tick_ctr.index = (s:async_tick_ctr.index + 1) % len(chars)
    " 在timer的回调中，echo后面不要有任何代码，否则光标会闪烁!!!
    echo 'Async-' . s:GetCurrSubjobProgram(a:key) . ' running ... ' . chars[s:async_tick_ctr.index]
endfunction

function! s:StopTimer(timer, stop_way) abort
    " 1. 检查 timer 是否存在且有效
    if a:timer is v:null
        return
    endif

    " 2. 检查 timer 是否还在运行, 停止它
    try
        call timer_stop(a:timer)
    catch
        echohl ErrorMsg
        echomsg v:exception
        echohl None
    endtry
endfunction

function! s:StopJob(job, stop_way) abort
    " 1. 检查 job 是否存在且有效
    if a:job is v:null
        return
    endif

    " 2. 检查 job 是否还在运行, 停止它
    try
        if job_status(a:job) ==# 'run'
            call job_stop(a:job, a:stop_way)
        endif
    catch
        echohl ErrorMsg
        echomsg v:exception
        echohl None
    endtry
endfunction

function! s:StopAsyncJob(async_job, stop_way) abort
    if empty(a:async_job)
        return
    endif

    let a:async_job.state = 'stopping'

    " 停止timer
    let l:timer = get(a:async_job, 'timer', v:null)
    call s:StopTimer(l:timer, a:stop_way)
    let a:async_job.timer = v:null

    " 停止job
    let l:job = get(a:async_job, 'job', v:null)
    call s:StopJob(l:job, a:stop_way)
    let a:async_job.job = v:null

    " 清理字典条目, 不需要在这里清理，exit callback通常会执行，哪怕是kill
    " call remove(s:async_jobs, a:key)
endfunction

function! s:FindAsyncJobById(id)
    for [l:key, l:data] in items(s:async_jobs)
        if l:data.id ==# a:id
            return l:data
        endif
    endfor
    return {}
endfunction

function! s:StopAsyncJobAll(stop_way) abort
    for [l:key, l:data] in items(s:async_jobs)
        call s:StopAsyncJob(l:data, a:stop_way)
    endfor
endfunction

function! s:StopAsyncJobWithId(id, stop_way) abort
    let l:async_job = s:FindAsyncJobById(a:id)
    call s:StopAsyncJob(l:async_job, a:stop_way)
endfunction

function! s:StopAsyncJobWithKey(key, stop_way) abort
    if !has_key(s:async_jobs, a:key)
        return
    endif
    call s:StopAsyncJob(s:async_jobs[a:key], a:stop_way)
endfunction

function! s:StopAsyncJobWithName(name, stop_way) abort
    for [l:key, l:data] in items(s:async_jobs)
        let l:program = s:GetCurrSubjobProgram(l:key)
        if l:program ==# a:name
            call s:StopAsyncJob(l:data, a:stop_way)
        endif
    endfor
endfunction

function! s:AsyncStop(args) abort
    let l:id = matchstr(a:args, '\%(^\|\s\)--id=\zs\S\+')
    let l:key = matchstr(a:args, '\%(^\|\s\)--key=\zs\S\+')
    let l:name = matchstr(a:args, '\%(^\|\s\)--name=\zs\S\+')
    let l:stop_way = matchstr(a:args, '\%(^\|\s\)--stop-way=\zs\S\+')
    if empty(l:stop_way)
        let l:stop_way = 'term'
    endif

    if !empty(l:id)
        call s:StopAsyncJobWithId(l:id, l:stop_way)
    endif

    if !empty(l:key)
        call s:StopAsyncJobWithKey(l:key, l:stop_way)
    endif

    if !empty(l:name)
        call s:StopAsyncJobWithName(l:name, l:stop_way)
    endif

    if index(split(a:args), '--all') >= 0
        call s:StopAsyncJobAll(l:stop_way)
    endif
endfunction

" 定义补全函数
function! s:AsyncStopComplete(arglead, cmdline, cursorpos) abort
    " 检查是否正在补全 --stop-way= 的值
    if a:arglead =~# '^--stop-way='
        " 提取 = 后面的部分（用户已经输入的值前缀，比如 'k'）
        let l:prefix = substitute(a:arglead, '^--stop-way=', '', '')
        let l:stop_ways = ['term', 'hup', 'int', 'quit', 'kill']
        " 过滤出匹配的项
        let l:matches = filter(copy(l:stop_ways), 'stridx(v:val, l:prefix) == 0')
        " 【关键】把前缀拼回去，返回完整的参数
        return map(l:matches, '"--stop-way=" . v:val')
    endif
    " 否则补全选项名
    let l:options = ['--id=', '--key=', '--name=', '--stop-way=', '--all']
    return filter(copy(l:options), 'stridx(v:val, a:arglead) == 0')
endfunction

" 根据命令获取默认参数的subjob
function! s:GetDefaultSubJob(cmd, last) abort
    let l:default_job = {
        \ 'org': '',
        \ 'cmd': a:cmd,
        \ 'len': strchars(a:cmd),
        \ 'fmt': &errorformat,
        \ 'fil': 'all',
        \ 'o': v:false,
        \ 'ts': '',
        \ 'te': '',
        \ 'sts': 'uinit'
        \ }

    let l:program = split(a:cmd)[0]
    if l:program ==# 'grep'
        let l:default_job.fmt = '%f:%l:%m'
        let l:default_job.fil = 'out'
        let l:default_job.o = a:last ? v:true : l:default_job.o
    elseif l:program ==# 'rg'
        let l:default_job.fmt = '%f:%l:%c:%m'
        let l:default_job.fil = 'out'
        let l:default_job.o = a:last ? v:true : l:default_job.o
    endif
    return l:default_job
endfunction

" 将async命令的参数解析成subjobs
function! s:ParseAsyncArgs(args) abort
    let l:subjobs = []
    let l:cmdlist = s:SplitAsyncArgs(a:args)
    for i in range(len(l:cmdlist))
        let last = i == len(l:cmdlist) - 1
        let cmd = l:cmdlist[i]
        " 获取默认参数的subjob
        let subjob = s:GetDefaultSubJob(cmd.cmd, last)

        " 从设置的命令更新参数
        let org = empty(cmd.pre_cmd) ? cmd.cmd : cmd.pre_cmd . ' ' . cmd.cmd
        let cmd_ctr = s:GetCtrFromPrecmd(cmd.pre_cmd)
        " ---------------------------------------------
        let subjob.org = org
        let subjob.cmd = cmd.cmd
        let subjob.len = strchars(cmd.cmd)
        if !empty(cmd_ctr.fmt)
            let subjob.fmt = cmd_ctr.fmt
        endif
        if !empty(cmd_ctr.fil)
            let subjob.fil = cmd_ct.fil
        endif
        if !empty(cmd_ctr.o)
            let subjob.o = cmd_ctr.o ==# '0' ? v:false : v:true
        endif

        " 加入到列表
        call add(l:subjobs, subjob)
    endfor

    return l:subjobs
endfunction

" 从<...|...>中解析出fmt、o等参数
function! s:GetCtrFromPrecmd(pre_cmd) abort
    let l:cmd_ctr = {'fmt': '', 'fil': '', 'o': ''}

    if a:pre_cmd !~# '^<.*>$'
        return l:cmd_ctr
    endif

    " 去掉首尾的 < >
    let l:content = strcharpart(a:pre_cmd, 1, strchars(a:pre_cmd) - 2)

    for l:field in split(l:content, '|', 1)
        if l:field =~# '^fmt='
            let l:cmd_ctr.fmt = strpart(l:field, strlen('fmt='))
        elseif l:field =~# '^fil='
            let l:cmd_ctr.fil = strpart(l:field, strlen('fil='))
        elseif l:field =~# '^o='
            let l:cmd_ctr.o = strpart(l:field, strlen('o='))
        endif
    endfor

    return l:cmd_ctr
endfunction

" 分割async命令参数 [{pre_cmd=<...> cmd=...}]
function! s:SplitAsyncArgs(args) abort
    let l:s = a:args
    let l:total = strchars(l:s)
    let l:i = 0
    let l:result = []

    while l:i < l:total
        " 1. 找到第一个非空字符
        while l:i < l:total && strcharpart(l:s, l:i, 1) =~# '^\s$'
            let l:i += 1
        endwhile
        if l:i >= l:total
            break
        endif

        " 不以 < 开头：从当前位置到末尾，整体作为 cmd
        if strcharpart(l:s, l:i, 1) !=# '<'
            call add(l:result, {
                        \ 'pre_cmd': '',
                        \ 'cmd': strcharpart(l:s, l:i)
                        \ })
            break
        endif

        " 2. 读取整个 <...>，作为 pre_cmd
        let l:pre_start = l:i
        while l:i < l:total && strcharpart(l:s, l:i, 1) !=# '>'
            let l:i += 1
        endwhile
        if l:i >= l:total
            throw 'SplitAsyncArgs: 缺少 >'
        endif

        let l:pre_cmd = strcharpart(l:s, l:pre_start, l:i - l:pre_start + 1)
        let l:options = strcharpart(l:s, l:pre_start + 1, l:i - l:pre_start - 1)
        let l:i += 1

        " 按 | 分割 <...> 的内容，查找 len=数字
        let l:len_text = ''
        for l:field in split(l:options, '|', 1)
            let l:value = matchstr(l:field, '^len=\zs[0-9]\+$')
            if !empty(l:value)
                let l:len_text = l:value
                break
            endif
        endfor

        " 3. 找到 <...> 之后 cmd 的第一个非空字符
        while l:i < l:total && strcharpart(l:s, l:i, 1) =~# '^\s$'
            let l:i += 1
        endwhile
        if l:i >= l:total
            throw 'SplitAsyncArgs: <...> 之后缺少命令'
        endif

        " 没有 len：cmd 一直取到末尾
        if empty(l:len_text)
            call add(l:result, {
                        \ 'pre_cmd': l:pre_cmd,
                        \ 'cmd': strcharpart(l:s, l:i)
                        \ })
            break
        endif

        " 有 len：按指定字符数截取 cmd
        let l:cmd_len = str2nr(l:len_text)
        if l:cmd_len <= 0 || l:i + l:cmd_len > l:total
            throw 'SplitAsyncArgs: len 无效或命令长度不足'
        endif

        call add(l:result, {
                    \ 'pre_cmd': l:pre_cmd,
                    \ 'cmd': strcharpart(l:s, l:i, l:cmd_len)
                    \ })
        let l:i += l:cmd_len

        " 4. 截取完 cmd 后，跳过空白并查找分隔符 |
        while l:i < l:total && strcharpart(l:s, l:i, 1) =~# '^\s$'
            let l:i += 1
        endwhile
        if l:i >= l:total
            break
        endif
        if strcharpart(l:s, l:i, 1) !=# '|'
            throw 'SplitAsyncArgs: 命令之后缺少分隔符 |'
        endif
        let l:i += 1

        " 分隔符后不能只有空白
        let l:next = l:i
        while l:next < l:total && strcharpart(l:s, l:next, 1) =~# '^\s$'
            let l:next += 1
        endwhile
        if l:next >= l:total
            throw 'SplitAsyncArgs: 分隔符 | 之后缺少命令'
        endif
    endwhile

    return l:result
endfunction

" 将多条命令合并成一条
" 完整的async命令格式: Async <...> cmd1 [...] | <...> cmd2 [...]
" 如: Async <len=42> find . -name "*.cpp" -print > cscope.files | <len=31|fmt=%f:%l:%m,%f:%l:%c:%m|o=1> cscope -b -q -k -i cscope.files
" <...>是命令前缀，'<...> '后跟具体命令, 多条命令用|隔开
" 命令前缀用来指定命令额外的一些行为，多个行为也用|隔开, 其中:
" len: 指定了命令的长度, 多条命令拼接时需要
" fmt: 指定命令输出的格式
" o  : 指定命令结束后是否打开quickfix
function! s:MergeAsyncCmd(cmds) abort
    if len(a:cmds) == 0
        return ''
    elseif len(a:cmds) == 1
        return a:cmds[0]
    endif

    let l:merge_cmd = 'Async '

    for i in range(len(a:cmds))
        let cmd = a:cmds[i]

        " 去掉前面的Async
        let rcmd = trim(substitute(cmd, '^\s*\S\+', '', ''))
        " 注意这里必须用strchars, 如果用len则不等于字符数
        let opt_len = '<len=' . strchars(rcmd) . '> '

        if i == len(a:cmds) - 1
            " 最后一项
            let l:merge_cmd = l:merge_cmd . rcmd
        else
            let l:merge_cmd = l:merge_cmd . opt_len . rcmd . ' | '
        endif

    endfor

    return l:merge_cmd
endfunction

function! s:GenCscopeAsync(args) abort
    let l:cmd_genf = s:GenCscopeFilesAsync(a:args . " --no_run")
    let l:cmd_genc = s:GenCscopeFromFilesAsync(a:args . " --no_run")

    " 如果指定了path直接用GenCscopeFromFilesAsync的命令, 否则组合命令
    let l:path = s:ExtractPath(a:args)
    if !empty(l:path)
        let l:cmd = l:cmd_genc
    else
        let l:cmd = s:MergeAsyncCmd([l:cmd_genf, l:cmd_genc])
    endif

    " 有--no_run命令
    " if match(a:args, '\%(^\|\s\)--no_run\%(\s\|$\)') >= 0
    if index(split(a:args), '--no_run') >= 0
        return l:cmd
    endif

    " 有--f命令
    " if match(a:args, '\%(^\|\s\)--f\%(\s\|$\)') >= 0
    if index(split(a:args), '--f') >= 0
        call feedkeys(':' . l:cmd . "\<C-f>", 'n')
    else
        execute l:cmd
    endif

    return l:cmd
endfunction

function! s:GenCscopeFromFilesAsync(args) abort
    let l:cmd = 'Async cscope -b -q -k -i '
    let l:path = s:ExtractPath(a:args)
    if !empty(l:path)
        let l:cmd = l:cmd . shellescape(s:ExtractPath(a:args))
    else
        let l:cmd = l:cmd . 'cscope.files'
    endif

    " 有--no_run命令
    " if match(a:args, '\%(^\|\s\)--no_run\%(\s\|$\)') >= 0
    if index(split(a:args), '--no_run') >= 0
        return l:cmd
    endif

    " 有--f命令
    " if match(a:args, '\%(^\|\s\)--f\%(\s\|$\)') >= 0
    if index(split(a:args), '--f') >= 0
        call feedkeys(':' . l:cmd . "\<C-f>", 'n')
    else
        execute l:cmd
    endif

    return l:cmd
endfunction

function! s:ExtractPath(s) abort
    " 1. 双引号包裹
    let path = matchstr(a:s, '--path="\zs[^"]\+')
    if !empty(path)
        return path
    endif

    " 2. 单引号包裹
    let path = matchstr(a:s, "--path='\\zs[^']\\+")
    if !empty(path)
        return path
    endif

    " 3. 无引号（到空格或结尾）
    let path = matchstr(a:s, '--path=\zs\S\+')
    return path
endfunction

function! s:GenCscopeFilesAsync(args) abort
    let l:lang = matchstr(a:args, '\%(^\|\s\)--lang=\zs\S\+')

    " language
    if empty(l:lang) || l:lang ==? 'auto'
        if &l:filetype ==# 'cpp' || &l:filetype ==# 'c'
            let l:lang = 'c,c++'
        elseif &l:filetype ==# 'python'
            let l:lang = 'python'
        else
            let l:lang = ''
        endif
    endif

    " include
    let l:inc = ''
    if l:lang =~? '^\(c\|c++\|c,c++\)$'
        let l:inc = '"(" -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" ")" '
    elseif l:lang ==? 'python'
        let l:inc = '"(" -name "*.py" ")" '
    endif

    " exclude dirs
    let l:exc =
        \ '"(" '
        \ . '-name ".git" '
        \ . '-o -name "build" '
        \ . '")" -prune -o '

    " build ctags command
    let l:cmd =
        \ 'Async find . '
        \ . l:exc
        \ . '-type f '
        \ . l:inc
        \ . '-print > cscope.files'

    " 有--no_run命令
    " if match(a:args, '\%(^\|\s\)--no_run\%(\s\|$\)') >= 0
    if index(split(a:args), '--no_run') >= 0
        return l:cmd
    endif

    " 有--f命令
    " if match(a:args, '\%(^\|\s\)--f\%(\s\|$\)') >= 0
    if index(split(a:args), '--f') >= 0
        call feedkeys(':' . l:cmd . "\<C-f>", 'n')
    else
        execute l:cmd
    endif

    return l:cmd
endfunction

" " 测试数据
" " 定义基础模板，每个任务使用 copy() 避免共享
" let s:sub_job1 = {
"     \ 'org': 'Grep -Rn vim .',
"     \ 'cmd': 'Grep -Rn vim .',
"     \ 'len': 14,
"     \ 'fmt': '%f:%l:%m',
"     \ 'fil': 'all',
"     \ 'o': v:false,
"     \ 'ts': 0,
"     \ 'te': 0,
"     \ 'sts': 'running'
" \ }

" let s:sub_job2 = {
"     \ 'org': '<len=31|o=1> cscope -b -q -i -i cscope.files',
"     \ 'cmd': 'cscope -b -q -i -i cscope',
"     \ 'len': 31,
"     \ 'fmt': '%f:%l:%m',
"     \ 'fil': 'all',
"     \ 'o': v:false,
"     \ 'ts': 0,
"     \ 'te': 0,
"     \ 'sts': 'xdone'
" \ }

" " 使用 copy() 隔离，防止 abc 和 xyz 互相影响
" let s:asyncjobs = {}
" let s:asyncjobs['abc'] = {
"     \ 'id': 0,
"     \ 'job': v:null,
"     \ 'timer': v:null,
"     \ 'state': 'running',
"     \ 'outs': [],
"     \ 'errs': [],
"     \ 'prog_idx': 0,
"     \ 'subjobs': [copy(s:sub_job1), copy(s:sub_job2)],
"     \ 'subjob_id': 1
" \ }

" let s:asyncjobs['xyz'] = {
"     \ 'id': 1,
"     \ 'job': v:null,
"     \ 'timer': v:null,
"     \ 'state': 'running',
"     \ 'outs': [],
"     \ 'errs': [],
"     \ 'prog_idx': 0,
"     \ 'subjobs': [copy(s:sub_job1)],
"     \ 'subjob_id': 0
" \ }

" command! -nargs=0 AsyncQ call s:OpenCustomTimerWindow('Async jobs', 's:ScheduleAsyncQuery', 200)

" 查询Async异步任务
function! s:ScheduleAsyncQuery(bufnr, timer) abort
    " 如果 buffer 已经不存在了，停掉 timer
    if !bufexists(a:bufnr)
        call timer_stop(a:timer)
        return
    endif

    " 如果 buffer 不在任何窗口显示了，也可以停掉 timer
    if empty(win_findbuf(a:bufnr))
        call timer_stop(a:timer)
        return
    endif

    " if empty(s:async_jobs)
    "     return
    " endif

    let l:async_job_msg = []
    let l:msg = printf("id  subjob-id   name        state       time(s)    cmd")
    call add(l:async_job_msg, l:msg)
    for [l:key, l:data] in items(s:async_jobs)
        for i in range(len(l:data.subjobs))
            let l:subjob = l:data.subjobs[i]

            let l:time = l:subjob.te
            if empty(l:time)
                let l:time = printf('%.1f', reltimefloat(reltime(l:subjob.ts)))
            endif

            let l:msg = printf("%-2d\t\t%-2d\t\t%-8s\t%-8s\t%-5s\t\t%s",
                        \ l:data.id, i, split(l:subjob.cmd)[0], l:subjob.sts, l:time, l:subjob.cmd)

            call add(l:async_job_msg, l:msg)
        endfor
    endfor

    " 临时解除不可修改状态，填入内容
    call setbufvar(a:bufnr, '&modifiable', 1)

    " 清空并写入新内容
    silent call deletebufline(a:bufnr, 1, '$')
    call setbufline(a:bufnr, 1, l:async_job_msg)

    " 恢复不可修改状态
    call setbufvar(a:bufnr, '&modifiable', 0)
endfunction

" 全局保存 timer 和 buffer 的映射
let s:custom_schedule_window = {}

" 打开窗口并初始化, titile: 窗口标题 timer_fun: timer回调函数名 time刷新时间
function! s:OpenCustomTimerWindow(title, timer_fun, time) abort
    " 在下方开一个 10 行的分屏
    execute 'botright 10split'

    " 创建一个无关联的 scratch buffer
    enew
    " 设置 buffer 属性：不关联文件、不保存、关闭窗口时自动销毁(wipe)
    setlocal buftype=nofile bufhidden=wipe noswapfile
    " 禁止修改
    setlocal nomodifiable
    " 设置 buffer 名称
    execute 'file [' . a:title . ']'

    let l:bufnr = bufnr('%')

    " 启动 timer 刷新内容
    let l:timer = timer_start(a:time, function(a:timer_fun, [l:bufnr]), {'repeat': -1})
    let s:custom_schedule_window[l:bufnr] = l:timer

    " 监听 buffer 销毁（窗口关闭时自动触发）
    augroup WindowAutoCleanup
        autocmd!
        execute 'autocmd BufWipeout <buffer=' . l:bufnr . '> call s:OnCustomScheduleWindowClosed(' . l:bufnr . ')'
    augroup END

    " 映射 q 关闭窗口
    nnoremap <buffer> <silent> q :close<CR>
endfunction

" 窗口关闭时的清理逻辑
function! s:OnCustomScheduleWindowClosed(bufnr) abort
    if has_key(s:custom_schedule_window, a:bufnr)
        call timer_stop(s:custom_schedule_window[a:bufnr])
        call remove(s:custom_schedule_window, a:bufnr)
    endif
    " 可以在这里写其他清理逻辑
    " echom "自定义窗口已关闭，timer 已停止"
endfunction

function! s:GenTagsAsync(args) abort
    let l:lang = matchstr(a:args, '\%(^\|\s\)--lang=\zs\S\+')

    " language
    if empty(l:lang) || l:lang ==? 'auto'
        if &l:filetype ==# 'cpp' || &l:filetype ==# 'c'
            let l:lang = '--languages=C,C++ '
        elseif &l:filetype ==# 'python'
            let l:lang = '--languages=Python '
        else
            let l:lang = ''
        endif
    else
        let l:lang = '--languages=' . l:lang . ' '
    endif

    " exclude dirs
    let l:exc =
        \ '--exclude=.git '
        \ . '--exclude=build '

    " build ctags command
    let l:cmd =
        \ 'Async ctags -R '
        \ . l:lang
        \ . l:exc

    " 有--no_run命令
    " if match(a:args, '\%(^\|\s\)--no_run\%(\s\|$\)') >= 0
    if index(split(a:args), '--no_run') >= 0
        return l:cmd
    endif

    " 有--f命令
    " if match(a:args, '\%(^\|\s\)--f\%(\s\|$\)') >= 0
    if index(split(a:args), '--f') >= 0
        call feedkeys(':' . l:cmd . "\<C-f>", 'n')
    else
        execute l:cmd
    endif

    return l:cmd
endfunction

function! s:AsyncTest(args) abort
    let l:ts = empty(a:args) ? '10' : a:args

    " let l:cmd = 'Async <o=1> grep -Rn vim .'
    " let l:cmd = 'Async sleep ' . l:ts
    " let l:cmd = 'Async <o=1> rg --vimgrep -H -n vim .'
    let l:cmd = 'Async <len=14|o=1> grep -Rn vim . | sleep ' . l:ts

    execute l:cmd
    return l:cmd
endfunction

function! s:AsyncSleep(args) abort
    let l:cmd = 'Async sleep ' . a:args
    execute l:cmd
    return l:cmd
endfunction
" }}}

" ==========format settings========== {{{
augroup doc_format
    autocmd!
    " 如果有.clang-format就优先使用，否则使用--fallback-style
    autocmd FileType c,cpp let &l:formatprg =
          \ 'clang-format --style=file --fallback-style=Mozilla'
          \ . ' --assume-filename='
          \ . shellescape(empty(expand('%:t')) ? 'stdin.c' : expand('%:t'))
augroup END

" style: LLVM Google Chromium Mozilla WebKit Microsoft GNU None
let s:formatters = [
      \ 'LLVM',
      \ 'Google',
      \ 'Chromium',
      \ 'Mozilla',
      \ 'WebKit',
      \ 'Microsoft',
      \ 'GNU',
      \ 'None',
      \ ]

" 格式化, 缩进依赖于 tabstop shiftwidth expandtab
function! s:DocumentFormat(firstl, lastl, style) abort
    let l:saved_fp = &l:formatprg

    if !empty(a:style)
        let l:base_style = ''

        if a:style ==? 'linux'
            let l:base_style = 'LLVM'
            let l:brace_style = 'BreakBeforeBraces: Linux'
        elseif index(s:formatters, a:style) >= 0
            let l:base_style = a:style
            let l:brace_style = ''
        else
            echo 'Unknown format style: ' . a:style
            return
        endif

        " shiftwidth 为 0 时，使用 tabstop
        let l:indent_width = &l:shiftwidth > 0
              \ ? &l:shiftwidth
              \ : &l:tabstop

        let l:use_tab = &l:expandtab ? 'Never' : 'ForIndentation'

        let l:style = printf(
              \ '{BasedOnStyle: %s, IndentWidth: %d, TabWidth: %d, UseTab: %s%s}',
              \ l:base_style,
              \ l:indent_width,
              \ &l:tabstop,
              \ l:use_tab,
              \ empty(l:brace_style) ? '' : ', ' . l:brace_style
              \ )

        let l:cmd = 'clang-format --style=' . shellescape(l:style)

        let l:filename = expand('%:t')
        if empty(l:filename)
            let l:filename = 'stdin.c'
        endif

        let l:cmd .= ' --assume-filename=' . shellescape(l:filename)
        let &l:formatprg = l:cmd
    endif

    try
        execute 'normal! ' . a:firstl . 'Ggq' . a:lastl . 'G'
    finally
        let &l:formatprg = l:saved_fp
    endtry
endfunction


" 命令补全函数
function! s:FormatComplete(ArgLead, CmdLine, CursorPos) abort
    let l:styles = ['Linux'] + s:formatters
    let l:result = []

    for l:style in l:styles
        if strpart(l:style, 0, strlen(a:ArgLead)) ==# a:ArgLead
            call add(l:result, l:style)
        endif
    endfor

    return l:result
endfunction

" 格式化命令映射, 不带参数则使用doc_format中的默认设置,
" 这将使.clang-format成为第一优先级
" :Format [linux/Mozilla/...]           格式化整个文件
" :'<,'>Format [linux/Mozilla/...]      格式化选中的行
" command! -range=% -nargs=? Format call <SID>DocumentFormat(<line1>, <line2>, <q-args>)
command! -range=% -nargs=? -complete=customlist,s:FormatComplete Format
      \ call <SID>DocumentFormat(<line1>, <line2>, <q-args>)
" }}}

" ==========fold settings========== {{{
" no fold when open file
set foldlevelstart=99

" vim fold setting
augroup fold_filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" " cpp fold setting
" augroup fold_filetype_cpp
"     autocmd!
"     autocmd FileType c,cpp setlocal foldmethod=manual "手动折叠，性能最好
"     " autocmd FileType c,cpp setlocal foldmethod=indent "缩进折叠
"     " autocmd FileType c,cpp setlocal foldmethod=syntax "一些版本的vim可能造成无法忍受的卡顿!!!
" augroup END

" syntax模式下计算并更新fold然后切回manual
" 在需要时手动更新，这样既获得了syntax的折叠功能又兼顾了manual的速度
function! s:BuildFolds() abort
    setlocal foldmethod=syntax
    normal! zx
    setlocal foldmethod=manual
endfunction

command! BuildFolds call s:BuildFolds()

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

" toggle open/close quickfix window
" learn what is wincmd w、winnr()
" TODO bug: when use command 'copen' g:quickfix_is_open cannot be updated
nnoremap <leader>q :call QuickfixToggle()<cr>
let g:quickfix_is_open = 0
function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        botright copen
        let g:quickfix_is_open = 1
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
" ==========vim grep========== {{{
" command completement of search
" g: 一行如果有多个匹配所有
" j: 不跳转到第一个匹配
" botright cwindow: 如果结果不为空最底部打开quickfix window
" <S-Left>/<Left>: 用于修改光标位置
nnoremap <leader>sw :vimgrep /\<<C-r><C-w>\>/gj % \| botright cwindow<S-Left><S-Left><S-Left><S-Left><Left><Left><Left><Left><Left><Left>
nnoremap <leader><leader>sw :vimgrep /<C-r><C-w>/gj % \| botright cwindow<S-Left><S-Left><S-Left><S-Left><Left><Left><Left><Left>

" command completement of grep
nnoremap <leader>sc :silent! vimgrep /\<<C-r><C-w>\>/gj ./**/*.{c,cc,cpp,h,hpp} \| botright cwindow<C-f>BBBBhhhhhh
nnoremap <leader>sh :silent! vimgrep /\<<C-r><C-w>\>/gj ./**/*.{h,hpp} \| botright cwindow<C-f>BBBBhhhhhh
nnoremap <leader>s% :silent! vimgrep /\<<C-r><C-w>\>/gj % \| botright cwindow<C-f>BBBBhhhhhh
nnoremap <leader>ss :silent! vimgrep /\<<C-r><C-w>\>/gj ./**/* \| botright cwindow<C-f>BBBh
" -----------------------------------------------------------------------------------------------------------
nnoremap <leader><leader>sc :silent! vimgrep /<C-r><C-w>/gj ./**/*.{c,cc,cpp,h,hpp} \| botright cwindow<C-f>BBBBhhhh
nnoremap <leader><leader>sh :silent! vimgrep /<C-r><C-w>/gj ./**/*.{h,hpp} \| botright cwindow<C-f>BBBBhhhh
nnoremap <leader><leader>s% :silent! vimgrep /<C-r><C-w>/gj % \| botright cwindow<C-f>BBBBhhhh
nnoremap <leader><leader>ss :silent! vimgrep /<C-r><C-w>/gj ./**/* \| botright cwindow<C-f>BBBh
" }}}

" ==========async grep========== {{{
" g@: call the function set by the 'operatorfunc'
" <SID>: use for function namespace
" <c-u>: clear the command line to the begin
" visualmode(): vim inside function to get the last visual mode type: v, V, <C-v>
" the two map below are for nomal mode, visual mode
" how to use: <localleader>giw, viw<localleader>g ...
nnoremap <silent> <leader>g :set operatorfunc=<SID>GrepOperatorR<CR>g@
vnoremap <silent> <leader>g :<c-u>call <SID>GrepOperatorR(visualmode())<CR>
nnoremap <silent> <leader>G :set operatorfunc=<SID>GrepOperatorNR<CR>g@
vnoremap <silent> <leader>G :<c-u>call <SID>GrepOperatorNR(visualmode())<CR>
" better use than <leader>G
nnoremap <silent> <leader><leader>g :set operatorfunc=<SID>GrepOperatorNR<CR>g@
vnoremap <silent> <leader><leader>g :<c-u>call <SID>GrepOperatorNR(visualmode())<CR>

" command! -nargs=+ AsyncGrep call s:AsyncGrep(<q-args>)
" command! -nargs=? -complete=customlist,s:StopGrepComplete StopGrep
"       \ call s:StopGrep(<f-args>)

function! s:GrepOperatorR(type)
    call s:GrepOperatorAsync(a:type, 1)
endfunction

function! s:GrepOperatorNR(type)
    call s:GrepOperatorAsync(a:type, 0)
endfunction

function! s:GrepDetect() abort
    for i in range(len(s:grep_tools))
        let l:tool = s:grep_tools[i]
        if executable(l:tool)
            let g:grep_tool = l:tool
            let g:grep_format = s:grep_tools_format[i]
            return
        endif
    endfor
endfunction

function! SetGrep(name) abort
    for i in range(len(s:grep_tools))
        let l:tool = s:grep_tools[i]
        if l:tool ==# a:name && executable(l:tool)
            let g:grep_tool = l:tool
            let g:grep_format = s:grep_tools_format[i]
            break
        endif
    endfor
    echo 'grep_tool = ' . g:grep_tool . ' | ' . 'grep_format = ' . g:grep_format
endfunction

function! s:GetGrepFmt(name) abort
    for i in range(len(s:grep_tools))
        let l:tool = s:grep_tools[i]
        if l:tool ==# a:name
            return s:grep_tools_format[i]
        endif
    endfor
    return ''
endfunction
" --------------------------------------------------
let s:grep_tools = ['rg', 'grep']
let s:grep_tools_format = ['%f:%l:%c:%m', '%f:%l:%m']
let g:grep_tool = 'grep'
let g:grep_format = '%f:%l:%m'
call s:GrepDetect()

" ==========grep job========== {{{
" let g:grep_job = -1
" let g:grep_timer = -1
" let g:grep_index = 0

" function! s:GetProgramFromShellCmd(cmd) abort
"     let l:program = ''
"     if !empty(a:cmd)
"         let l:program = matchstr(l:cmd[2], '^\s*\zs\S\+')
"     endif
"     return l:program
" endfunction

" " 异步grep, 注意job_start执行的是外部命令
" " 而RunGrep中的execute 'silent grep! ' . a:args执行的是vim的包装命令
" function! s:AsyncGrep(args) abort
"     let l:cmd = a:args
"     let l:shell_cmd = [&shell, &shellcmdflag, a:args]

"     " 异步任务
"     let l:outs = []
"     let l:errs = []
"     " out_mode/err_mode: nl: 按换行符切分输出，否则可能是半行
"     " exit_cb: 进程退出回调，copy一下防止直接修改内容
"     let g:grep_index = 0
"     let g:grep_job = job_start(l:shell_cmd, {
"             \ 'out_mode': 'nl',
"             \ 'err_mode': 'nl',
"             \ 'out_cb': {ch, msg -> !empty(msg) ? add(l:outs, msg) : 0},
"             \ 'err_cb': {ch, msg -> !empty(msg) ? add(l:errs, msg) : 0},
"             \ 'exit_cb': {job, code -> s:GrepDone(copy(l:outs), copy(l:errs), l:cmd, code)}
"             \ })

"   " 每 200 毫秒更新一次状态
"   let g:grep_timer = timer_start(
"         \ 200,
"         \ 's:GrepTick',
"         \ {'repeat': -1}
"         \ )

"     echo "AsyncGrep running ... |"
" endfunction

" function! s:GrepTick(timer) abort
"     let chars = ['|', '/', '-', '\']
"     let g:grep_index = (g:grep_index + 1) % len(chars)
"     echo 'AsyncGrep running ... ' . chars[g:grep_index]
" endfunction

" function! s:GrepDone(lines, errs, cmd, code) abort
"     " 停止timer
"     if g:grep_timer != -1
"         call timer_stop(g:grep_timer)
"         let g:grep_timer = -1
"     endif

"     echom "AsyncGrep finish(" . a:code . "). Filling quickfix ..."

"     if !empty(a:errs)
"         echom join(a:errs, "\n")
"     endif

"     " if !empty(a:lines)
"     "     echom join(a:lines, "\n")
"     " endif

"     " 过滤空项
"     let l:lines = filter(a:lines, '!empty(v:val)')
"     " 填入quickfix
"     " 使用第三个参数更新，因为l:lines需要解析成quickfix的格式
"     " 如果l:lines直接就是解析好的格式，可以直接用第一个参数
"     " efm: errorformat
"     " %f: 文件名
"     " %l: 行号
"     " %m: message
"     " 这里的解析必须配合grep输出格式，如果是其他如rg就需要相应修改解析
"     call setqflist([], ' ', {
"                 \ 'title': a:cmd,
"                 \ 'lines': l:lines,
"                 \ 'efm': s:GetGrepFmt(split(a:cmd)[0])
"                 \ })

"     " 打开窗口
"     if !empty(l:lines)
"         botright copen
"     endif

"     echom "AsyncGrep done | " . len(l:lines) . " found"
" endfunction

" " 'term'    " 默认，正常终止
" " 'hup'     " 发送 HUP
" " 'int'     " 发送 INT，类似 Ctrl-C
" " 'quit'    " 发送 QUIT
" " 'kill'    " 强制杀死
" let s:stop_ways = [
"       \ 'term',
"       \ 'hup',
"       \ 'int',
"       \ 'quit',
"       \ 'kill',
"       \ ]

" function! s:StopGrep(...) abort
"     let l:type = a:0 > 0 ? a:1 : s:stop_ways[0]
"     if index(s:stop_ways, l:type) < 0
"         echom '无效的停止方式: ' . l:type
"         return
"     endif

"     " 停止timer
"     if exists('g:grep_timer') && g:grep_timer != -1
"         call timer_stop(g:grep_timer)
"         let g:grep_timer = -1
"     endif

"     " 停止job
"     if exists('g:grep_job') && job_status(g:grep_job) ==# 'run'
"         call job_stop(g:grep_job, l:type)
"     endif
" endfunction

" " 命令补全函数
" function! s:StopGrepComplete(ArgLead, CmdLine, CursorPos) abort
"     let l:styles = s:stop_ways
"     let l:result = []

"     for l:style in l:styles
"         if strpart(l:style, 0, strlen(a:ArgLead)) ==# a:ArgLead
"             call add(l:result, l:style)
"         endif
"     endfor

"     return l:result
" endfunction
" }}}

" ==========grep 路由========== {{{
" 增强异步版本的grep，预填基础信息允许用户修改, 尤其是填充exclude信息
function! s:GrepOperatorAsync(type, recursion) abort
    " save unnamed register
    let l:saved_unnamed_register = @@

    try
        " yank selected text
        if a:type ==# 'v'
            normal! `<v`>y
        elseif a:type ==# 'char'
            normal! `[v`]y
        else
            return
        endif

        let l:grep_cmd = ''
        if g:grep_tool ==# 'rg'
            let l:grep_cmd = s:BuildCmdRipGrep(shellescape(@@), a:recursion)
        elseif g:grep_tool ==# 'grep'
            let l:grep_cmd = s:BuildCmdGnuGrep(shellescape(@@), a:recursion)
        else
            echo "Unsupported grep tool: " . g:grep_tool
            return
        endif

        " open command-line window with editable command
        call feedkeys(':' . l:grep_cmd . "\<C-f>", 'n')

    finally
        " restore unnamed register
        let @@ = l:saved_unnamed_register
    endtry
endfunction

function! s:BuildCmdGnuGrep(pattern, recursion) abort
    " include filters
    let l:inc = ''
    if &l:filetype ==# 'cpp' || &l:filetype ==# 'c'
        let l:inc =
            \ '--include=*.c '
            \ . '--include=*.cc '
            \ . '--include=*.cpp '
            \ . '--include=*.h '
            \ . '--include=*.hpp '
    elseif &l:filetype ==# 'python'
        let l:inc = '--include=*.py '
    endif

    " exclude dirs
    let l:exc =
        \ '--exclude-dir=.git '
        \ . '--exclude-dir=build '

    " build grep command
    if a:recursion
        let l:grep_cmd =
            \ 'Async grep -Rn '
            \ . l:inc
            \ . l:exc
            \ . a:pattern
            \ . ' .'
    else
        let l:grep_cmd =
            \ 'Async grep -Hn '
            \ . a:pattern
            \ . ' ' . expand('%:p')
    endif

    return l:grep_cmd
endfunction

function! s:BuildCmdRipGrep(pattern, recursion) abort
    " include filters
    let l:inc = ''
    if &l:filetype ==# 'cpp' || &l:filetype ==# 'c'
        let l:inc =
            \ '-g *.c '
            \ . '-g *.cc '
            \ . '-g *.cpp '
            \ . '-g *.h '
            \ . '-g *.hpp '
    elseif &l:filetype ==# 'python'
        let l:inc = '-g *.py '
    endif

    " exclude dirs
    let l:exc =
        \ '-g !.git '
        \ . '-g !build '

    " build grep command
    if a:recursion
        let l:grep_cmd =
            \ 'Async rg --vimgrep -H -n '
            \ . l:inc
            \ . l:exc
            \ . a:pattern
            \ . ' .'
    else
        let l:grep_cmd =
            \ 'Async rg --vimgrep -H -n '
            \ . a:pattern
            \ . ' ' . expand('%:p')
    endif

    return l:grep_cmd
endfunction
" }}}
" }}}
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
" 设置c++查找路径，若WSL下无法识别std，请打开该设置
" let g:lsp_settings = {
" \   'clangd': {
" \   'args': ['--query-driver=/usr/bin/c++*,/usr/bin/g++*'],
" \   }
" \}

" " PYTHON LSP
" " 若无法忍受vim-lsp-settings插件在打开文件时的卡顿
" " 手动配置LSP语言服务, 请注释: Plug 'mattn/vim-lsp-settings'
" if executable('ty')
"     " pip install ty
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'ty',
"         \ 'cmd': {server_info->['ty', 'server']},
"         \ 'allowlist': ['python'],
"         \ })
" endif

" " C/C++ LSP
" " 若WSL下无法识别std，加入下面这条命令
" \   '--query-driver=/usr/bin/c++*,/usr/bin/g++*',
" if executable('clangd')
"     " sudo apt install clangd
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'clangd',
"         \ 'cmd': {server_info->[
"         \   'clangd',
"         \   '--background-index',
"         \   '--clang-tidy',
"         \ ]},
"         \ 'allowlist': ['c', 'cpp'],
"         \ })
" endif


" 启用原生LSP
let g:lsp_use_native_client = 1

" 启动时禁用lsp
let g:lsp_auto_enable = 0

" 语义高亮, 速度有些慢
let g:lsp_semantic_enabled = 1
let g:lsp_semantic_delay = 500

" 禁止光标停留自动高亮
let g:lsp_document_highlight_enabled = 0

" 禁止函数签名提示自动弹出在输入模式下
let g:lsp_signature_help_enabled = 0

" 补全额外信息显示
let g:lsp_completion_documentation_enabled = 1

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
let g:lsp_diagnostics_signs_delay = 500                     " 延迟符号显示
let g:lsp_diagnostics_signs_insert_mode_enabled = 1         " 插入模式侧边符号显示
" 设置符号样式
" let g:lsp_diagnostics_signs_error = {'text': '✗', 'texthl': 'DiagnosticSignError'}
" let g:lsp_diagnostics_signs_warning = {'text': '⚠', 'texthl': 'DiagnosticSignWarn'}
" 关闭错误诊断虚拟文本
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0

" 禁止补全弹窗自动弹出
let g:asyncomplete_auto_popup = 0

" allow modifying the completeopt variable, or it will
" be overridden all the time
" 不自动设置补全行为
let g:asyncomplete_auto_completeopt = 0

" lsp log
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/logs/vim-lsp.log')
" let g:asyncomplete_log_file = expand('~/logs/asyncomplete.log')

" 设置手动开关命令
command! LspEnable call s:LspEnable()
command! LspEnableFast call s:LspEnableFast()
command! LspEnableHeavy call s:LspEnableHeavy()
command! LspDisable call s:LspDisable()
command! LspRestart call s:LspRestartServer()
" -----------------------------------
command! LspFast call s:LspFast()
command! LspHeavy call s:LspHeavy()

" 设置快捷键
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    " setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gF <plug>(lsp-definition)
    nmap <buffer> gD <plug>(lsp-definition)
    nmap <buffer> gT <plug>(lsp-type-definition)
    nmap <buffer> gI <plug>(lsp-implementation)
    nmap <buffer> gR <plug>(lsp-references)
    nmap <buffer> gC <plug>(lsp-call-hierarchy-incoming)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gH <plug>(lsp-type-hierarchy)
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

" 手动弹出，用<C-i>就可以了
" imap <c-space> <Plug>(asyncomplete_force_refresh)
" For Vim 8 (<c-@> corresponds to <c-space>):
" imap <c-@> <Plug>(asyncomplete_force_refresh)

" 补全弹窗列表选择
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

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

" 重启服务
function! s:LspRestartServer() abort
    if &modified
        echo "No write since last change!"
    else
        LspStopServer
        sleep 100m
        let l:view = winsaveview()
        edit
        call winrestview(l:view)
    endif
endfunction

" 清理语义高亮, lsp#disable时不会自动清理
function! s:LspSemanticClear() abort
  for t in prop_type_list()
    if t =~ '^vim-lsp-semantic-'
      call prop_remove({'type': t, 'all': 1}, 1, line('$'))
    endif
  endfor
endfunction

let g:_lsp_saved_signcolumn = &signcolumn
function! s:LspEnable() abort
    let g:_lsp_saved_signcolumn = &signcolumn
    call lsp#enable()
    set signcolumn=yes
endfunction

function! s:LspDisable() abort
    call lsp#disable()
    let &signcolumn = get(g:, '_lsp_saved_signcolumn', 'auto')
    call s:LspSemanticClear()
    LspStopServer
endfunction

function! s:LspEnableFast() abort
    call s:ConfigLspFast()
    call s:LspEnable()
endfunction

function! s:LspEnableHeavy() abort
    call s:ConfigLspHeavy()
    call s:LspEnable()
endfunction

function! s:LspFast() abort
    call s:ConfigLspFast()
    call s:LspRestartServer()
endfunction

function! s:LspHeavy() abort
    call s:ConfigLspHeavy()
    call s:LspRestartServer()
endfunction

" 这个设置有bug，在重启服务后会变得特别慢
" 如果想使用fast设置，启动时调用:LspEnableFast
function! s:ConfigLspFast() abort
    let g:lsp_semantic_enabled = 0                              " 语义高亮
    let g:lsp_diagnostics_highlights_delay = 0                  " 诊断信息-延迟高亮
    let g:lsp_diagnostics_highlights_insert_mode_enabled = 0    " 诊断信息-插入模式高亮
    let g:lsp_diagnostics_signs_delay = 0                       " 诊断信息-延迟符号显示
    let g:lsp_diagnostics_signs_insert_mode_enabled = 0         " 诊断信息-插入模式侧边符号显示
endfunction

function! s:ConfigLspHeavy() abort
    let g:lsp_semantic_enabled = 1                              " 语义高亮
    let g:lsp_diagnostics_highlights_delay = 500                " 诊断信息-延迟高亮
    let g:lsp_diagnostics_highlights_insert_mode_enabled = 1    " 诊断信息-插入模式高亮
    let g:lsp_diagnostics_signs_delay = 500                     " 诊断信息-延迟符号显示
    let g:lsp_diagnostics_signs_insert_mode_enabled = 1         " 诊断信息-插入模式侧边符号显示
endfunction
" }}}
" }}}
