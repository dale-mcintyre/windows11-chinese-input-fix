#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Windows 11 Caps Lock Language Toggle
 * Author: Dale McIntyre
 * Description: Forces a clean binary toggle using Caps Lock.
 *              Caps Lock ON  -> Chinese Pinyin Input (Forces '中' mode)
 *              Caps Lock OFF -> Default English Input
 */

global LastState := GetKeyState("CapsLock", "T")

; Enforce language state when clicking or switching windows to defeat 
; Windows 11's aggressive per-window layout overriding.
~LButton::EnforceState()
~^Tab::EnforceState()
~!Tab::EnforceState()

~CapsLock:: {
    global LastState
    Sleep 50 ; Short delay to allow the physical key state to register
    CurrentState := GetKeyState("CapsLock", "T")
    
    if (CurrentState != LastState) {
        ApplyLanguageState(CurrentState)
        LastState := CurrentState
    }
}

EnforceState() {
    Sleep 100 ; Allow the new active window focus to settle
    ApplyLanguageState(GetKeyState("CapsLock", "T"))
}

ApplyLanguageState(CapsOn) {
    hwnd := WinExist("A")
    if (!hwnd)
        return

    if (CapsOn) {
        ; 1. Set system layout to Chinese Simplified (0x0804)
        PostMessage(0x50, 0, 0x0804, , "A")
        
        ; 2. Hard-reset the internal Microsoft Pinyin IME flag from English (英) to Chinese (中)
        SetImeMode(hwnd, 1) 
    } else {
        ; Caps Lock is off -> snap back to system default English layout
        ; NOTE: Change the '0' to '0x0809' if you want to explicitly force UK English layout.
        PostMessage(0x50, 0, 0, , "A")
    }
}

; Intercepts the low-level Windows Input Method Manager framework (imm32.dll)
SetImeMode(hwnd, mode) {
    try {
        imeHwnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
        if (imeHwnd) {
            ; WM_IME_CONTROL (0x0283), IMC_SETCONVERSIONMODE (0x0002)
            ; Passing 1025 forcefully locks the IME into native Chinese character entry
            SendMessage(0x0283, 0x0002, (mode ? 1025 : 0), , "ahk_id " imeHwnd)
        }
    }
}
