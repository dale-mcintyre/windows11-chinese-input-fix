#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Windows 11 Language Toggle (Word-Compatible Version)
 * Author: Dale McIntyre
 * Description: Uses Right Alt (RAlt) to cleanly toggle between 
 *              Chinese Pinyin and English, bypassing Microsoft Word's 
 *              internal CapsLock interference.
 */

; State tracker: 0 = English, 1 = Chinese
global ChineseMode := 0

; Enforce language state when clicking or switching windows
~LButton::EnforceState()
~^Tab::EnforceState()
~!Tab::EnforceState()

; Intercept Right Alt key tap
RAlt:: {
    global ChineseMode
    
    ; Toggle the internal tracker state
    ChineseMode := !ChineseMode
    
    ApplyLanguageState(ChineseMode)
}

EnforceState() {
    global ChineseMode
    Sleep 100 ; Allow active window focus to settle
    ApplyLanguageState(ChineseMode)
}

ApplyLanguageState(SetChinese) {
    hwnd := WinExist("A")
    if (!hwnd)
        return

    if (SetChinese) {
        ; 1. Set system layout to Chinese Simplified (0x0804)
        PostMessage(0x50, 0, 0x0804, , "A")
        
        ; 2. Force the internal Microsoft Pinyin IME flag to Chinese (中)
        SetImeMode(hwnd, 1) 
    } else {
        ; Snap back to system default English layout
        PostMessage(0x50, 0, 0, , "A")
    }
}

; Low-level Windows Input Method Manager framework hook
SetImeMode(hwnd, mode) {
    try {
        imeHwnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
        if (imeHwnd) {
            ; WM_IME_CONTROL (0x0283), IMC_SETCONVERSIONMODE (0x0002)
            SendMessage(0x0283, 0x0002, (mode ? 1025 : 0), , "ahk_id " imeHwnd)
        }
    }
}
