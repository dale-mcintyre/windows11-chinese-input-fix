# Windows 11 Right-Alt Chinese/English Input Toggle

A lightweight AutoHotkey (v2) script that fixes the notoriously frustrating multi-language switching layout in Windows 11. It binds your **Right Alt** key (located right next to the spacebar) to function as a strict, snappy binary toggle:

* **Tap Right Alt (State 1)** ➔ Pure Chinese Pinyin Entry (Forces **中** mode, completely destroying the hidden internal English mode).
* **Tap Right Alt (State 2)** ➔ Pure System English Entry.

## The Problem This Solves
In Windows 11, even if you disable the native language shortcuts, the Microsoft Pinyin IME stubbornly maintains a hidden internal "English" mode. Windows will randomly switch your keyboard status to **英** depending on what application you click into, forcing you to constantly cycle inputs manually.

### Why Right Alt instead of Caps Lock?
While using Caps Lock as a layout switch is common, **Microsoft Word** aggressively monitors the Caps Lock key to handle its internal auto-capitalization, smart-quotes, and real-time grammar checks. This creates a race condition that causes severe input lag, stuttering, or dropped characters inside Office applications. 

By utilizing **Right Alt**, this script completely bypasses Word's text-automation filters while providing an incredibly fast, ergonomic thumb-tap to switch languages. It also handles low-level window hooks via `imm32.dll` to violently force the layout back into compliance whenever you switch active application windows.

## Installation & Setup

### Prerequisite
1. Ensure you have **AutoHotkey v2** installed on your system. If not, download it from the [Official AutoHotkey Website](https://www.autohotkey.com/).
2. Set your Windows IME default to Chinese:
   * Go to **Settings > Time & language > Language & region**.
   * Click the three dots next to **中文 (简体，中国)** ➔ **Language options**.
   * Scroll down to **Microsoft Pinyin** ➔ **Keyboard options** ➔ **General**.
   * Set **Choose IME default mode** explicitly to **Chinese**.

### Running the Script
1. Clone this repository or download `LanguageToggle.ahk`.
2. Double-click `LanguageToggle.ahk` to run it. It will sit quietly in your Windows system tray.

### Launch automatically at Windows startup
To make this behavior permanent every time you boot your computer:
1. Press `Win + R` to open the Run dialog.
2. Type `shell:startup` and press **Enter** (this opens your Windows Startup directory).
3. Right-click `LanguageToggle.ahk`, select **Copy**, then right-click inside the Startup folder and select **Paste shortcut**.

## Customization
By default, the script signals Windows to return to your default system English layout on the alternate tap. If you use a specific regional layout and find your punctuation keys mismatching, edit line 46 of the script:
* For **UK English**, change `PostMessage(0x50, 0, 0, , "A")` to `PostMessage(0x50, 0, 0x0809, , "A")`.
* For **US English**, change it to `PostMessage(0x50, 0, 0x0409, , "A")`.

## License
MIT License. Feel free to modify and share!
