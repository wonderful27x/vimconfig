vim9script

# echo "My best vim == >^.^< =="

# Quick Start
# -----------
# 1) clone vim-plug for vim plugin magager
# >>>>> curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#
# 2) add your vim settings here and copy it to
# >>>>> cp .vimrc ~/
#
# 3) open your vim and run command for plugin install
# >>>>> :PlugInstall



var START_TIME = reltime()



# ========加载默认设置========
source $VIMRUNTIME/defaults.vim

# ==========override defaults.vim========== {{{
set ttimeout		# time out for key codes
set ttimeoutlen=30	# wait up to ms after Esc for special key
set scrolloff=0     	# 上下滚动时光标距离边界的偏移
# }}}



# ==========core settings========== {{{
# 启动时自动加载matchit插件，用于%配对标签间跳转, 如html标签，但是(),{}等是默认支持的
runtime macros/matchit.vim

set history=200         #设置命令回朔历史为200条，默认为50

set ignorecase          #开启大小写不敏感，作用于查找和补全
set smartcase           #开启智能大小写敏感，输入大写则匹配大写，否则使用ignorecase

set number              # 显示行号
set incsearch           # 查找是预览第一处匹配
set hlsearch            # 高亮查找匹配项

# tab settings
set tabstop=4           # tab/制表符 四个空格
set shiftwidth=4        # >> << 四个空格
set expandtab           # tab/制表符 展开为四个空格
set softtabstop=4       # 连续4个空格视为一个tab/制表符
# retab命令可以按照上面设置的规则格式化代码

# ==========file encode settings========== {{{
set fileformat=unix             #当前缓冲区用哪种换行符，写入时一致
set fileformats=unix,dos,mac    #读文件时“尝试识别”的行尾格式列表（探测顺序），并据此设置fileformat
set nobomb                      #utf-8标准格式，bomb微软用的多
set encoding=utf-8              #vim 内部使用的字符编码方式，包括缓冲区、菜单文本、消息文本等
set fileencoding=utf-8          #vim 当前编辑的文件字符编码方式，保存和新建都是这种编码格式
set fileencodings=ucs-bom,utf-8,gb18030,gbk,default,latin1
# vim启动时按照列表进行探测，并将fileencoding设置为此编码方式，
# 这很好理解，即打开文件和保存文件默认情况下应该保持编码方式不变
# 可以理解为设置vim支持的文件编码格式，类似fileformats
# }}}

# 状态栏 statusline settings
set laststatus=2
&statusline = '%<%f %h%m%r%=[%{empty(&fenc) ? &enc : &fenc},%{&ff}]    %-14.(%l,%c%V%) %P'

# tab 命令补全模式, 此模式tab会显示补全列表
set wildmenu
set wildmode=full

# 设置补全行为
# menuone: 只有一个选项也弹出
# noinsert: 不自动插入第一项
# noselect: 不自动选中第一项
# preview: 弹出预览窗口显示更多信息
set completeopt=menuone,noselect,noinsert,preview,popup
set completeopt-=noselect
set completeopt-=noinsert
set completeopt-=preview

# 插入模式和命令行模式禁用退格删除键，防止不良习惯
inoremap <backspace> <nop>
cnoremap <backspace> <nop>

# %% 映射为 %:h, 即当前活动缓冲区文件路径（去掉文件名）
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') .. '/' : '%%'

# &映射为&&, 即重复上次替换命令带flag
nnoremap & :&&<CR>
xnoremap & :&&<CR>

# " 重映射<C-d>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间,也可理解为向下翻动半页
# nnoremap <C-d> Lzz
# " 重映射<C-u>为光标指向屏幕最后一行然后执行zz, 即将屏幕最后一行显示在屏幕中间,也可理解为向上翻动半页
# nnoremap <C-u> Hzz
# 重映射<C-l>插入模式下光标右移一位
inoremap <C-l> <Right>

# space进入可视模式并选中单词
nnoremap <space> viw

# visual search for */# settings
# 可视模式按*/#对选中文本进行查询
# 注意符号:, 这是一条命令行映射，而命令行或插入模式下<C-u>代表清除至行首
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

# :nohlearch 命令暂时关闭高亮模式，直到执行新的或重复的查找命令
# <C-l>原是清屏重绘快捷键，将其和nohlearch一起作用
# nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
# 但是清屏会使屏幕闪烁一下，效果非常差，所以重映射<C-p>为暂时关闭高亮模式
# 并重映射<leader><C-l>为清屏，因为我们想将<C-l>用于其他功能
nnoremap <silent> <C-p> :<C-u>nohlsearch<CR>
nnoremap <silent> <leader><C-l> :<C-u>nohlsearch<CR><C-l>

# # 光标出的行列高亮切换，阅读代码时比较方便
# # 隐藏常规高亮并链接行与列的样式
# highlight! link CursorLine None
nnoremap <leader><space> :<C-u>call <SID>ToggleCursorHighlight()<CR>
augroup TrackWindowCursorHighlight
    autocmd!
    autocmd WinNew * TrackWindowCursorHighlight('new')
    autocmd WinLeave * TrackWindowCursorHighlight('leave')
    autocmd WinEnter,BufEnter * TrackWindowCursorHighlight('enter')
    # autocmd BufLeave * TrackWindowCursorHighlight('leave_buf')
    # autocmd BufEnter * TrackWindowCursorHighlight('enter_buf')
augroup END

# map Y to yank text from cursor to the end of line
nnoremap Y y$

# 设置快捷键将选中文本复制到系统剪切板
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <Leader>Y "+y$
# nnoremap <Leader><Leader>y "+yy
# 设置快捷键将系统剪切板内容粘贴至vim
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

# 让配置变更立即生效, 使用快捷键运行source感觉更好
# autocmd BufWritePost $MYVIMRC source $MYVIMRC
# 设置快捷键打开vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>:<c-u>resize 9999<CR>:<c-u>vertical resize 9999<CR>:echo "edit vimrc ..."<CR>
# 设置快捷键应用vimrc
nnoremap <Leader>sv :source $MYVIMRC<CR>:<C-u>nohlsearch<CR>:echo "run source vimrc ok!"<CR>

# colorscheme morning   " 设置配色方案

# ==========cursor shape and color settings========== {{{
# Set cursor shape and color
# before . setting shape, after . setting color
# 1 -> blinking block  闪烁的方块
# 2 -> solid block  不闪烁的方块
# 3 -> blinking underscore  闪烁的下划线
# 4 -> solid underscore  不闪烁的下划线
# 5 -> blinking vertical bar  闪烁的竖线
# 6 -> solid vertical bar  不闪烁的竖线
if &term =~ "xterm"
    &t_SI = "\<Esc>[1 q"    #start INSERT mode
    &t_SR = "\<Esc>[1 q"    #start REPLACE mode
    &t_EI = "\<Esc>[2 q"    #end insert or replace mode
    &t_VS = "\<Esc>[2 q"    #cursor normally visible
    # &t_SI = "\<Esc>[1 q" .. "\<Esc>]12;rgb:CD/B3/8B\x7"
    # &t_SR = "\<Esc>[1 q" .. "\<Esc>]12;rgb:CD/B3/8B\x7"
    # &t_EI = "\<Esc>[2 q" .. "\<Esc>]12;rgb:CD/B3/8B\x7"
    # &t_VS = "\<Esc>[2 q" .. "\<Esc>]12;rgb:CD/B3/8B\x7"
endif
# }}}

#==========window settings========== {{{
# set window size to 0 but not close
nnoremap <leader>x :<c-u>vertical resize 0<CR>
nnoremap <leader>X :<c-u>resize 0<CR>
# nnoremap <leader><leader>x :<c-u>resize 0<CR>
# max window size
nnoremap <leader>o :<c-u>resize 9999<CR>:<c-u>vertical resize 9999<CR>:echo "max window size"<CR>
# increase/decrease window size
nnoremap <S-Up> :<c-u>resize +1<CR>
nnoremap <S-Down> :<c-u>resize -1<CR>
nnoremap <S-Left> :<c-u>vertical resize -1<CR>
nnoremap <S-Right> :<c-u>vertical resize +1<CR>
# }}}

# ==========toggle case========== {{{
# 插入模式下转换光标前单词/字符串大小写
# inoremap <C-y> <esc>viw~gi
# inoremap <C-f> <esc>viW~gi
# 考虑命名空间god::VIM,
# 现在想在中间加一个命名空间变成god::EDITOR::VIM
# 于是编辑成这样god::editorVIM,
# 光标在editor的末尾，<C-y>将其转换为大写，可是VIM也被转换了
# 改进版本:
# inoremap <C-y> <esc>vgew~gi
# inoremap <C-f> <esc>vgEW~gi
# 但是这又引入了另一个bug, 当光标位于单词首字母时，只有光标下的字母会被转换
# 改进版本2:
# inoremap <C-y> <esc>vb~gi
# inoremap <C-f> <esc>vB~gi
# 这个版本也有问题，输入: abc y, <C-y>变成: ABC Y,
# 而且上两个版本在文本第一行首单词的转换也有问题
# 终极版本: (先插入一个零时字符*再删除）
# inoremap <C-y> *<esc>vb~f*s
# inoremap <C-f> *<esc>vB~gi<backspace>
# 上面的版本也有问题，那就是会打断.的记录，导致后续执行.命令不能获得完整表达
# 终终极版本: (1.先获取和转换单词 2.用<C-h>删除要转换的单词 " 3.重新插入转换的单词 全程没有离开插入模式，.能完美重放)
var S_toggle_case_word = ''
inoremap <silent> <C-y> <C-r>=<SID>ToggleCase("word")<CR><C-r>=<SID>DeleteToggleWord()<CR><C-r>=<SID>InsertToggleWord()<CR>
inoremap <silent> <C-f> <C-r>=<SID>ToggleCase("WORD")<CR><C-r>=<SID>DeleteToggleWord()<CR><C-r>=<SID>InsertToggleWord()<CR>
# }}}

# ==========binary cursor location========== {{{
# This is the most powerful cursor moving action created by wonderful!!!
# As its name shows the cursor moving acts in binary search mode
# <C-j> <C-k> binary move the cursor in vertical direction
# <C-h> <C-k> binary move the cursor in horizontal direction
# The cursor will always be in middle when first moving
# If you miss the target call <leader>c or just move with [h j k l] to clear the location and try again
# The binary location is especially useful when edit with which is not English,
# beacuse it will be difficult to use f to find where you want to go

var S_c_jkhl_binary_called = 0
var S_c_jkhl_col = 0

var S_v_beg = 0
var S_v_mid = 0
var S_v_end = 0
var S_v_last_p = 0

var S_h_beg = 0
var S_h_mid = 0
var S_h_end = 0
var S_h_last_p = 0

# 映射成<Plug>方便别的地方用
nnoremap <Plug>(N_BinaryLocationDown)   :<c-u>call <SID>BinaryLocationV("down", "null")<CR>
nnoremap <Plug>(N_BinaryLocationUp)     :<c-u>call <SID>BinaryLocationV("up", "null")<CR>
nnoremap <Plug>(N_BinaryLocationLeft)   :<c-u>call <SID>BinaryLocationH("left", "null")<CR>
nnoremap <Plug>(N_BinaryLocationRight)  :<c-u>call <SID>BinaryLocationH("right", "null")<CR>
# -------------------------------------------------
xnoremap <Plug>(V_BinaryLocationDown)   :<c-u>call <SID>BinaryLocationV("down", "visual")<CR>
xnoremap <Plug>(V_BinaryLocationUp)     :<c-u>call <SID>BinaryLocationV("up", "visual")<CR>
xnoremap <Plug>(V_BinaryLocationLeft)   :<c-u>call <SID>BinaryLocationH("left", "visual")<CR>
xnoremap <Plug>(V_BinaryLocationRight)  :<c-u>call <SID>BinaryLocationH("right", "visual")<CR>
# ------------------------------------------
nmap <silent> <C-j> <Plug>(N_BinaryLocationDown)
nmap <silent> <C-k> <Plug>(N_BinaryLocationUp)
nmap <silent> <C-h> <Plug>(N_BinaryLocationLeft)
nmap <silent> <C-l> <Plug>(N_BinaryLocationRight)
# -------------------------------------------------
nnoremap v vmv
xmap <silent> <C-j> <Plug>(V_BinaryLocationDown)
xmap <silent> <C-k> <Plug>(V_BinaryLocationUp)
xmap <silent> <C-h> <Plug>(V_BinaryLocationLeft)
xmap <silent> <C-l> <Plug>(V_BinaryLocationRight)
# ------------------------------------------
# nnoremap <silent> j j:<c-u>call <SID>BinaryClearFast()<CR>
# nnoremap <silent> k k:<c-u>call <SID>BinaryClearFast()<CR>
# nnoremap <silent> l l:<c-u>call <SID>BinaryClearFast()<CR>
# nnoremap <silent> h h:<c-u>call <SID>BinaryClearFast()<CR>
# 上面的方法在<C-o>的情况下会触发bug!!!
# nnoremap <silent> j <Cmd>call <SID>KEY_J()<CR>
# nnoremap <silent> k <Cmd>call <SID>KEY_K()<CR>
# nnoremap <silent> l <Cmd>call <SID>KEY_L()<CR>
# nnoremap <silent> h <Cmd>call <SID>KEY_H()<CR>
# <Cmd>需要vim9支持
nnoremap <silent> j :<c-u>call <SID>KEY_J(v:count1)<CR>
nnoremap <silent> k :<c-u>call <SID>KEY_K(v:count1)<CR>
nnoremap <silent> l :<c-u>call <SID>KEY_L(v:count1)<CR>
nnoremap <silent> h :<c-u>call <SID>KEY_H(v:count1)<CR>
nnoremap <leader>c :<c-u>call <SID>BinaryClear("false")<CR>
xnoremap <leader>c :<c-u>call <SID>BinaryClear("false")<CR>
# }}}

