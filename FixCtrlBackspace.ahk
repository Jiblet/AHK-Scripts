#NoEnv
#SingleInstance force
SendMode Input

#IfWinActive ahk_exe explorer.exe ; File Explorer
	^Backspace::
#IfWinActive #IfWinActive ahk_class Notepad ahk_exe notepad.exe ahk_exe notepad++.exe
	^Backspace::
	Send ^+{Left}{Backspace}

; source and context: http://superuser.com/a/636973/124606

; relevant documentation links:
; how to write scripts: http://www.autohotkey.com/docs/

; writing hotkeys
; http://www.autohotkey.com/docs/Hotkeys.htm

; list of key codes (including Backspace)
; http://www.autohotkey.com/docs/KeyList.htm

; the #IfWinActive directive
; http://www.autohotkey.com/docs/commands/_IfWinActive.htm

; the Send command
; http://www.autohotkey.com/docs/commands/Send.htm