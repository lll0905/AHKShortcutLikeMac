#Requires AutoHotkey v2.0


+Esc::Reload   ; Ctrl + Esc: 重新加载脚本（修改代码后快速生效）



; ======================================================
; 短语缩写
; ======================================================
:*:155::15542518680
:*:499::49972849
:*:xialin::xialin.luo@sbitech.com
:*:karra::karra@sbisec.co.jp
:*:luoxialin::luoxialin@gmail.com

:*:;date::
{
    Send FormatTime(, "yyyy-MM-dd")  ; 输入 ;date 瞬间变成 2026-08-14
}

:*:;time::
{
    Send FormatTime(, "yyyy-MM-dd HH:mm:ss")  ; 输入 ;date 瞬间变成 2026-08-14
}




; ======================================================
; 单键映射
; ======================================================
;RWin::Backspace



; ======================================================
; 修饰键映射:(add for black_kb)
; 如果使用hhkb, 删除这段
; ======================================================

; 将左 Win 键映射为左 Alt
LWin::LAlt


; ======================================================
; 组合键映射: 方向键
; ======================================================
^h::SendInput "{Left}"
^j::SendInput "{Down}"
^k::SendInput "{Up}"
^l::SendInput "{Right}"
^e::SendInput "{End}"
^i::SendInput "{Home}"


; ======================================================
; 组合键映射: 空格键和ctrl键功能一样
; ======================================================
;~Space & c::SendInput "^c"




; ======================================================
; 将 Alt + C 映射为 Ctrl + C (复制)
; ======================================================
!c::Send "^c"
!v::Send "^v"  ; Alt + V = 粘贴
!x::Send "^x"  ; Alt + X = 剪切
!a::Send "^a"  ; Alt + A = 全选
!z::Send "^z"  ; Alt + Z = 撤销
!s::Send "^s"  ; Alt + S = save
!w::Send "^w"  ; Alt + W = close
!q::Send "^q"  ; Alt + S = quit
!f::Send "^f"  ; Alt + F = search
!t::Send "^t"  ; Alt + T = new tab




; ======================================================
; alt+Backspace = 删除一行
; ======================================================
!Backspace::
{
    ; 发送 Home 键将光标移动到当前行行首
    ; 发送 Shift+End 选中到行尾
    ; 发送 Backspace 删除选中的文本
    ; 再发送一次 Backspace 删除留下的空行（可选）
    Send("{Home}")
    Send("+{End}")
    Send("{Backspace}")

    ; 如果你想连带删除这个空行，让下一行顶上来，取消下面这一行的注释：
    ; Send("{Delete}")
}





; ======================================================
; 启动程序
; ======================================================
TargetProgram := "C:\Users\xialin.luo\scoop\apps\warp-terminal\0.2026.05.27.15.44.stable_01\warp.exe"
; 定义左 Alt 键 (~ 表示不拦截 Alt 原有的系统功能，避免 Alt 单击失效)
~RShift Up::
{
    ; 等待 RShift 再次被按下，超时时间设为 0.2 秒
    ; 如果 0.2 秒内再次按下了 RShift，KeyWait 会返回 1 (True)
    if KeyWait("RShift", "D T0.2")
    {
        ; --- 在这里修改你想要启动的程序路径 ---
        Run TargetProgram

        ; 等待按键松开，防止长按导致重复触发
        KeyWait "RShift"
    }
}



; ======================================================
; 安住空格键表示触发ctrl键, 点击空格表示空格键
; ======================================================
; * 号允许组合修饰键，$ 号防止递归触发
*$Space::
{
    ; 逻辑按下左 Ctrl
    Send("{Blind}{LCtrl DownR}")

    ; 等待 Space 键释放
    KeyWait("Space")

    ; 逻辑抬起左 Ctrl
    Send("{Blind}{LCtrl Up}")

    ; 核心逻辑：如果从按下 Space 到释放期间没有按过其他键，则发送空格
    if (A_PriorKey = "Space")
    {
        Send("{Blind}{Space}")
    }
}



; ======================================================
; 功能：Caps Lock 双重功能
; 1. 单独按一下（短按并弹起）：触发 Esc
; 2. 配合其他键按（组合键）：触发 Ctrl
; 3. 长按住不放：触发 Ctrl
; ======================================================

*CapsLock:: {
    ; 这里的 {Blind} 允许修饰键传递，LControl DownR 模拟物理按下 Ctrl
    Send("{Blind}{LControl DownR}")
}

*CapsLock up:: {
    ; 释放 Ctrl 状态
    Send("{Blind}{LControl Up}")

    ; 关键判断：
    ; 如果在按下 CapsLock 到弹起期间没有按过其他键 (A_PriorKey)
    ; 且上一个按键确实是 CapsLock，则发送 Esc
    if (A_PriorKey = "CapsLock") {
        Send("{Esc}")
    }
}




; ======================================================
; 选中的文本直接用 Google AI 搜索（无选中则弹出输入框版）
; ======================================================
; Ctrl + Alt + F: 触发搜索
^!f::
{
    OriginalClipboard := ClipboardAll()  ; 完美备份所有格式
    A_Clipboard := ""                    ; 清空剪贴板以备接收

    Send("^c")                           ; 尝试复制选中的文本
    ClipWait(0.2)                        ; 只等待0.2秒，快速判断有没有选中文字

    ; 移除文本前后的空白字符（空格、换行、Tab）
    SearchText := Trim(A_Clipboard)

    ; 情况 1：如果没有选中任何文字，则弹出手动输入框
    if (SearchText == "")
    {
        ; 恢复剪贴板
        A_Clipboard := OriginalClipboard

        ; 弹出输入框，标题为“Google AI 搜索”，提示语为“请输入搜索内容：”
        IB := InputBox("请输入搜索内容：", "Google AI 搜索", "w400 h100")

        ; 如果用户点击了“取消”或直接关闭了窗口，则退出不执行搜索
        if (IB.Result = "Cancel")
            return

        SearchText := Trim(IB.Value)

        ; 如果用户什么都没输入就点了确定，也直接退出
        if (SearchText == "")
            return
    }
    else
    {
        ; 情况 2：成功复制到了选中的文字，延迟一会后还原剪贴板
        Sleep(50)
        A_Clipboard := OriginalClipboard
    }

    ; 执行标准的 URL 编码并打开浏览器搜索
    QueryUrl := "https://google.com/search?q=" . NativeUriEncode(SearchText) . "&udm=50"
    Run(QueryUrl)
}

; 纯 AHK v2 原生 URL 编码函数
NativeUriEncode(str) {
    buf := Buffer(StrPut(str, "UTF-8"))
    StrPut(str, buf, "UTF-8")

    result := ""
    Loop buf.Size - 1 {
        code := NumGet(buf, A_Index - 1, "UChar")
        if ((code >= 65 && code <= 90) || (code >= 97 && code <= 122) || (code >= 48 && code <= 57) || InStr("-_.!~*'()", Chr(code))) {
            result .= Chr(code)
        } else {
            result .= Format("%{:02X}", code)
        }
    }
    return result
}