# ================functions================ {{{
# ==========functions for visual search for */# settings========== {{{
def VSetSearch(cmdtype: string)
    var temp = @s
    norm! gv"sy
    @/ = '\V' .. substitute(escape(@s, cmdtype .. '\'), '\n', '\\n', 'g')
    @s = temp
enddef
# }}}

# ==========functions for toggle cursor highlight========== {{{
var S_cursor_hl = v:false
var S_saved_cursorline_hl = hlget('CursorLine')
var S_saved_cursorline_option = {
    winid: -1,
    cursorline: v:false
}
# --------------------------------------
def RecoverCursorHighlight()
    highlight clear CursorLine
    hlset(S_saved_cursorline_hl)
    &l:cursorline = S_saved_cursorline_option.cursorline
    S_saved_cursorline_option.winid = -1
    S_saved_cursorline_option.cursorline = v:false
enddef

def SetCursorHighlight()
    if win_getid() != S_saved_cursorline_option.winid
        S_saved_cursorline_option.winid = win_getid()
        S_saved_cursorline_option.cursorline = &l:cursorline
    endif
    highlight! link CursorLine CursorColumn
    setlocal cursorline
enddef

def ToggleCursorHighlight()
    S_cursor_hl = !S_cursor_hl
    if S_cursor_hl
        call SetCursorHighlight()
    else
        call RecoverCursorHighlight()
    endif
enddef

def TrackWindowCursorHighlight(action: string)
    if action ==# 'new'
        call RecoverCursorHighlight()
    endif

    if S_cursor_hl
        if action ==# 'enter'
            call SetCursorHighlight()
        elseif action ==# 'leave'
            call RecoverCursorHighlight()
        endif
    endif
enddef
# }}}

# ==========functions for toggle case========== {{{
# 插入转换单词
def InsertToggleWord(): string
    return S_toggle_case_word
enddef

# 删除转换处单词
def DeleteToggleWord(): string
    var len = strlen(S_toggle_case_word)
    return repeat("\<C-h>", len)
enddef

# 光标前单词大小写转换
def ToggleCase(mode: string): string
    S_toggle_case_word = ''

    var line = getline('.')
    var pos = col('.') - 1
    var start = pos

    # '\k': iskeyword
    # '\S': non-whitespace
    var key = mode ==# 'WORD' ? '\S' : '\k'
    while start > 0 && line[start - 1] =~# key
        start -= 1
    endwhile

    if start == pos
        return ""
    endif

    var word = line[start : pos - 1]

    for char in split(word, '\zs')
        if char =~# '\u'
            S_toggle_case_word ..= tolower(char)
        else
            S_toggle_case_word ..= toupper(char)
        endif
    endfor

    return ""
enddef
# }}}

# ==========functions for binary cursor location========== {{{
def KEY_J(count: number)
    # 执行原义j, 带数量功能
    execute 'normal! ' .. count .. 'j'
    # 清理标记
    call BinaryClearFast()
enddef

def KEY_K(count: number)
    execute 'normal! ' .. count .. 'k'
    call BinaryClearFast()
enddef

def KEY_L(count: number)
    execute 'normal! ' .. count .. 'l'
    call BinaryClearFast()
enddef

def KEY_H(count: number)
    execute 'normal! ' .. count .. 'h'
    call BinaryClearFast()
enddef

def ResetV()
    S_v_beg = line('w0')
    S_v_end = line('w$') + 1
    S_v_mid = S_v_beg + (S_v_end - S_v_beg) / 2
    S_v_last_p = 0
enddef

def ResetH()
    S_h_beg = 1
    S_h_end = col('$')
    S_h_mid = S_h_beg + (S_h_end - S_h_beg) / 2
    S_h_last_p = 0
enddef

def BinaryClearFast()
    if S_c_jkhl_binary_called == 0
        return
    endif
    call ResetV()
    call ResetH()
    S_c_jkhl_binary_called = 0
    S_c_jkhl_col = 0
enddef

def BinaryClear(quiet: string)
    call ResetV()
    call ResetH()
    S_c_jkhl_binary_called = 0
    S_c_jkhl_col = 0
    if quiet !=? 'true'
        echo "Binary location has been cleared!"
    endif
enddef

def VisualMark()
    silent execute "normal! `vv``"
enddef

def BinaryLocationV(direction: string, type: string)
    if S_c_jkhl_binary_called == 0
        S_c_jkhl_col = col('.')
    endif
    S_c_jkhl_binary_called += 1

    # 窗口可见第一行变化，即窗口滚动，reset 
    var v_p = line('w0')
    if v_p != S_v_last_p
       call ResetV()
       S_c_jkhl_col = col('.')
       call cursor(S_v_mid, S_c_jkhl_col)
       S_v_last_p = v_p
       if type ==? 'visual'
           call VisualMark()
       endif
       # echo "call BinaryLocationV(\"" .. direction .. "\")" .. " -> beg: " ..  S_v_beg .. " end: " .. S_v_end .. " mid: " .. S_v_mid
       return
   endif

   if direction ==? 'down'
       S_v_beg = S_v_mid
   elseif direction ==? 'up'
       S_v_end = S_v_mid
   endif

   S_v_mid = S_v_beg + (S_v_end - S_v_beg) / 2

   call cursor(S_v_mid, S_c_jkhl_col)

   if type ==? 'visual'
       call VisualMark()
   endif

   # echo "call BinaryLocationV(\"" .. direction .. "\")" .. " -> beg: " ..  S_v_beg .. " end: " .. S_v_end .. " mid: " .. S_v_mid
enddef

def BinaryLocationH(direction: string, type: string)
    S_c_jkhl_binary_called += 1

    # 光标行发生变化，即上下移动了，reset
    var h_p = line('.')
    if h_p != S_h_last_p
        call ResetH()
        call cursor(0, S_h_mid)
        S_h_last_p = h_p
        if type ==? 'visual'
           call VisualMark()
        endif
        # echo "call BinaryLocationH(\"" .. direction .. "\")" .. " -> beg: " ..  S_h_beg .. " end: " .. S_h_end .. " mid: " .. S_h_mid
        return
    endif

    if direction ==? 'left'
        S_h_end = S_h_mid
    elseif direction ==? 'right'
        S_h_beg = S_h_mid
    endif

    S_h_mid = S_h_beg + (S_h_end - S_h_beg) / 2

    call cursor(0, S_h_mid)

    if type ==? 'visual'
       call VisualMark()
    endif

    # echo "call BinaryLocationH(\"" .. direction .. "\")" .. " -> beg: " ..  S_h_beg .. " end: " .. S_h_end .. " mid: " .. S_h_mid
enddef
# }}}
# }}}
# }}}

# ==========tools========== {{{
var S_log_seq = 0
def LogEvent(msg: string): void
    var log_dir = expand('~/logs/vim')
    if !isdirectory(log_dir)
        mkdir(log_dir, 'p')
    endif

    # var time = strftime('%H:%M:%S')
    # writefile([time .. ' ' .. msg], log_dir .. '/vim-async.log', 'a')

    # 获取微秒精度的时间差
    var us = float2nr(reltimefloat(reltime()) * 1000000)
    S_log_seq += 1
    # 格式：序号 | 微秒 | 事件
    var line = printf('[%05d] [%d] %s', S_log_seq, us, msg)
    writefile([line], log_dir .. '/vim-async.log', 'a')
enddef

# ==========schedule window========== {{{
# 全局保存 timer 和 buffer 的映射
var S_custom_schedule_window = {}

# 打开窗口并初始化, titile: 窗口标题 timer_fun: timer回调函数名 time刷新时间
def OpenCustomScheduleWindow(title: string, timer_fun: string, time: number)
    # 在下方开一个 10 行的分屏
    execute 'botright :10split'

    # 创建一个无关联的 scratch buffer
    enew
    # 设置 buffer 属性：不关联文件、不保存、关闭窗口时自动销毁(wipe)
    setlocal buftype=nofile bufhidden=wipe noswapfile
    # 禁止修改
    setlocal nomodifiable
    # 设置 buffer 名称
    execute 'file [' .. title .. ']'

    var bufnr = bufnr('%')

    # 启动 timer 刷新内容
    var timer = timer_start(time, function(timer_fun, [bufnr]), {'repeat': -1})
    S_custom_schedule_window[bufnr] = timer
    # 立即执行一次回调，不然会等待time的时间间隔
    call call(function(timer_fun), [bufnr, timer])

    # 监听 buffer 销毁（窗口关闭时自动触发）
    augroup WindowAutoCleanup
        autocmd!
        execute 'autocmd BufWipeout <buffer=' .. bufnr .. '> call OnCustomScheduleWindowClosed(' .. bufnr .. ')'
    augroup END

    # 映射 q 关闭窗口
    nnoremap <buffer> <silent> q :close<CR>
enddef

# 窗口关闭时的清理逻辑
def OnCustomScheduleWindowClosed(bufnr: number)
    if has_key(S_custom_schedule_window, bufnr)
        call timer_stop(S_custom_schedule_window[bufnr])
        call remove(S_custom_schedule_window, bufnr)
    endif
    # 可以在这里写其他清理逻辑
    # echom "自定义窗口已关闭，timer 已停止"
enddef
# }}}

# ==========async========== {{{
var S_async_tick_ctr = {
     index: 0,
     static_count: 0,
     max_loop_times: 12,
     curr_loop_times: 0,
     loop_id: 0,
     min_id: 0,
     max_id: 0,
     timeout: 0,
     start_time: ''
    }

var S_async_job_id = -1
var S_async_jobs = {}
var S_async_pause = v:false
var S_async_paused_jobs = []
var S_async_max_fill_first_time: number = 1000
# var S_async_max_fill_first_time: number = (1 << 62) - 1 + (1 << 62)

# " 子任务
# S_subjob = {
#     org: '',      "原始async命令
#     cmd: '',      "真正的program命令
#     len: '',      "cmd的长度
#     fmt: '',      "输出格式
#     fil: '',      "填充类型，none/all/out/err
#     env: '',      "是否继承vim终端env，模拟tty
#     o: '',        "命令结束后是否打开quickfix
#     m: ''         "是否显示过程和状态信息, 如果m=0, out/err会被打印
#     ts: '',       "命令执行起始时间
#     te: '',       "命令执行结束时间
#     nouts: 0,     "命令结果out数
#     nerrs: 0,     "命令结果err数
#     sts: 'uninit',"状态信息
# }

# " 每个AsyncJob包含一个subjobs列表，里面包含具体的命令参数，
# " subjob_id是当前job对象正在执行的子任务索引，当一个子任务执行结束后，
# " 如果subjobs里还有未执行的子任务，会重新创建一个job对象，同时subjob_id++
# " 注意id不会变，id是和AsyncJob绑定的，即一个AsyncJob + id + subjobs
# " 这样做是因为，有的工作可能需要多条命令才能完成，且这些命令有先后顺序
# S_async_jobs[key] = {
#     id: -1,             "job id, 每个AsyncJob对应一个id，从0开始增长
#     job: v:null,        "job对象, 真正执行外部命令的对象
#     timer: -1,          "计时器, 用于更新进度等信息
#     state: 'uninit',    "状态, 分为uninit/running/stopping/done/xdone, 用于时序控制
#     outs: [],           "标准输出
#     errs: [],           "错误输出
#     prog_idx: 0,        "进度索引
#     subjobs: [],        "子任务列表
#     subjob_id: 0        "当前子任务索引
#     job_exit: v:false   "exit_cb调用
# }

# Async异步命令，可以执行任意外部命令
# 格式: Async <...> cmd1 [...] | <...> cmd2 [...]
# | : 多条命令用|分隔, 形成一个有先后顺序的子任务的整体
# <>: 是命令前缀，可以指定命令执行后的一些行为, 如o=1表示结束后打开quickfix
#     当有多条命令时用len=num指定命令的长度，<>指定的不同行为也用|隔开，如<len=27|o=1>
# 下面是一条生成cscope的完整命令：
# Async <len=42> find . -name "*.cpp" -print > cscope.files | cscope -b -q -k -i cscope.files
#
# AsyncQuery命令用于查询正在执行的异步命令，--table以表格形式实时显示
#
# AsyncStop命令用于停止异步命令
# --id=: 任务id
# --name=: 任务的程序名
# --key=: Async的完整命令
# --all=: 停止所有任务
# --stop-way=: 停止方式['term', 'hup', 'int', 'quit', 'kill']
command! -nargs=+ -complete=customlist,AsyncComplete Async call <SID>Async(<q-args>)
command! -nargs=* AsyncQuery call <SID>AsyncQuery(<q-args>)
command! -nargs=+ -complete=customlist,AsyncStopComplete AsyncStop call <SID>AsyncStop(<q-args>)
# ------------------------------------------------------
command! -nargs=1 AsyncSleep call <SID>AsyncSleep(<q-args>)
command! -nargs=* AsyncTest call <SID>AsyncTest(<q-args>)

def AsyncTest(args: string): string
    var ts = empty(args) ? '10' : args

    # var cmd = 'Async <o=1> grep -Rn vim .'
    # var cmd = 'Async sleep ' .. ts
    # var cmd = 'Async <o=1> rg --vimgrep -H -n vim .'
    var cmd = 'Async <len=14|o=1> grep -Rn vim . | sleep ' .. ts

    execute cmd
    return cmd
enddef

def AsyncSleep(args: string): string
    var cmd = 'Async sleep ' .. args
    execute cmd
    return cmd
enddef

# 异步命令主函数
def Async(args: string)
    var cmd = args
    var subjobs = ParseAsyncArgs(args)
    var shell_cmd = [&shell, &shellcmdflag, subjobs[0].cmd]

    echom 'Async ' .. cmd
    redraw
    if len(subjobs) == 0
        echom 'Async no subjobs to run!'
        return
    endif

    # test
    # echom 'Async cmd: ' .. cmd
    # echom 'Async subjobs: '
    # echom subjobs
    # echom 'Async subjobs[0].shell_cmd: ' .. string(shell_cmd)
    # return

    if has_key(S_async_jobs, cmd)
        echom 'job for [' .. S_async_jobs[cmd].job .. "] 已存在!"
        return
    endif

    # 建字典
    var job_id = GenJobID()
    S_async_jobs[cmd] = {
        id: job_id,
        job: v:null,
        timer: -1,
        state: 'uninit',
        outs: [],
        errs: [],
        prog_idx: 0,
        subjobs: subjobs,
        subjob_id: 0,
        job_exit: v:false
    }

    # 先把timer启动起来，防止job结束过快timer还没创建
    # 每 200 毫秒更新一次状态
    call StartAsyncTimer(cmd, 200)

    # 启动异步任务, 从第0个任务开始
    call StartAsyncSubjob(cmd, 0)
enddef

def AsyncComplete(ArgLead: string, CmdLine: string, CursorPos: number): list<string>
    var options = ['<m=0>', '<o=1>', '<m=0|env=1>', '<o=1|env=1>', '<len=', '<fil=', '<fmt=']
    return filter(options, (_, v) => stridx(v, ArgLead) == 0)
enddef

def GenJobID(): number
    S_async_job_id += 1
    return S_async_job_id
enddef

def GetSubjobs(key: string): list<any>
    return S_async_jobs[key].subjobs
enddef

def GetCurrSubjob(key: string): any
    var id = S_async_jobs[key].subjob_id
    return S_async_jobs[key].subjobs[id]
enddef

def GetCurrSubjobCmd(key: string): string
    return GetCurrSubjob(key).cmd
enddef

def GetCurrSubjobProgram(key: string): string
    return split(GetCurrSubjobCmd(key))[0]
enddef

def IsLastSubJob(key: string): bool
    var subjob_size = len(GetSubjobs(key))
    return S_async_jobs[key].subjob_id == subjob_size - 1
enddef

# ==========async的启动========== {{{
# 启动一个timer
def StartAsyncTimer(key: string, tms: number)
    if GetCurrSubjob(key).m == '1'
        echo "Async-" .. GetCurrSubjobProgram(key) .. " running ... |"
    endif

    var timer = timer_start(
        tms,
        function('AsyncTick', [key]),
        {repeat: -1}
        )

    S_async_jobs[key].timer = timer
enddef

# 启动一个子任务
# subjob_id: 启动的subjob id
def StartAsyncSubjob(key: string, subjob_id: number)
    # 先reset
    S_async_jobs[key].job_exit = v:false
    S_async_jobs[key].state = 'uninit'
    S_async_jobs[key].outs = []
    S_async_jobs[key].errs = []
    S_async_jobs[key].prog_idx = 0
    # 最关键的
    S_async_jobs[key].subjob_id = subjob_id

    var curr_subjob = GetCurrSubjob(key)
    var shell_cmd = [&shell, &shellcmdflag, curr_subjob.cmd]

    curr_subjob.ts = string(reltime())

    # 异步任务
    # out_mode/err_mode: nl: 按换行符切分输出，否则可能是半行
    # out_cb : 标准输出回调
    # err_cb : 标准错误回调
    # exit_cb: 进程退出回调
    var async_job: any = v:null
    if curr_subjob.env == '1'
        # echom "has env: " .. curr_subjob.env
        async_job = job_start(shell_cmd, {
            env: environ(),
            pty: 1,
            out_mode: 'nl',
            err_mode: 'nl',
            out_cb: (ch, msg) => OnJobOut(key, ch, msg),
            err_cb: (ch, msg) => OnJobErr(key, ch, msg),
            close_cb: (ch) => OnJobClose(key, ch),
            exit_cb: (job, code) => OnJobExit(key, job, code),
        })
    else
        # echom "no env: " .. curr_subjob.env
        async_job = job_start(shell_cmd, {
            out_mode: 'nl',
            err_mode: 'nl',
            out_cb: (ch, msg) => OnJobOut(key, ch, msg),
            err_cb: (ch, msg) => OnJobErr(key, ch, msg),
            close_cb: (ch) => OnJobClose(key, ch),
            exit_cb: (job, code) => OnJobExit(key, job, code),
        })
    endif

    # var status = job_status(async_job)
    # if status ==# 'fail'
    #     echom '启动job失败(' .. status .. '): ' .. key
    #     redraw
    # else
    #     echom '启动job成功(' .. status .. '): ' .. key
    #     redraw
    # endif

    # job 对象填进字典
    # 由于OnJobExit可以在job返回前结束，所以使用一个状态来控制
    # OnJobExit是在vim进行执行的，所以和下面的逻辑是同步的
    if S_async_jobs[key].state != 'done' && S_async_jobs[key].state != 'xdone'
        S_async_jobs[key].job = async_job
        S_async_jobs[key].state = 'running'
        curr_subjob.sts = 'running'
    endif

    call UpdateTickCtr()
enddef
# }}}

# ==========async的回调及后处理========== {{{
def OnJobOut(key: string, ch: channel, msg: string)
    # OnJobExit后仍可能收到OnJobOut和OnJobErr
    if !has_key(S_async_jobs, key)
        return
    endif

    # 截断输出，注意OnJobExit后OnJobOut和OnJobErr仍然可能被调用
    # 这里截断是为了保持数据一致，实际上应该继续收集剩余才对，
    # 但是目前还没找到数据buffer处理结束的回调，close_cb官方解释是在所有数据结束后，
    # 但实际测试它甚至比OnJobExit调用还早, 这里只是权宜之计
    if S_async_jobs[key].job_exit == v:true
        return
    endif

    var subjob = GetCurrSubjob(key)

    call add(S_async_jobs[key].outs, msg)
    subjob.nouts = len(S_async_jobs[key].outs)

    # 如果out不会填充到quickfix，就打印它
    # 如果m=0也打印，因为过程信息没有了
    if subjob.m == '0' || (subjob.fil !=# 'out' && subjob.fil !=# 'all')
        # echom GetCurrSubjobProgram(key) .. ": " .. msg
        echom msg
    endif
enddef

def OnJobErr(key: string, ch: channel, msg: string)
    # OnJobExit后仍可能收到OnJobOut和OnJobErr
    if !has_key(S_async_jobs, key)
        return
    endif

    # 截断输出，同上
    if S_async_jobs[key].job_exit == v:true
        return
    endif

    var subjob = GetCurrSubjob(key)

    call add(S_async_jobs[key].errs, msg)
    subjob.nerrs = len(S_async_jobs[key].errs)

    # 如果err不会填充到quickfix，就打印它
    # 如果m=0也打印，因为过程信息没有了
    if subjob.m == '0' || (subjob.fil !=# 'err' && subjob.fil !=# 'all')
        # echom GetCurrSubjobProgram(key) .. ": " .. msg
        echom msg
    endif
enddef

# 在测试中发现OnJobClose设置了之后OnJobOut/OnJobExit
# 就不会在OnJobExit之后调用了, 而OnJobClose会在OnJobExit之前调用
def OnJobClose(key: string, ch: channel)
    # echom "!!!OnJobClose"
    # LogEvent('CLOSE')
enddef

def OnJobExit(key: string, job: job, code: number)
    # echom "!!!OnJobExit"
    # LogEvent('EXIT: ' .. code)

    if !has_key(S_async_jobs, key)
        echom 'job for [' .. key .. '] not exist!'
        return
    endif

    # echom split(key)[0] .. " exit: " .. len(S_async_jobs[key].outs) .. " + " .. len(S_async_jobs[key].errs)

    S_async_jobs[key].job_exit = v:true

    var curr_subjob = GetCurrSubjob(key)

    S_async_jobs[key].job = job
    if S_async_jobs[key].state ==# 'uinit'
        S_async_jobs[key].state = 'running'
        curr_subjob.sts = 'running'
    endif

    # 因为vim是单线程，不能真正暂停，这里是模拟暂停
    # 先将数据存起来，后面再回放
    if S_async_pause
        add(S_async_paused_jobs, {'key': key, 'job': job, 'code': code})
        return
    endif

    try
        # 如果是最后一个subjob或发送了stopping信号才停止timer
        if IsLastSubJob(key) || S_async_jobs[key].state ==# 'stopping'
            var timer = get(S_async_jobs[key], 'timer', -1)
            call StopTimer(timer, 'term')
            S_async_jobs[key].timer = -1
        endif

        # 执行后期处理任务
        call AsyncJobDone(key, code)
    finally
        # 这个方法及有可能出bug
        # call AsyncContinue()

        # 更新状态
        var finish_type = S_async_jobs[key].state ==# 'stopping' ? 'xdone' : 'done'
        S_async_jobs[key].state = finish_type
        curr_subjob.sts = finish_type
        var ts_list = eval(curr_subjob.ts)
        var time = printf('%.1f', reltimefloat(reltime(ts_list)))
        curr_subjob.te = time

        if IsLastSubJob(key) || S_async_jobs[key].state ==# 'stopping'
            # 如果是最后一个subjob或发送了停止命令清理整个AsyncJob
            call remove(S_async_jobs, key)
        else
            # 如果不是最后一个subjob，启动一个新的job执行后续任务
            if curr_subjob.m == '1'
                echo "Async-" .. GetCurrSubjobProgram(key) .. " running ... |"
            endif
            var subjob_id = S_async_jobs[key].subjob_id + 1
            call StartAsyncSubjob(key, subjob_id)
        endif
    endtry
enddef

def AsyncJobDone(key: string, code: number)
    var subjob = GetCurrSubjob(key)

    if subjob.m == '1'
        echom "Async-" .. GetCurrSubjobProgram(key) .. " finish(" .. string(code) .. "). Processing data ..."
    endif

    # call EchoMsg(S_async_jobs[key].outs)
    # call EchoMsg(S_async_jobs[key].errs)

    var num = AsyncDataProcess(key, code)
    var finish_type = S_async_jobs[key].state ==# 'stopping' ? ' xdone | ' : ' done | '
    var ts_list = eval(subjob.ts)
    var time = printf('%.1f', reltimefloat(reltime(ts_list)))

    if subjob.m == '1'
        echom "Async-" .. GetCurrSubjobProgram(key) .. finish_type .. num.n_outs .. " outs + " .. num.n_errs .. ' errs | ' .. time .. 's'
    endif
enddef

def SetQuickfixList(title: string, lines: list<string>, format: string, action: string)
    var n = strcharlen(title)
    var short_title = n > 100
        ? strcharpart(title, 0, 30) .. ' ... ' .. strcharpart(title, n - 70, 70)
        : title

    if !empty(format)
        call setqflist([], action, {
            title: short_title,
            lines: lines,
            efm: format
        })
    else
        setqflist([], action, {
            title: short_title,
            items: mapnew(lines, (_, line) => ({text: line}))
        })
    endif
enddef

def AsyncDataProcessRest(key: string, outs: list<string>, errs: list<string>)
    var subjob = GetCurrSubjob(key)

    if subjob.fil ==? 'err' && !empty(errs)
        call SetQuickfixList(subjob.cmd, errs, subjob.fmt, 'a')
    elseif subjob.fil ==? 'out' && !empty(outs)
        call SetQuickfixList(subjob.cmd, outs, subjob.fmt, 'a')
    elseif subjob.fil ==? 'all'
        if !empty(errs)
            call SetQuickfixList(subjob.cmd, errs, subjob.fmt, 'a')
        endif
        if !empty(outs)
            call SetQuickfixList(subjob.cmd, outs, subjob.fmt, 'a')
        endif
    elseif subjob.fil ==? 'asp'
        if !empty(outs)
            call SetQuickfixList(subjob.cmd, outs, subjob.fmt, 'a')
        endif
        if !empty(errs)
            # asp模式下outs和errs是分开的，如果outs非空，说明errs还没有填入
            if !empty(outs)
                call SetQuickfixList(subjob.cmd, errs, subjob.fmt, ' ')
            else
                call SetQuickfixList(subjob.cmd, errs, subjob.fmt, 'a')
            endif
        endif
    endif
enddef

def AsyncDataProcess(key: string, code: number): any
    # var ts = reltime()

    var subjob = GetCurrSubjob(key)

    var errs = []
    var outs = []
    var max_fill: number = S_async_max_fill_first_time
    # 如果指定了具体格式, 过滤空项
    if !empty(subjob.fmt)
        errs = filter(S_async_jobs[key].errs, '!empty(v:val)')
        outs = filter(S_async_jobs[key].outs, '!empty(v:val)')
    else
        errs = S_async_jobs[key].errs
        outs = S_async_jobs[key].outs
        # 如果没有指定格式设置为最大值，即首次全部填充，因为速度是很快的
        max_fill = (1 << 62) - 1 + (1 << 62)
    endif
    # 如果当前有多个job，全部填充，防止等待用户决定加载剩余数据时
    # 后续的任务到来打乱时序，造成quickfix的混乱
    if len(S_async_jobs) > 1
        max_fill = (1 << 62) - 1 + (1 << 62)
    endif

    if subjob.fil ==? 'none'
        return {'n_outs': len(outs), 'n_errs': len(errs)}
    endif

    # 如果大于最大首次填充数，第一次只填充最大的一半，剩下的让用户决定是否继续填充
    # 因为10000条数据需要10s，会导致ui卡住，用户不知道发生了什么，体验很差
    var outs_fill_len = 0
    var errs_fill_len = 0
    var outs_bg = 0
    var errs_bg = 0
    var filled_len = 0

    var filled = v:false
    if subjob.fil ==? 'err' && !empty(errs)
        errs_fill_len = len(errs) > max_fill ? max_fill / 2 : len(errs)
        var errs_sub_list = slice(errs, errs_bg, errs_bg + errs_fill_len)
        call SetQuickfixList(subjob.cmd, errs_sub_list, subjob.fmt, ' ')
        # 计算下次的
        filled_len = errs_fill_len
        errs_bg += errs_fill_len
        errs_fill_len = len(errs) - errs_bg

        filled = v:true
    elseif subjob.fil ==? 'out' && !empty(outs)
        outs_fill_len = len(outs) > max_fill ? max_fill / 2 : len(outs)
        var outs_sub_list = slice(outs, outs_bg, outs_bg + outs_fill_len)
        call SetQuickfixList(subjob.cmd, outs_sub_list, subjob.fmt, ' ')
        # 计算下次的
        filled_len = outs_fill_len
        outs_bg += outs_fill_len
        outs_fill_len = len(outs) - outs_bg

        filled = v:true
    elseif subjob.fil ==? 'all' && (!empty(errs) || !empty(outs))
        if (len(errs) + len(outs)) > max_fill
            # 这种情况二者之和只能是最大的一半
            errs_fill_len = len(errs) > max_fill / 2 ? max_fill / 2 : len(errs)
            var errs_sub_list = slice(errs, errs_bg, errs_bg + errs_fill_len)
            call SetQuickfixList(subjob.cmd, errs_sub_list, subjob.fmt, ' ')
            # outs补充那一半剩下的部分
            outs_fill_len = max_fill / 2 - errs_fill_len
            outs_fill_len = len(outs) < outs_fill_len ? len(outs) : outs_fill_len
            var outs_sub_list = slice(outs, outs_bg, outs_bg + outs_fill_len)
            call SetQuickfixList(subjob.cmd, outs_sub_list, subjob.fmt, 'a')

            # 计算下次的
            filled_len = errs_fill_len + outs_fill_len
            errs_bg += errs_fill_len
            errs_fill_len = len(errs) - errs_bg
            outs_bg += outs_fill_len
            outs_fill_len = len(outs) - outs_bg
        else
            # 这种情况说明二者全部填完
            call SetQuickfixList(subjob.cmd, errs, subjob.fmt, ' ')
            call SetQuickfixList(subjob.cmd, outs, subjob.fmt, 'a')
            filled_len = len(errs) + len(outs)
        endif
        filled = v:true
    elseif subjob.fil ==? 'asp'
        if (len(errs) + len(outs)) > max_fill
            # 这种情况二者之和只能是最大的一半
            outs_fill_len = len(outs) > max_fill / 2 ? max_fill / 2 : len(outs)
            var outs_sub_list = slice(outs, outs_bg, outs_bg + outs_fill_len)
            if outs_fill_len > 0
                call SetQuickfixList(subjob.cmd, outs_sub_list, subjob.fmt, ' ')
            endif

            # errs补充那一半剩下的部分
            errs_fill_len = max_fill / 2 - outs_fill_len
            errs_fill_len = len(errs) < errs_fill_len ? len(errs) : errs_fill_len
            var errs_sub_list = slice(errs, errs_bg, errs_bg + errs_fill_len)
            # 如果本次errs需要填，或者outs恰好填完errs下次还需要填
            if errs_fill_len > 0 || (len(outs) - outs_fill_len == 0 && len(errs) > 0)
                call SetQuickfixList(subjob.cmd, errs_sub_list, subjob.fmt, ' ')
            endif

            # 计算下次的
            filled_len = outs_fill_len + errs_fill_len
            outs_bg += outs_fill_len
            outs_fill_len = len(outs) - outs_bg
            errs_bg += errs_fill_len
            errs_fill_len = len(errs) - errs_bg
        else
            # 这种情况说明二者全部填完
            if !empty(outs)
                call SetQuickfixList(subjob.cmd, outs, subjob.fmt, ' ')
            endif
            if !empty(errs)
                call SetQuickfixList(subjob.cmd, errs, subjob.fmt, ' ')
            endif
            filled_len = len(errs) + len(outs)
        endif
        if !empty(outs) || !empty(errs)
            filled = v:true
        endif
    endif

    # var te = printf('%.1f', reltimefloat(reltime(ts)))
    # echom "AsyncDataProcess cost: " .. te .. 's'

    # 打开窗口
    if subjob.o == '1'  && filled
        botright copen
    endif

    if outs_fill_len > 0 || errs_fill_len > 0
        var msg = "Async-" .. split(subjob.cmd)[0] .. ' finish(' .. string(code) .. ') | '
            .. string(filled_len) .. ' loaded, ' .. '是否加载剩余 ' .. string(outs_fill_len + errs_fill_len) .. ' 行？'
        redraw

        # 等待用户输入时，后面的任务可能在这期间结束，
        # 然后修改quickfix, 时序出现问题，所以
        # 先暂停其他任务, 但后续的恢复有bug, 目前还没有好的解决方案
        # call AsyncPause()

        var answer = tolower(trim(input(msg .. ' (yes/no): ')))
        if answer == 'yes' || answer == 'y'
            echom "Async-" .. split(subjob.cmd)[0] .. " data processing ..."
            var outs_sub_list = slice(outs, outs_bg, outs_bg + outs_fill_len)
            var errs_sub_list = slice(errs, errs_bg, errs_bg + errs_fill_len)
            call AsyncDataProcessRest(key, outs_sub_list, errs_sub_list)

            # 放这里肯定不行，后面exit的会在当前exit之前完成工作, 时序是不对的，
            # call AsyncContinue()
        endif

        # var choice = confirm(msg, "&Yes\n&No", 1)
        # if choice == 1
        #     echom "Async-" .. split(subjob.cmd)[0] .. " data processing ..."
        #     var outs_sub_list = slice(outs, outs_bg, outs_bg + outs_fill_len)
        #     var errs_sub_list = slice(errs, errs_bg, errs_bg + errs_fill_len)
        #     call AsyncDataProcessRest(key, outs_sub_list, errs_sub_list)

        #     # 放这里肯定不行，后面exit的会在当前exit之前完成工作, 时序是不对的，
        #     # call AsyncContinue()
        # endif
    endif

    return {'n_outs': len(outs), 'n_errs': len(errs)}
enddef

def EchoMsg(lines: list<string>)
    for line in lines
        echom line
    endfor
enddef

def AsyncPause()
    S_async_pause = v:true
enddef

def AsyncContinue()
    # 先置为false，否则会循环导致卡死, 但是这样又会漏掉到来的exit任务!!!
    # 单个pause似乎会被不同的subjob修改，
    # 这是糟糕的，要不就不要兼容这种情况了
    S_async_pause = v:false
    while !empty(S_async_paused_jobs)
        # 永远取第 0 个元素
        var item = S_async_paused_jobs[0]
        # 先删除，否则OnJobExit又会调用AsyncContinue导致无限循环
        remove(S_async_paused_jobs, 0)
        
        call OnJobExit(item.key, item.job, item.code)
    endwhile
enddef
# }}}

# ==========timer tick进度状态========== {{{
def UpdateTickCtr()
    # 更新最大最小值
    var ids = map(values(S_async_jobs), 'v:val.id')
    S_async_tick_ctr.min_id = min(ids)
    S_async_tick_ctr.max_id = max(ids)
    # 限制范围
    if S_async_tick_ctr.loop_id < min(ids)
        S_async_tick_ctr.loop_id = min(ids)
    endif
    if S_async_tick_ctr.loop_id > max(ids)
        S_async_tick_ctr.loop_id = max(ids)
    endif
    # 如果当前loop_id不等于任何一个任务id就更新它
    if index(ids, S_async_tick_ctr.loop_id) < 0
        S_async_tick_ctr.loop_id = ids[0]
    endif
enddef

def PauseAsyncTick(timems: number)
    S_async_tick_ctr.timeout = timems
    S_async_tick_ctr.start_time = string(reltime())
enddef

def AsyncTick(key: string, timer: number)
    # stop and remove后可能仍然收到回调
    if !has_key(S_async_jobs, key)
        return
    endif

    # 检查 Vim 是否处于 more-prompt 或 hit-enter prompt 状态
    if state('s') != ''
        return
    endif

    # mode() ==# 'c' 表示正在命令行模式
    # 或者 getcmdline() 非空表示已经在输入内容
    if mode() ==# 'c' || !empty(getcmdline())
        return
    endif

    # 整体暂停
    if S_async_pause
        return
    endif

    # 暂停控制
    if S_async_tick_ctr.timeout > 0
        var st_list = eval(S_async_tick_ctr.start_time)
        var time_ms = float2nr(reltimefloat(reltime(st_list)) * 1000)
        if time_ms < S_async_tick_ctr.timeout
            return
        else
            S_async_tick_ctr.timeout = 0
        endif
    endif

    # ==================================================================
    # 每个job都有一个timer，如果不加控制地更新状态
    # 不同job的信息会在命令快速交替显示，效果很差
    # 引入轮询循环控制，每个job完成一个循环显示后才切换到下一个job的显示
    # S_async_tick_ctr做的就是这件事
    # ------------------------------------------------------------------
    # echom "min_id: " .. S_async_tick_ctr.min_id
    #              \ .. " max_id: " .. S_async_tick_ctr.max_id
    #              \ .. " loop_id:" .. S_async_tick_ctr.loop_id
    #              \ .. " max_loop_times:" .. S_async_tick_ctr.max_loop_times
    #              \ .. " curr_loop_times:" .. S_async_tick_ctr.curr_loop_times
    #              \ .. " static_count:" .. S_async_tick_ctr.static_count

    # 如果不是当前循环id
    # TODO 多测下，似乎有卡住的bug!!!
    if S_async_tick_ctr.loop_id != S_async_jobs[key].id
        S_async_tick_ctr.static_count += 1
        if S_async_tick_ctr.static_count > len(S_async_jobs)
            # 如何很久没有变化了，更新一下防止其中一个退出导致无法驱动loop
            call UpdateTickCtr()
        endif
        return
    endif

    # 驱动一次更新
    S_async_tick_ctr.static_count = 0
    call UpdateTickCtr()

    # 当前id循环结束，切换到下一个循环id
    S_async_tick_ctr.curr_loop_times += 1
    if S_async_tick_ctr.curr_loop_times == S_async_tick_ctr.max_loop_times - 1
        S_async_tick_ctr.curr_loop_times = 0
        S_async_tick_ctr.loop_id += 1
        if S_async_tick_ctr.loop_id > S_async_tick_ctr.max_id
            S_async_tick_ctr.loop_id = S_async_tick_ctr.min_id
        endif
    endif
    # ==================================================================

    # 执行一次状态更新
    var chars = ['|', '/', '-', '\']

    # S_async_jobs[key].prog_idx = (S_async_jobs[key].prog_idx + 1) % len(chars)
    # 在timer的回调中，echo后面不要有任何代码，否则光标会闪烁!!!
    # if GetCurrSubjob(key).m
    #     echo 'Async-' .. GetCurrSubjobProgram(key) .. ' running ... ' .. chars[S_async_jobs[key].prog_idx]
    # endif

    S_async_tick_ctr.index = (S_async_tick_ctr.index + 1) % len(chars)
    # 在timer的回调中，echo后面不要有任何代码，否则光标会闪烁!!!

    if GetCurrSubjob(key).m == '1'
        echo 'Async-' .. GetCurrSubjobProgram(key) .. ' running ... ' .. chars[S_async_tick_ctr.index]
    endif
enddef
# }}}

# ==========async的停止========== {{{
def StopTimer(timer: number, stop_way: string)
    # 1. 检查 timer 是否存在且有效
    if timer == -1
        return
    endif

    # 2. 检查 timer 是否还在运行, 停止它
    try
        call timer_stop(timer)
    catch
        echohl ErrorMsg
        echomsg v:exception
        echohl None
    endtry
enddef

def StopJob(job: job, stop_way: string)
    # 1. 检查 job 是否存在且有效
    if job is v:null
        return
    endif

    # 2. 检查 job 是否还在运行, 停止它
    try
        if job_status(job) ==# 'run'
            call job_stop(job, stop_way)
        endif
    catch
        echohl ErrorMsg
        echomsg v:exception
        echohl None
    endtry
enddef

def StopAsyncJob(async_job: any, stop_way: string)
    if empty(async_job)
        return
    endif

    async_job.state = 'stopping'

    # 停止timer
    var timer = get(async_job, 'timer', -1)
    call StopTimer(timer, stop_way)
    async_job.timer = -1

    # 停止job
    var job = get(async_job, 'job', v:null)
    call StopJob(job, stop_way)
    async_job.job = v:null

    # 清理字典条目, 不需要在这里清理，exit callback通常会执行，哪怕是kill
    # call remove(S_async_jobs, key)
enddef

def FindAsyncJobById(id: number): any
    for [key, data] in items(S_async_jobs)
        if data.id ==# id
            return data
        endif
    endfor
    return {}
enddef

def StopAsyncJobAll(stop_way: string)
    for [key, data] in items(S_async_jobs)
        call StopAsyncJob(data, stop_way)
    endfor
enddef

def StopAsyncJobWithId(id: number, stop_way: string)
    var async_job = FindAsyncJobById(id)
    call StopAsyncJob(async_job, stop_way)
enddef

def StopAsyncJobWithKey(key: string, stop_way: string)
    if !has_key(S_async_jobs, key)
        return
    endif
    call StopAsyncJob(S_async_jobs[key], stop_way)
enddef

def StopAsyncJobWithName(name: string, stop_way: string)
    for [key, data] in items(S_async_jobs)
        var program = GetCurrSubjobProgram(key)
        if program ==# name
            call StopAsyncJob(data, stop_way)
        endif
    endfor
enddef

def AsyncStop(args: string)
    var id = matchstr(args, '\%(^\|\s\)--id=\zs\S\+')
    var key = matchstr(args, '\%(^\|\s\)--key=\zs\S\+')
    var name = matchstr(args, '\%(^\|\s\)--name=\zs\S\+')
    var stop_way = matchstr(args, '\%(^\|\s\)--stop-way=\zs\S\+')
    if empty(stop_way)
        stop_way = 'term'
    endif

    if !empty(id)
        call StopAsyncJobWithId(str2nr(id), stop_way)
    endif

    if !empty(key)
        call StopAsyncJobWithKey(key, stop_way)
    endif

    if !empty(name)
        call StopAsyncJobWithName(name, stop_way)
    endif

    if index(split(args), '--all') >= 0
        call StopAsyncJobAll(stop_way)
    endif
enddef

# 定义补全函数
def AsyncStopComplete(arglead: string, cmdline: string, cursorpos: number): list<string>
    # 检查是否正在补全 --stop-way= 的值
    if arglead =~# '^--stop-way='
        # 提取 = 后面的部分（用户已经输入的值前缀，比如 'k'）
        var prefix = substitute(arglead, '^--stop-way=', '', '')
        var stop_ways = ['term', 'hup', 'int', 'quit', 'kill']
        # 过滤出匹配的项
        var matches = filter(copy(stop_ways), (_, v) => stridx(v, prefix) == 0)
        # 【关键】把前缀拼回去，返回完整的参数
        return map(matches, '"--stop-way=" .. v:val')
    endif
    # 否则补全选项名
    var options = ['--id=', '--key=', '--name=', '--stop-way=', '--all']
    return filter(copy(options), (_, v) => stridx(v, arglead) == 0)
enddef
# }}}

# ==========async 命令参数处理========== {{{
# 根据命令获取默认参数的subjob
def GetDefaultSubJob(cmd: string, last: bool): dict<any>
    var default_job = {
        org: '',
        cmd: cmd,
        len: string(strchars(cmd)),
        fmt: '',
        fil: 'all',
        env: '',
        o: '0',
        m: '1',
        ts: '',
        te: '',
        nouts: 0,
        nerrs: 0,
        sts: 'uinit'
        }

    var program = split(cmd)[0]
    if program ==# 'grep'
        default_job.fmt = '%f:%l:%m'
        default_job.fil = 'out'
        default_job.o = last ? '1' : default_job.o
    elseif program ==# 'rg'
        default_job.fmt = '%f:%l:%c:%m'
        default_job.fil = 'out'
        default_job.o = last ? '1' : default_job.o
    endif
    return default_job
enddef

# 将async命令的参数解析成subjobs
def ParseAsyncArgs(args: string): list<dict<any>>
    var subjobs = []
    var cmdlist = SplitAsyncArgs(args)
    for i in range(len(cmdlist))
        var last: bool = (i == len(cmdlist) - 1)
        var cmd = cmdlist[i]
        # 获取默认参数的subjob
        var subjob = GetDefaultSubJob(cmd.cmd, last)

        # 从设置的命令更新参数
        var org = empty(cmd.pre_cmd) ? cmd.cmd : cmd.pre_cmd .. ' ' .. cmd.cmd
        var cmd_ctr = GetCtrFromPrecmd(cmd.pre_cmd)
        # ---------------------------------------------
        subjob.org = org
        subjob.cmd = cmd.cmd
        subjob.len = string(strchars(cmd.cmd))
        if !empty(cmd_ctr.fmt)
            subjob.fmt = cmd_ctr.fmt
        endif
        if !empty(cmd_ctr.fil)
            subjob.fil = cmd_ctr.fil
            if cmd_ctr.fil !=# 'none'
                && cmd_ctr.fil !=# 'out'
                && cmd_ctr.fil !=# 'err'
                && cmd_ctr.fil !=# 'all'
                echom "Warning: only support fil=[none/out/err/all], but is " .. subjob.fil
            endif
        endif
        if !empty(cmd_ctr.env)
            subjob.env = cmd_ctr.env
        endif
        if !empty(cmd_ctr.o)
            subjob.o = cmd_ctr.o
        endif
        if !empty(cmd_ctr.m)
            subjob.m = cmd_ctr.m
        endif

        # 加入到列表
        call add(subjobs, subjob)
    endfor

    return subjobs
enddef

# 从<...|...>中解析出fmt、o等参数
def GetCtrFromPrecmd(pre_cmd: string): any
    var cmd_ctr = {'fmt': '', 'fil': '', 'env': '', 'o': '', 'm': ''}

    if pre_cmd !~# '^<.*>$'
        return cmd_ctr
    endif

    # 去掉首尾的 < >
    var content = strcharpart(pre_cmd, 1, strchars(pre_cmd) - 2)

    for field in split(content, '|', 1)
        if field =~# '^fmt='
            cmd_ctr.fmt = strpart(field, strlen('fmt='))
        elseif field =~# '^fil='
            cmd_ctr.fil = strpart(field, strlen('fil='))
        elseif field =~# '^env='
            cmd_ctr.env = strpart(field, strlen('env='))
        elseif field =~# '^o='
            cmd_ctr.o = strpart(field, strlen('o='))
        elseif field =~# '^m='
            cmd_ctr.m = strpart(field, strlen('m='))
        endif
    endfor

    return cmd_ctr
enddef

# 分割async命令参数 [{pre_cmd=<...> cmd=...}]
def SplitAsyncArgs(args: string): list<dict<string>>
    var s = args
    var total = strchars(s)
    var i = 0
    var result = []

    while i < total
        # 1. 找到第一个非空字符
        while i < total && strcharpart(s, i, 1) =~# '^\s$'
            i += 1
        endwhile
        if i >= total
            break
        endif

        # 不以 < 开头：从当前位置到末尾，整体作为 cmd
        if strcharpart(s, i, 1) !=# '<'
            add(result, {
                pre_cmd: '',
                cmd: strcharpart(s, i)
                })
            break
        endif

        # 2. 读取整个 <...>，作为 pre_cmd
        var pre_start = i
        while i < total && strcharpart(s, i, 1) !=# '>'
            i += 1
        endwhile
        if i >= total
            throw 'SplitAsyncArgs: 缺少 >'
        endif

        var pre_cmd = strcharpart(s, pre_start, i - pre_start + 1)
        var options = strcharpart(s, pre_start + 1, i - pre_start - 1)
        i += 1

        # | 分割 <...> 的内容，查找 len=数字
        var len_text = ''
        for field in split(options, '|', 1)
            var value = matchstr(field, '^len=\zs[0-9]\+$')
            if !empty(value)
                len_text = value
                break
            endif
        endfor

        # 3. 找到 <...> 之后 cmd 的第一个非空字符
        while i < total && strcharpart(s, i, 1) =~# '^\s$'
            i += 1
        endwhile
        if i >= total
            throw 'SplitAsyncArgs: <...> 之后缺少命令'
        endif

        # 没有 len：cmd 一直取到末尾
        if empty(len_text)
            add(result, {
                pre_cmd: pre_cmd,
                cmd: strcharpart(s, i)
            })
            break
        endif

        # len：按指定字符数截取 cmd
        var cmd_len = str2nr(len_text)
        if cmd_len <= 0 || i + cmd_len > total
            throw 'SplitAsyncArgs: len 无效或命令长度不足'
        endif

        call add(result, {
            pre_cmd: pre_cmd,
            cmd: strcharpart(s, i, cmd_len)
            })
        i += cmd_len

        # 4. 截取完 cmd 后，跳过空白并查找分隔符 |
        while i < total && strcharpart(s, i, 1) =~# '^\s$'
            i += 1
        endwhile
        if i >= total
            break
        endif
        if strcharpart(s, i, 1) !=# '|'
            throw 'SplitAsyncArgs: 命令之后缺少分隔符 |'
        endif
        i += 1

        # 分隔符后不能只有空白
        var next = i
        while next < total && strcharpart(s, next, 1) =~# '^\s$'
            next += 1
        endwhile
        if next >= total
            throw 'SplitAsyncArgs: 分隔符 | 之后缺少命令'
        endif
    endwhile

    return result
enddef

# 将多条命令合并成一条
# 完整的async命令格式: Async <...> cmd1 [...] | <...> cmd2 [...]
# 如: Async <len=42> find . -name "*.cpp" -print > cscope.files | <len=31|fmt=%f:%l:%m,%f:%l:%c:%m|o=1> cscope -b -q -k -i cscope.files
# <...>是命令前缀，'<...> '后跟具体命令, 多条命令用|隔开
# 命令前缀用来指定命令额外的一些行为，多个行为也用|隔开, 其中:
# len: 指定了命令的长度, 多条命令拼接时需要
# fmt: 指定命令输出的格式
# o  : 指定命令结束后是否打开quickfix
def MergeAsyncCmd(cmds: list<string>): string
    if len(cmds) == 0
        return ''
    elseif len(cmds) == 1
        return cmds[0]
    endif

    var merge_cmd = 'Async '

    for i in range(len(cmds))
        var cmd = cmds[i]

        # 去掉前面的Async
        var rcmd = trim(substitute(cmd, '^\s*\S\+', '', ''))
        # 注意这里必须用strchars, 如果用len则不等于字符数
        var opt_len = '<len=' .. strchars(rcmd) .. '> '

        if i == len(cmds) - 1
            # 最后一项
            merge_cmd = merge_cmd .. rcmd
        else
            merge_cmd = merge_cmd .. opt_len .. rcmd .. ' | '
        endif

    endfor

    return merge_cmd
enddef
# }}}

# ==========async 任务查询========== {{{
def AsyncQuery(args: string)
    var time: number = 1000
    var time_str = matchstr(args, '\%(^\|\s\)--time=\zs\S\+')
    if !empty(time_str)
        time = str2nr(time_str)
    endif

    if index(split(args), '--table') >= 0 || index(split(args), '--tab') >= 0
        call OpenCustomScheduleWindow('Async jobs', 'ScheduleAsyncQuery', time)
    else
        # simple模式
        var msg = ''
        for [key, data] in items(S_async_jobs)
            msg = msg .. data.id .. '-' .. GetCurrSubjobProgram(key) .. ' '
        endfor
        if !empty(msg)
            call PauseAsyncTick(5000)
            echom 'Async jobs [id-name]: ' .. msg
        else
            echom 'No async job running!'
        endif
    endif
enddef

# command! -nargs=0 AsyncQ call OpenCustomScheduleWindow('Async jobs', 's:ScheduleAsyncQuery', 200)
# 查询Async异步任务
def ScheduleAsyncQuery(bufnr: number, timer: number)
    # 如果 buffer 已经不存在了，停掉 timer
    if !bufexists(bufnr)
        call timer_stop(timer)
        return
    endif

    # 如果 buffer 不在任何窗口显示了，也可以停掉 timer
    if empty(win_findbuf(bufnr))
        call timer_stop(timer)
        return
    endif

    # if empty(S_async_jobs)
    #   return
    # endif

    var async_job_msg = []
    var msg = printf("id  subjob-id   name        state       time(s)     outs    errs    cmd")
    call add(async_job_msg, msg)
    for [key, data] in items(S_async_jobs)

        # 注意：ScheduleAsyncQuery是在Timer中的定时任务
        # 获取到的job有可能尚未初始化
        if data.state ==# 'uninit'
            continue
        endif

        for i in range(len(data.subjobs))
            # 这里的subjob可能是正在排队的任务
            var subjob = data.subjobs[i]
            var time = subjob.te
            if empty(time)
                if empty(subjob.ts)
                    time = '0.0'
                else
                    var ts_list = eval(subjob.ts)
                    time = printf('%.1f', reltimefloat(reltime(ts_list)))
                endif
            endif

            var nouts = subjob.nouts
            var nerrs = subjob.nerrs
            msg = printf("%-2d\t\t%-2d\t\t%-8s\t%-8s\t%-5s\t\t%-7d\t%-7d\t%s",
                        data.id, i, split(subjob.cmd)[0], subjob.sts, time, nouts, nerrs, subjob.cmd)

            call add(async_job_msg, msg)
        endfor
    endfor
    call sort(async_job_msg, 'SortByIdStr')

    # 临时解除不可修改状态，填入内容
    call setbufvar(bufnr, '&modifiable', 1)

    # 清空并写入新内容
    silent call deletebufline(bufnr, 1, '$')
    call setbufline(bufnr, 1, async_job_msg)

    # 恢复不可修改状态
    call setbufvar(bufnr, '&modifiable', 0)
enddef

def SortByIdStr(item1: string, item2: string): number
    # 提取第一段作为 id，转成数字比较
    var id1 = str2nr(split(item1)[0])
    var id2 = str2nr(split(item2)[0])
    return id1 - id2
enddef
# }}}
# }}}
# }}}

# ==========nocore settings========== {{{
# ==========format settings========== {{{
def SetClangFormatPrg()
    # 如果有.clang-format就优先使用，否则使用--fallback-style
    var name = expand('%:t')
    &l:formatprg = 'clang-format --style=file --fallback-style=Mozilla'
        .. ' --assume-filename='
        .. shellescape(empty(name) ? (&l:filetype ==# 'cpp' ? 'stdin.cpp' : 'stdin.c') : name)
enddef

augroup doc_format
    autocmd!
    autocmd FileType c,cpp SetClangFormatPrg()
augroup END

# style: LLVM Google Chromium Mozilla WebKit Microsoft GNU None
var S_formatters = [
    'LLVM',
    'Google',
    'Chromium',
    'Mozilla',
    'WebKit',
    'Microsoft',
    'GNU',
    'None',
    ]

# 格式化, 缩进依赖于 tabstop shiftwidth expandtab
def DocumentFormat(firstl: number, lastl: number, style: string)
    var saved_fp = &l:formatprg

    if !empty(style)
        var base_style = ''
        var brace_style = ''

        if style ==? 'linux'
            base_style = 'LLVM'
            brace_style = 'BreakBeforeBraces: Linux'
        elseif index(S_formatters, style) >= 0
            base_style = style
            brace_style = ''
        else
            echo 'Unknown format style: ' .. style
            return
        endif

        # shiftwidth 为 0 时，使用 tabstop
        var indent_width = &l:shiftwidth > 0 ? &l:shiftwidth : &l:tabstop

        var use_tab = &l:expandtab ? 'Never' : 'ForIndentation'

        var style_str = printf('{BasedOnStyle: %s, IndentWidth: %d, TabWidth: %d, UseTab: %s%s}',
              base_style,
              indent_width,
              &l:tabstop,
              use_tab,
              empty(brace_style) ? '' : ', ' .. brace_style)

        var cmd = 'clang-format --style=' .. shellescape(style_str)

        var filename = expand('%:t')
        if empty(filename)
            filename = &l:filetype ==# 'cpp' ? 'stdin.cpp' : 'stdin.c'
        endif

        cmd ..= ' --assume-filename=' .. shellescape(filename)
        &l:formatprg = cmd
    endif

    try
        execute 'normal! ' .. firstl .. 'Ggq' .. lastl .. 'G'
    finally
        &l:formatprg = saved_fp
    endtry
enddef


# 命令补全函数
def FormatComplete(ArgLead: string, CmdLine: string, CursorPos: number): list<string>
    var styles = ['Linux'] + S_formatters
    var result = []

    for style in styles
        if strpart(style, 0, strlen(ArgLead)) ==# ArgLead
            call add(result, style)
        endif
    endfor

    return result
enddef

# 格式化命令映射, 不带参数则使用doc_format中的默认设置,
# 这将使.clang-format成为第一优先级
# :Format [linux/Mozilla/...]           格式化整个文件
# :'<,'>Format [linux/Mozilla/...]      格式化选中的行
# command! -range=% -nargs=? Format call <SID>DocumentFormat(<line1>, <line2>, <q-args>)
command! -range=% -nargs=? -complete=customlist,FormatComplete Format
      \ call DocumentFormat(<line1>, <line2>, <q-args>)
# }}}

# ==========fold settings========== {{{
# no fold when open file
set foldlevelstart=99

# vim fold setting
augroup fold_filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

# # cpp fold setting
# augroup fold_filetype_cpp
#     autocmd!
#     autocmd FileType c,cpp setlocal foldmethod=manual "手动折叠，性能最好
#     " autocmd FileType c,cpp setlocal foldmethod=indent "缩进折叠
#     " autocmd FileType c,cpp setlocal foldmethod=syntax "一些版本的vim可能造成无法忍受的卡顿!!!
# augroup END

# syntax模式下计算并更新fold然后切回manual
# 在需要时手动更新，这样既获得了syntax的折叠功能又兼顾了manual的速度
def BuildFolds()
    setlocal foldmethod=syntax
    normal! zx
    setlocal foldmethod=manual
enddef

command! BuildFolds call <SID>BuildFolds()

# toggle foldcolumn
nnoremap <leader>n :call <SID>FoldColumnToggle()<CR>
def FoldColumnToggle()
    if &foldcolumn > 0
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
enddef
# }}}

# ==========statusline settings========== {{{
# set statusline
# set statusline=%f   # path to the file
# set statusline+=%=  # switch to the right side
# set statusline+=%l  # current line number
# set statusline+=/   # separator
# set statusline+=%L  # total line number
# set statusline+=%y  # file type
# }}}

# ==========abbreviations settings========== {{{
# 缩略句abbreviations类似map, 插入模式下输入@g<space>可以快速替换为对应邮箱
# 不用担心所有@g都被替换，因为有iskeyword保护
# iabbrev @g xxxxxx@gmail.com
# }}}

# ==========more operator-pending mappings for markdown========== {{{
# more operator-pending mappings
# for markdown "change inside/around heading"
# for example in markdown:
# Topic one
# =========
# run normal command: cih
# Topic one will be deleted and change to insert mode
# what does the map do? seperate as heres:
# ?^==\+$
# :nohlsearch
# kvg_
augroup markdown_group
    autocmd!
    autocmd FileType markdown onoremap <buffer> ih :<c-u>execute "normal! ?\\(^==\\+$\\\|^--\\+$\\)\r:nohlsearch\rkvg_"<CR>
    autocmd FileType markdown onoremap <buffer> ah :<c-u>execute "normal! ?\\(^==\\+$\\\|^--\\+$\\)\r:nohlsearch\rg_vk0"<CR>
augroup END
# }}}

# ==========toggle settings========== {{{
# toggle number
nnoremap <leader>N :setlocal number!<CR>

# toggle open/close quickfix window
# learn what is wincmd w、winnr()
# TODO bug: when use command 'copen' s:quickfix_is_open cannot be updated
nnoremap <silent> <leader>q :call <SID>QuickfixToggle()<cr>
var S_quickfix_is_open = v:false
var S_quickfix_return_to_window = 0
def QuickfixToggle()
    if S_quickfix_is_open
        cclose
        S_quickfix_is_open = v:false
        execute ":" .. S_quickfix_return_to_window .. "wincmd w"
    else
        S_quickfix_return_to_window = winnr()
        botright copen
        S_quickfix_is_open = v:true
    endif
enddef
# }}}

# ==========hex format========== {{{
command! Hex :%!xxd
command! Uhex :%!xxd -r
# }}}

# ==========ctags/cscope========== {{{
command! -nargs=* GenTags call GenTagsAsync(<q-args>)
command! -nargs=* GenCscope call GenCscopeAsync(<q-args>)

def GenTagsAsync(args: string): string
    var lang = matchstr(args, '\%(^\|\s\)--lang=\zs\S\+')

    # language
    if empty(lang) || lang ==? 'auto'
        if &l:filetype ==# 'cpp' || &l:filetype ==# 'c'
            lang = '--languages=C,C++ '
        elseif &l:filetype ==# 'python'
            lang = '--languages=Python '
        else
            lang = ''
        endif
    else
        lang = '--languages=' .. lang .. ' '
    endif

    # exclude dirs
    var exc =
        '--exclude=.git '
        .. '--exclude=build '

    # build ctags command
    var cmd = 'Async ctags -R ' .. lang .. exc

    # 有--no_run命令
    # if match(args, '\%(^\|\s\)--no_run\%(\s\|$\)') >= 0
    if index(split(args), '--no_run') >= 0
        return cmd
    endif

    # 有--f命令
    # if match(args, '\%(^\|\s\)--f\%(\s\|$\)') >= 0
    if index(split(args), '--f') >= 0
        call feedkeys(':' .. cmd .. "\<C-f>", 'n')
    else
        execute ':' .. cmd
    endif

    return cmd
enddef

def GenCscopeAsync(args: string): string
    var cmd_genf = GenCscopeFilesAsync(args .. " --no_run")
    var cmd_genc = GenCscopeFromFilesAsync(args .. " --no_run")

    # 如果指定了path直接用GenCscopeFromFilesAsync的命令, 否则组合命令
    var path = ExtractPath(args)
    var cmd = ''
    if !empty(path)
        cmd = cmd_genc
    else
        cmd = MergeAsyncCmd([cmd_genf, cmd_genc])
    endif

    # 有--no_run命令
    # if match(args, '\%(^\|\s\)--no_run\%(\s\|$\)') >= 0
    if index(split(args), '--no_run') >= 0
        return cmd
    endif

    # 有--f命令
    # if match(args, '\%(^\|\s\)--f\%(\s\|$\)') >= 0
    if index(split(args), '--f') >= 0
        call feedkeys(':' .. cmd .. "\<C-f>", 'n')
    else
        execute ':' .. cmd
    endif

    return cmd
enddef

def GenCscopeFromFilesAsync(args: string): string
    var cmd = 'Async cscope -b -q -k -i '
    var path = ExtractPath(args)
    if !empty(path)
        cmd = cmd .. shellescape(ExtractPath(args))
    else
        cmd = cmd .. 'cscope.files'
    endif

    # 有--no_run命令
    # if match(args, '\%(^\|\s\)--no_run\%(\s\|$\)') >= 0
    if index(split(args), '--no_run') >= 0
        return cmd
    endif

    # 有--f命令
    # if match(args, '\%(^\|\s\)--f\%(\s\|$\)') >= 0
    if index(split(args), '--f') >= 0
        call feedkeys(':' .. cmd .. "\<C-f>", 'n')
    else
        execute ':' .. cmd
    endif

    return cmd
enddef

def GenCscopeFilesAsync(args: string): string
    var lang = matchstr(args, '\%(^\|\s\)--lang=\zs\S\+')

    # language
    if empty(lang) || lang ==? 'auto'
        if &l:filetype ==# 'cpp' || &l:filetype ==# 'c'
            lang = 'c,c++'
        elseif &l:filetype ==# 'python'
            lang = 'python'
        else
            lang = ''
        endif
    endif

    # include
    var inc = ''
    if lang =~? '^\(c\|c++\|c,c++\)$'
        inc = '-type f "(" -name "*.c" -o -name "*.cc" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" ")" '
    elseif lang ==? 'python'
        inc = '-type f "(" -name "*.py" ")" '
    endif

    # exclude dirs
    var exc =
        '"(" -type d "(" '
        .. '-name ".git" '
        .. '-o -name "build" '
        .. '")" ")" -prune -o '

    # build ctags command
    var cmd =
        'Async find . -mindepth 1 '
        .. exc
        .. inc
        .. '-type f -print > cscope.files'

    # 有--no_run命令
    # if match(args, '\%(^\|\s\)--no_run\%(\s\|$\)') >= 0
    if index(split(args), '--no_run') >= 0
        return cmd
    endif

    # 有--f命令
    # if match(args, '\%(^\|\s\)--f\%(\s\|$\)') >= 0
    if index(split(args), '--f') >= 0
        call feedkeys(':' .. cmd .. "\<C-f>", 'n')
    else
        execute ':' .. cmd
    endif

    return cmd
enddef

def ExtractPath(s: string): string
    # 1. 双引号包裹
    var path = matchstr(s, '--path="\zs[^"]\+')
    if !empty(path)
        return path
    endif

    # 2. 单引号包裹
    path = matchstr(s, "--path='\\zs[^']\\+")
    if !empty(path)
        return path
    endif

    # 3. 无引号（到空格或结尾）
    path = matchstr(s, '--path=\zs\S\+')
    return path
enddef
# }}}

# ==========convenient map for grep searching========== {{{
# ==========vim grep========== {{{
# command completement of search
# g: 一行如果有多个匹配所有
# j: 不跳转到第一个匹配
# botright cwindow: 如果结果不为空最底部打开quickfix window
# <S-Left>/<Left>: 用于修改光标位置
nnoremap <leader>vw :vimgrep /\<<C-r><C-w>\>/gj % \| botright cwindow<S-Left><S-Left><S-Left><S-Left><Left><Left><Left><Left><Left><Left>
nnoremap <leader>vW :vimgrep /\<<C-r><C-a>\>/gj % \| botright cwindow<S-Left><S-Left><S-Left><S-Left><Left><Left><Left><Left><Left><Left>
# ------------------------------------------------------------------------------------------------------------------------
nnoremap <leader>Vw :vimgrep /<C-r><C-w>/gj % \| botright cwindow<S-Left><S-Left><S-Left><S-Left><Left><Left><Left><Left>
nnoremap <leader>VW :vimgrep /<C-r><C-a>/gj % \| botright cwindow<S-Left><S-Left><S-Left><S-Left><Left><Left><Left><Left>

# command completement of grep
nnoremap <leader>vc :silent! vimgrep /\<<C-r><C-w>\>/gj ./**/*.{c,cc,cpp,h,hpp} \| botright cwindow<C-f>BBBBhhhhhh
nnoremap <leader>vh :silent! vimgrep /\<<C-r><C-w>\>/gj ./**/*.{h,hpp} \| botright cwindow<C-f>BBBBhhhhhh
nnoremap <leader>v% :silent! vimgrep /\<<C-r><C-w>\>/gj % \| botright cwindow<C-f>BBBBhhhhhh
nnoremap <leader>vv :silent! vimgrep /\<<C-r><C-w>\>/gj ./**/* \| botright cwindow<C-f>BBBh
# -----------------------------------------------------------------------------------------------------------
nnoremap <leader>vC :silent! vimgrep /\<<C-r><C-a>\>/gj ./**/*.{c,cc,cpp,h,hpp} \| botright cwindow<C-f>BBBBhhhhhh
nnoremap <leader>vH :silent! vimgrep /\<<C-r><C-a>\>/gj ./**/*.{h,hpp} \| botright cwindow<C-f>BBBBhhhhhh
nnoremap <leader>v# :silent! vimgrep /\<<C-r><C-a>\>/gj % \| botright cwindow<C-f>BBBBhhhhhh
nnoremap <leader>vV :silent! vimgrep /\<<C-r><C-a>\>/gj ./**/* \| botright cwindow<C-f>BBBh
# -----------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------
nnoremap <leader>Vc :silent! vimgrep /<C-r><C-w>/gj ./**/*.{c,cc,cpp,h,hpp} \| botright cwindow<C-f>BBBBhhhh
nnoremap <leader>Vh :silent! vimgrep /<C-r><C-w>/gj ./**/*.{h,hpp} \| botright cwindow<C-f>BBBBhhhh
nnoremap <leader>V% :silent! vimgrep /<C-r><C-w>/gj % \| botright cwindow<C-f>BBBBhhhh
nnoremap <leader>Vv :silent! vimgrep /<C-r><C-w>/gj ./**/* \| botright cwindow<C-f>BBBh
# -----------------------------------------------------------------------------------------------------------
nnoremap <leader>VC :silent! vimgrep /<C-r><C-a>/gj ./**/*.{c,cc,cpp,h,hpp} \| botright cwindow<C-f>BBBBhhhh
nnoremap <leader>VH :silent! vimgrep /<C-r><C-a>/gj ./**/*.{h,hpp} \| botright cwindow<C-f>BBBBhhhh
nnoremap <leader>V# :silent! vimgrep /<C-r><C-a>/gj % \| botright cwindow<C-f>BBBBhhhh
nnoremap <leader>VV :silent! vimgrep /<C-r><C-a>/gj ./**/* \| botright cwindow<C-f>BBBh
# }}}

# ==========async grep========== {{{
# g@: call the function set by the 'operatorfunc'
# <SID>: use for function namespace
# <c-u>: clear the command line to the begin
# visualmode(): vim inside function to get the last visual mode type: v, V, <C-v>
# the two map below are for nomal mode, visual mode
# how to use: <localleader>giw, viw<localleader>g ...
nnoremap <silent> <leader>g :set operatorfunc=<SID>GrepOperatorR<CR>g@
xnoremap <silent> <leader>g :<c-u>call <SID>GrepOperatorR(visualmode())<CR>
nnoremap <silent> <leader>G :set operatorfunc=<SID>GrepOperatorNR<CR>g@
xnoremap <silent> <leader>G :<c-u>call <SID>GrepOperatorNR(visualmode())<CR>
# better use than <leader>G
# nnoremap <silent> <leader><leader>g :set operatorfunc=<SID>GrepOperatorNR<CR>g@
# xnoremap <silent> <leader><leader>g :<c-u>call <SID>GrepOperatorNR(visualmode())<CR>

def GrepOperatorR(type: string)
    GrepOperatorAsync(type, 1)
enddef

def GrepOperatorNR(type: string)
    GrepOperatorAsync(type, 0)
enddef

def GrepDetect()
    for i in range(len(S_grep_tools))
        var tool = S_grep_tools[i]
        if executable(tool)
            S_grep_tool = tool
            return
        endif
    endfor
enddef

def g:SetGrep(name: string)
    for i in range(len(S_grep_tools))
        var tool = S_grep_tools[i]
        if tool ==# name && executable(tool)
            S_grep_tool = tool
            break
        endif
    endfor
    echo 'grep_tool = ' .. S_grep_tool
enddef
# --------------------------------------------------
var S_grep_tools = ['rg', 'grep']
var S_grep_tool = 'grep'
call GrepDetect()

# ==========grep 路由========== {{{
# 增强异步版本的grep，预填基础信息允许用户修改, 尤其是填充exclude信息
def GrepOperatorAsync(type: string, recursion: number)
    # save unnamed register
    var saved_unnamed_register = getreg('"', 0, 1)
    var saved_register_type = getregtype('"')

    try
        # yank selected text
        if type ==# 'v'
            normal! `<v`>y
        elseif type ==# 'char'
            normal! `[v`]y
        else
            return
        endif

        var grep_cmd = ''
        if S_grep_tool ==# 'rg'
            grep_cmd = BuildCmdRipGrep(shellescape(getreg('"')), recursion)
        elseif S_grep_tool ==# 'grep'
            grep_cmd = BuildCmdGnuGrep(shellescape(getreg('"')), recursion)
        else
            echo "Unsupported grep tool: " .. S_grep_tool
            return
        endif

        # open command-line window with editable command
        call feedkeys(':' .. grep_cmd .. "\<C-f>", 'n')

    finally
        # restore unnamed register
        setreg('"', saved_unnamed_register, saved_register_type)
    endtry
enddef

def BuildCmdGnuGrep(pattern: string, recursion: number): string
    # include filters
    var inc = ''
    if &l:filetype ==# 'cpp' || &l:filetype ==# 'c'
        inc =
            '--include=*.c '
            .. '--include=*.cc '
            .. '--include=*.cpp '
            .. '--include=*.h '
            .. '--include=*.hpp '
    elseif &l:filetype ==# 'python'
        inc = '--include=*.py '
    endif

    # exclude dirs
    var exc =
        '--exclude-dir=.git '
        .. '--exclude-dir=build '

    # build grep command
    var grep_cmd = ''
    if recursion
        grep_cmd =
            'Async grep -Rn '
            .. inc
            .. exc
            .. pattern
            .. ' .'
    else
        grep_cmd =
            'Async grep -Hn '
            .. pattern
            .. ' ' .. expand('%:p')
    endif

    return grep_cmd
enddef

def BuildCmdRipGrep(pattern: string, recursion: number): string
    # include filters
    var inc = ''
    if &l:filetype ==# 'cpp' || &l:filetype ==# 'c'
        inc =
            '-g *.c '
            .. '-g *.cc '
            .. '-g *.cpp '
            .. '-g *.h '
            .. '-g *.hpp '
    elseif &l:filetype ==# 'python'
        inc = '-g *.py '
    endif

    # exclude dirs
    var exc =
        '-g !.git '
        .. '-g !build '

    # build grep command
    var grep_cmd = ''
    if recursion
        grep_cmd =
            'Async rg --vimgrep -H -n '
            .. inc
            .. exc
            .. pattern
            .. ' .'
    else
        grep_cmd =
            'Async rg --vimgrep -H -n '
            .. pattern
            .. ' ' .. expand('%:p')
    endif

    return grep_cmd
enddef
# }}}
# }}}
# }}}

# ==========register macro record========== {{{
# 非常有用的宏保存到寄存器中，在开发时方便使用，就像工具箱一样
# [经典寄存器内容追加]，用于统计查找模式后的数据，比如有如下log日志：
# xxx
# time diff: 123
# xxx
# time diff: -23
# xxx
# time diff: 37
# ...
# 首先执行查找模式： '/time diff: '
# 然后串行执行宏：100@u
# 数据将保存到寄存器z中: '123 -23 37 '
@u = 'gnl"ZyaW'
# --------------------------------------------------------------------
# [相邻数据差值计算]，与@u类似
# 首先执行查找模式： '/time diff: '
# 然后串行执行宏：100@v
# 数据将保存到寄存器z中: '-146 60 '
@v = 'gnl"jyEgnl"kyE:vim9cmd @j = string(g:RemoveLeftZero(@j)):vim9cmd @k = string(g:RemoveLeftZero(@k)):vim9cmd g:t = str2nr(@k) - str2nr(@j):vim9cmd @z = @z .. g:t .. " "Nh'
# --------------------------------------------------------------------
# [相邻时间差值计算]，时间格式应该形如: xxx时:分:秒.毫秒 例: I:time [17:12:39.638 11-03-2022]
# 首先执行查找模式： '/I:time ['
# 然后串行执行宏：100@w
# 一毫秒为单位的时间差数据将保存到寄存器z中
@w = 'gnl"jyEgnl"kyE:vim9cmd @j = string(g:TimeToMillisecond(@j)):vim9cmd @k = string(g:TimeToMillisecond(@k)):vim9cmd g:t = str2nr(@k) - str2nr(@j):vim9cmd @z = @z .. t .. " "Nh'
# --------------------------------------------------------------------
# [以空格作为间隔符拼接所有行]
# 即把所有行以空格为间隔拼接到一行，或者将所有行的换行符替换为空格
# 直接串行执行宏：100@x
@x = '"Zy$:vim9cmd @z = @z .. " "j'
# --------------------------------------------------------------------
# [拷贝整行数据] 在查看日志时使用grep，有时会显示很长的文件名前缀,
# 使用整行数据拷贝可以避免这种麻烦
# 先执行查找模式：'/[message]:'
# 执行宏一次: @y
# 数据将保存到寄存器z中，在一个缓冲区粘贴出来':put z'
@y = ':vim9cmd global//yank Z'
# --------------------------------------------------------------------
# [长行后半部分截取] 是上面@y的加强版, 在一行很长的文本中截取后半部分有用的内容,
# 这在日志分析中当前缀内容太长时非常有用
# 先执行查找模式：'/message: '
# 然后串行执行宏：100@o
# 数据将保存到寄存器z中，在一个缓冲区粘贴出来':put z'
@o = 'gnmm"ty$:vim9cmd @t = @t .. "\n":vim9cmd @z = @z .. @t`ml'
# 提示：运行宏之前应该先清空寄存器z -> qzq

# ==========tool functions========== {{{
# remove left zero: 050 -> 50
def g:RemoveLeftZero(number: string): number
    # echom 'input: ' .. number
    var length = strlen(number)
    if length == 0
        return 0
    endif
    var i = 0
    for n in split(number, '\zs')
        if n != '0'
            break
        endif
        i += 1
    endfor
    if i == length
        return str2nr(number)
    else
        return str2nr(number[i : length - 1])
    endif
enddef

# time to millisecond, input format: 23:03:55.998 or 03:55.998
def g:TimeToMillisecond(time: string): number
    # echom 'input: ' .. time
    var length = len(time)
    if length == 0
        return 0
    endif
    var time_list = split(time, '\.')
    var front_time_list = split(time_list[0], ":")
    if len(front_time_list) == 2
        return g:RemoveLeftZero(front_time_list[0]) * 60 * 1000 + g:RemoveLeftZero(front_time_list[1]) * 1000 + g:RemoveLeftZero(time_list[1])
    elseif len(front_time_list) == 3
        return g:RemoveLeftZero(front_time_list[0]) * 60 * 60 * 1000 + g:RemoveLeftZero(front_time_list[1]) * 60 * 1000 + g:RemoveLeftZero(front_time_list[2]) * 1000 + g:RemoveLeftZero(time_list[1])
    else
        echo 'error time format!'
        return 0
    endif
enddef
# }}}
# }}}
# }}}



# ==========plugin settings========== {{{
# ==========vim plugin manager========== {{{
# any issues see github!!!
call plug#begin()
# The default plugin directory will be as follows:
#   - Vim (Linux/macOS): '~/.vim/plugged'
#   - Vim (Windows): '~/vimfiles/plugged'
#   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
# You can specify a custom plugin directory by passing it as the argument
#   - e.g. `call plug#begin('~/.vim/plugged')`
#   - Avoid using standard Vim directory names like 'plugin'
Plug 'rhysd/vim-healthcheck'                      # plugin helth check
# ------------------------------------------------------------
Plug 'tpope/vim-surround'                         # 可使块surroud, 如给word -> {word}
Plug 'tpope/vim-unimpaired'                       # 缓冲区、参数、quickfix、位置、标签列表的遍历快捷键
Plug 'tpope/vim-commentary'                       # 代码注释gc
# ------------------------------------------------------------
Plug 'octol/vim-cpp-enhanced-highlight'           # cpp语法高亮
Plug 'tikhomirov/vim-glsl'                        # opengl着色器语言语法高亮
Plug 'plasticboy/vim-markdown'                    # markdown语法高亮
Plug 'aklt/plantuml-syntax'                       # plantuml语法高亮
# ------------------------------------------------------------
Plug 'mhinz/vim-signify'                          # git工具
Plug 'voldikss/vim-translator'                    # vim翻译工具
# ------------------------------------------------------------
Plug 'prabirshrestha/vim-lsp'                     # LSP core
# Plug 'mattn/vim-lsp-settings'                     # LSP语言服务配置
Plug 'prabirshrestha/asyncomplete.vim'            # lsp自动补全
Plug 'prabirshrestha/asyncomplete-lsp.vim'        # lsp自动补全
# ------------------------------------------------------------
# Plug 'easymotion/vim-easymotion'                  "跳转
# ------------------------------------------------------------
# Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
# ------------------------------------------------------------
# Plug 'weirongxu/plantuml-previewer.vim'           #plantuml预览, need sudo apt-get install graphviz
# Plug 'tyru/open-browser.vim'                      #浏览器预览渲染图, plantuml用
call plug#end()
# }}}


# 插件特性设置: >>>

# ==========vim-cpp-enhanced-highlight settings========== {{{
g:cpp_class_scope_highlight = 1
g:cpp_member_variable_highlight = 1
g:cpp_class_decl_highlight = 1
g:cpp_posix_standard = 1
g:cpp_experimental_simple_template_highlight = 0    # 性能太差
g:cpp_concepts_highlight = 1
g:cpp_no_function_highlight = 0                     # Disable highlighting of user defined functions
# }}}

# ==========vim-signify settings========== {{{
# 默认禁用, 使用:SignifyEnable手动开启
g:signify_disable_by_default = 1
# }}}

# ==========vim-translator settings========== {{{
# translator variable
# let g:translator_proxy_url = 'socks5://127.0.0.1:1080'
# let g:translator_default_engines = ['bing', 'haici']
# let g:translator_default_engines = ['bing', 'haici', 'youdao']
# convenient map for translating
# Echo translation in the cmdline
nnoremap <leader>tt :Translate <C-r><C-w>
xnoremap <leader>tt :Translate
nnoremap <leader>Tt :Translate!
xnoremap <leader>Tt :Translate!
# -----------------------------------------
# Display translation in a window
nnoremap <leader>tw :TranslateW <C-r><C-w>
xnoremap <leader>tw :TranslateW
nnoremap <leader>Tw :TranslateW!
xnoremap <leader>Tw :TranslateW!
# -----------------------------------------
# Replace the text with translation
nnoremap <leader>tr :TranslateR <C-r><C-w>
xnoremap <leader>tr :TranslateR
nnoremap <leader>Tr :TranslateR!
xnoremap <leader>Tr :TranslateR!
# -----------------------------------------
# Translate the text in clipboard
nnoremap <leader>tx :TranslateX <C-r><C-w>
xnoremap <leader>tx :TranslateX
nnoremap <leader>Tx :TranslateX!
xnoremap <leader>Tx :TranslateX!
# }}}

# ==========vim-lsp settings========== {{{
# 设置c++查找路径，若WSL下无法识别std，请打开该设置
# g:lsp_settings = {
#     'clangd': {
#     'args': ['--query-driver=/usr/bin/c++*,/usr/bin/g++*'],
#     }
# }

# PYTHON LSP
# 若无法忍受vim-lsp-settings插件在打开文件时的卡顿
# 手动配置LSP语言服务, 请注释: Plug 'mattn/vim-lsp-settings'
def RegisterPython()
    lsp#register_server({
        name: 'ty',
        cmd: (server_info) => ['ty', 'server'],
        allowlist: ['python'],
    })
enddef
if executable('ty')
    # pip install ty
    au User lsp_setup call RegisterPython()
endif

# C/C++ LSP
# 若WSL下无法识别std，加入下面这条命令
# '--query-driver=/usr/bin/c++*,/usr/bin/g++*',
def RegisterC()
    lsp#register_server({
        name: 'clangd',
        cmd: (server_info) => [
            'clangd',
            '--background-index',
            '--clang-tidy',
        ],
        allowlist: ['c', 'cpp'],
    })
enddef
if executable('clangd')
    # sudo apt install clangd
    au User lsp_setup call RegisterC()
endif


# 启用原生LSP
g:lsp_use_native_client = 1

# 启动时禁用lsp
g:lsp_auto_enable = 0

# 语义高亮, 速度有些慢
g:lsp_semantic_enabled = 1
g:lsp_semantic_delay = 500

# 禁止光标停留自动高亮
g:lsp_document_highlight_enabled = 0

# 禁止函数签名提示自动弹出在输入模式下
g:lsp_signature_help_enabled = 0

# 补全额外信息显示
g:lsp_completion_documentation_enabled = 1

# 诊断信息
g:lsp_diagnostics_enabled = 1                           # 启用诊断信息
g:lsp_diagnostics_echo_cursor = 1                       # 命令行中输出错误信息
g:lsp_diagnostics_echo_delay  = 0                       # 延迟显示
g:lsp_diagnostics_float_cursor = 0                      # 悬浮窗口显示诊断信息
g:lsp_diagnostics_float_delay = 500                     # 延迟显示
g:lsp_diagnostics_float_insert_mode_enabled = 0         # 插入模式关闭悬浮
g:lsp_diagnostics_highlights_enabled = 1                # 错误诊断高亮
g:lsp_diagnostics_highlights_delay = 500                # 延迟高亮
g:lsp_diagnostics_highlights_insert_mode_enabled = 1    # 插入模式高亮
g:lsp_diagnostics_signs_enabled = 1                     # 启用侧边栏符号
g:lsp_diagnostics_signs_delay = 500                     # 延迟符号显示
g:lsp_diagnostics_signs_insert_mode_enabled = 1         # 插入模式侧边符号显示
# 设置符号样式
# g:lsp_diagnostics_signs_error = {'text': '✗', 'texthl': 'DiagnosticSignError'}
# g:lsp_diagnostics_signs_warning = {'text': '⚠', 'texthl': 'DiagnosticSignWarn'}
# 关闭错误诊断虚拟文本
g:lsp_diagnostics_virtual_text_enabled = 0
g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0

# 禁止补全弹窗自动弹出
g:asyncomplete_auto_popup = 0

# allow modifying the completeopt variable, or it will
# be overridden all the time
# 不自动设置补全行为
g:asyncomplete_auto_completeopt = 0

# lsp log
# g:lsp_log_verbose = 1
# g:lsp_log_file = expand('~/logs/vim/vim-lsp.log')
# g:asyncomplete_log_file = expand('~/logs/vim/asyncomplete.log')

# 设置手动开关命令
command! LspEnable call <SID>LspEnable()
command! LspEnableFast call <SID>LspEnableFast()
command! LspEnableHeavy call <SID>LspEnableHeavy()
command! LspDisable call <SID>LspDisable()
command! LspRestart call <SID>LspRestartServer()
# -----------------------------------
command! LspFast call <SID>LspFast()
command! LspHeavy call <SID>LspHeavy()

# 设置快捷键
def OnLspBufferEnabled()
    setlocal omnifunc=lsp#complete
    # setlocal signcolumn=yes
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
    # ----------------------------------------------
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover-float)
    nmap <buffer> gK <plug>(lsp-hover-preview)
    # ----------------------------------------------
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> <leader>a <plug>(lsp-code-action-float)
    # refer to doc to add more commands
enddef

augroup lsp_install
    au!
    # call OnLspBufferEnabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call OnLspBufferEnabled()
augroup END

# 手动弹出，用<C-i>就可以了
# imap <c-space> <Plug>(asyncomplete_force_refresh)
# For Vim 8 (<c-@> corresponds to <c-space>):
# imap <c-@> <Plug>(asyncomplete_force_refresh)

# 补全弹窗列表选择
# inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
# inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"

def CheckBackspace(): bool
    var col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
enddef

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>CheckBackspace() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

# 使用<C-j>/<C-k>上下滚动popup window
g:cj_cmd_nmap = maparg('<C-j>', 'n')
g:ck_cmd_nmap = maparg('<C-k>', 'n')
if exists('*popup_list') && g:cj_cmd_nmap =~# '^<Plug>' && g:ck_cmd_nmap =~# '^<Plug>'
    # 如果 maparg 返回的是 <Plug>(...)，把它变成可执行的特殊键形式："\<Plug>(...)"
    g:cj_cmd_nmap = "\<Plug>" .. g:cj_cmd_nmap[6 : ]
    g:ck_cmd_nmap = "\<Plug>" .. g:ck_cmd_nmap[6 : ]
    nnoremap <silent><expr> <C-j>
        \ empty(popup_list())
        \ ? g:cj_cmd_nmap
        \ : lsp#scroll(+1)
    nnoremap <silent><expr> <C-k>
        \ empty(popup_list())
        \ ? g:ck_cmd_nmap
        \ : lsp#scroll(-1)
endif
# 使用<C-u>/<C-d>上下滚动popup window
if exists('*popup_list')
    nnoremap <silent><expr> <C-u>
            \ empty(popup_list())
            \ ? "<C-u>"
            \ : lsp#scroll(-4)
    nnoremap <silent><expr> <C-d>
            \ empty(popup_list())
            \ ? "<C-d>"
            \ : lsp#scroll(+4)
endif

# 重启服务
def LspRestartServer()
    if &modified
        echo "No write since last change!"
    else
        LspStopServer
        sleep 100m
        var view = winsaveview()
        edit
        call winrestview(view)
    endif
enddef

# 清理语义高亮, lsp#disable时不会自动清理
def LspSemanticClear()
  for t in prop_type_list()
    if t =~ '^vim-lsp-semantic-'
      call prop_remove({'type': t, 'all': 1}, 1, line('$'))
    endif
  endfor
enddef

var S_lsp_saved_signcolumn = &signcolumn
def LspEnable()
    S_lsp_saved_signcolumn = &signcolumn
    call lsp#enable()
    set signcolumn=yes
enddef

def LspDisable()
    call lsp#disable()
    &signcolumn = S_lsp_saved_signcolumn
    call LspSemanticClear()
    LspStopServer
enddef

def LspEnableFast()
    call ConfigLspFast()
    call LspEnable()
enddef

def LspEnableHeavy()
    call ConfigLspHeavy()
    call LspEnable()
enddef

def LspFast()
    call ConfigLspFast()
    call LspRestartServer()
enddef

def LspHeavy()
    call ConfigLspHeavy()
    call LspRestartServer()
enddef

# 这个设置有bug，在重启服务后会变得特别慢
# 如果想使用fast设置，启动时调用:LspEnableFast
def ConfigLspFast()
    g:lsp_semantic_enabled = 0                              # 语义高亮
    g:lsp_diagnostics_highlights_delay = 0                  # 诊断信息-延迟高亮
    g:lsp_diagnostics_highlights_insert_mode_enabled = 0    # 诊断信息-插入模式高亮
    g:lsp_diagnostics_signs_delay = 0                       # 诊断信息-延迟符号显示
    g:lsp_diagnostics_signs_insert_mode_enabled = 0         # 诊断信息-插入模式侧边符号显示
enddef

def ConfigLspHeavy()
    g:lsp_semantic_enabled = 1                              # 语义高亮
    g:lsp_diagnostics_highlights_delay = 500                # 诊断信息-延迟高亮
    g:lsp_diagnostics_highlights_insert_mode_enabled = 1    # 诊断信息-插入模式高亮
    g:lsp_diagnostics_signs_delay = 500                     # 诊断信息-延迟符号显示
    g:lsp_diagnostics_signs_insert_mode_enabled = 1         # 诊断信息-插入模式侧边符号显示
enddef
# }}}
# }}}



# ======================================================================================
var END_TIME = float2nr(reltimefloat(reltime(START_TIME)) * 1000)
augroup VimStartup
    autocmd!
    autocmd VimEnter * echom "My best vim == >^.^< ==" .. ' ' .. string(END_TIME) .. 'ms'
    # autocmd VimEnter * echom "My best vim == >^.^< ==" .. ' ' .. string(END_TIME) .. 'ms' | echom ''
augroup END

command! Vim redraw <bar>
            \ echom "vim == >^.^< == vim" <bar>
            \ sleep 500m <bar>
            \ redraw <bar>
            \ echom "vim == >-.^< == vim" <bar>
            \ sleep 200m <bar>
            \ redraw <bar>
            \ echom "vim == >^.^< == vim"
# ======================================================================================
