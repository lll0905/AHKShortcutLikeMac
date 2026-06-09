#Requires AutoHotkey v2.0

; ======================================================
; 短语缩写
; ======================================================
::155::15542518680
::499::49972849
::xialin::xialin.luo@sbitech.com
::luoxialin::luoxialin@gmail.com

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
; 组合键映射:
; ======================================================

;~Space & c::SendInput "^c"


; 将 Alt + C 映射为 Ctrl + C (复制)
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





; alt+Backspace = 删除一行
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
; 单键映射
; ======================================================
;RWin::Backspace



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



; ---------------------------------------------------------
; 功能：Caps Lock 双重功能
; 1. 单独按一下（短按并弹起）：触发 Esc
; 2. 配合其他键按（组合键）：触发 Ctrl
; 3. 长按住不放：触发 Ctrl
; ---------------------------------------------------------

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
