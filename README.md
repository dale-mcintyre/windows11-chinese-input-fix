# Windows 11 Caps Lock Chinese/English Input Toggle

A lightweight AutoHotkey (v2) script that fixes the notoriously frustrating multi-language switching layout in Windows 11. It forces your keyboard into a strict binary toggle:

* **Caps Lock Light ON** ➔ Pure Chinese Pinyin Entry (Forces **中** mode, completely destroying the hidden internal English mode).
* **Caps Lock Light OFF** ➔ Pure System English Entry.

## The Problem This Solves
In Windows 11, even if you disable the native `Shift` layout toggle, the Microsoft Pinyin IME stubbornly maintains a hidden internal "English" mode. Windows will randomly switch your keyboard status to **英** depending on what application you click into, forcing you to constantly cycle inputs manually. 

This script hooks directly into `imm32.dll` (the Windows Input Method Manager) to bypass the regular Settings layer, violently forcing the IME status back into Chinese character mode whenever Caps Lock is engaged.

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
If you want this behavior to persist every time you boot your computer:
1. Press `Win + R` to open the Run dialog.
2. Type `shell:startup` and press **Enter** (this opens your Windows Startup directory).
3. Right-click `LanguageToggle.ahk`, select **Copy**, then right-click inside the Startup folder and select **Paste shortcut**.

## Customization
By default, when Caps Lock is toggled off, the script signals Windows to return to your default system English layout. If you use a specific regional layout and find it mismatching, edit line 42 of the script:
* For **UK English**, change `PostMessage(0x50, 0, 0, , "A")` to `PostMessage(0x50, 0, 0x0809, , "A")`.
* For **US English**, change it to `PostMessage(0x50, 0, 0x0409, , "A")`.

## License
MIT License. Feel free to modify and share!
