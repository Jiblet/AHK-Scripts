SetBatchLines, -1

;List of mouse buttons
ExtraButtonList := "LButton|MButton|RButton|XButton1|XButton2|WheelDown|WheelUp"

;List of common vk codes and oem vk codes. Used to retrieve the vk code of a pressed key.
VKFullList :=
(LTrim Join
   "VK01|VK02|VK03|VK04|VK05|VK06|VK08|VK09|VK0C|VK0D|VK10|VK11|VK12|VK13|VK14|VK15|VK17|VK18|VK19|VK1B|
   VK1C|VK1D|VK1E|VK1F|VK20|VK21|VK22|VK23|VK24|VK25|VK26|VK27|VK28|VK29|VK2A|VK2B|VK2C|VK2D|VK2E|VK2F|
   VK30|VK31|VK32|VK33|VK34|VK35|VK36|VK37|VK38|VK39|VK41|VK42|VK43|VK44|VK45|VK46|VK47|VK48|VK49|VK4A|
   VK4B|VK4C|VK4D|VK4E|VK4F|VK50|VK51|VK52|VK53|VK54|VK55|VK56|VK57|VK58|VK59|VK5A|VK5B|VK5C|VK5D|VK5F|
   VK60|VK61|VK62|VK63|VK64|VK65|VK66|VK67|VK68|VK69|VK6A|VK6B|VK6C|VK6D|VK6E|VK6F|VK70|VK71|VK72|VK73|
   VK74|VK75|VK76|VK77|VK78|VK79|VK7A|VK7B|VK7C|VK7D|VK7E|VK7F|VK80|VK81|VK82|VK83|VK84|VK85|VK86|VK87|
   VK90|VK91|VKA0|VKA1|VKA2|VKA3|VKA4|VKA5|VKA6|VKA7|VKA8|VKA9|VKAA|VKAB|VKAC|VKAD|VKAE|VKAF|VKB0|VKB1|
   VKB2|VKB3|VKB4|VKB5|VKB6|VKB7|VKBA|VKBB|VKBC|VKBD|VKBE|VKBF|VKC0|VKDB|VKDC|VKDD|VKDE|VKDF|VKE2|VKE5|
   VKF6|VKF7|VKF8|VKF9|VKFA|VKFB|VKFD|VKFE|VK92|VK93|VK94|VK95|VK96|VKE1|VKE3|VKE4|VKE6|VKE9|VKEA|VKEB|
   VKEC|VKED|VKEE|VKEF|VKF0|VKF1|VKF2|VKF3|VKF4|VKF5|VKFF"
)

PID := DllCall("GetCurrentProcessId")
gui, 1: +LastFound
WinGet, Gui1ID, id
/*
The GLabel of a hotkey control is only triggered when the hotkey control changes.
It is not triggered by uncommon keys like Space or Enter.
Thus, we have to define every possible scan code as a hotkey, to be able to detect every key press.
These hotkeys are destroyed with the Gui.

For the hotkeys that will be generated by the keys chosen in the hotkey controls, we might need to
monitor key ups. KeyWait won't work with a scan code.
For many keys, we can use the key's scancode in a loop looking like :

Loop
{
   If !GetKeyState(ScanCode, "P")
      Break
}

but for some keys it does not work, only the virtual key code will work.
Thus, we detect the vk code by searching for a vk down from an exhaustiv list of vk codes
For some keys, however, like ctrl, shift or alt, the vk code is not detected.
For these keys, this code is written directly in the hotkey name.
*/
HotKey, IfWinActive, Ahk_ID %Gui1ID%
Loop, 16
{
   i := SubStr("0123456789ABCDEF", A_Index, 1)
   Loop, 16
   {
      j := SubStr("0123456789ABCDEF", A_Index, 1)
      If (i j = "38")
      {
         Hotkey, $~SC038VKA4, MonitorKeySCPress, P-2 ;LAlt
         Hotkey, $~SC138VKA5, MonitorKeySCPress, P-2 ;RAlt
      }
      Else If (i j = "37")
      {
         Hotkey, $~SC037, MonitorKeySCPress, P-2
         Hotkey, $$SC137, MonitorKeySCPress, P-2 ;PrintScreen : prevents to destroy the clipboard's content
      }
      Else If (i j = "36")
      {
         Hotkey, $~SC036, MonitorKeySCPress, P-2
         Hotkey, $~SC136VKA1, MonitorKeySCPress, P-2 ;RMaj
      }
      Else If (i j = "2A")
      {
         Hotkey, $~SC02AVKA0, MonitorKeySCPress, P-2 ;LMaj
         Hotkey, $~SC12A, MonitorKeySCPress, P-2
      }
      Else If (i j = "1D")
      {
         Hotkey, $~SC01DVKA2, MonitorKeySCPress, P-2 ;LCtrl
         Hotkey, $~SC11DVKA3, MonitorKeySCPress, P-2 ;RCtrl
      }
      Else If (i j = "0F") ;00F = Tab : key not defined to allow normal control tabbing
         Hotkey, $~SC10F, MonitorKeySCPress, P-2
      Else If (i j != "00")
      {
         Hotkey, $~SC0%i%%j%, MonitorKeySCPress, P-2
         Hotkey, $~SC1%i%%j%, MonitorKeySCPress, P-2
      }
   }
}
Hotkey, <^Tab, MonitorCtrlTabPress, P-1
Loop, Parse, ExtraButtonList, |
   Hotkey, $~%A_LoopField%, MonitorMousePress
Hotkey, IfWinActive
PriorKey =
PriorSCKey =
gui, 1: add, Text, , Super hotkey control :`nKey1
;The V-variable is necessary only to identify the control. It cannot be used to store the hotkey because
;the default G-label modifies this value. The keys are stored in variables named Key[N].
gui, 1: add, Hotkey, vKeyV1 gKey
gui, 1: add, Text, w120, Normal hotkey control :
gui, 1: add, Hotkey
gui, 1: add, Text, w120, Super hotkey controls :
gui, 1: add, Text, w55 y+ Center, Key2
gui, 1: add, Text, x+ w10 Center, +
gui, 1: add, Text, x+ w55 Center, Key3
gui, 1: add, Hotkey, x10 w55 vKeyV3 gKey
gui, 1: add, Text, x+ w10 Center, +
gui, 1: add, Hotkey, x+ w55 vKeyV4 gKey
;Register only some hotkey controls as super hotkey controls (list of instance number of the super controls) :
RegisteredHkList := "|1|3|4|"
;Number of hotkey controls
NbHk = 4
gui, 1: add, Edit, x10 w120 Multi, Edit control
gui, 1: add, Text, w120, After pressing this button, press the chosen keys one at a time, then press them simultaneously.
gui, 1: add, Button, gTest, TEST HOTKEYS!
gui, 1: show, , Gui1
;Monitoring changes of layout, in order to change the content of the hk controls
;according to the new layout. As the hotkeys are saved by scan code, this is only done
;for a display purpose. It does not matter if errors occur (change not detected)
OnMessage(0x50,"OnLayoutChangeRequest") ;0x50 = WM_INPUTLANGCHANGEREQUEST
Return



GuiEscape:
GuiControlGet, FKP, 1: Focus
IfNotInString, FKP, msctls_hotkey32
{
   Gosub, GuiClose
   Return
}
;Retrieve the instance number of the control
HkNbKP := SubStr(FKP, 16)
IfNotInString, RegisteredHkList, |%HkNbKP%|
   Gosub, GuiClose
Return



GuiClose:
Gui, 1: Destroy
HotKey, IfWinActive, Ahk_ID %Gui1ID%
Loop, 16
{
   i := SubStr("0123456789ABCDEF", A_Index, 1)
   Loop, 16
   {
      j := SubStr("0123456789ABCDEF", A_Index, 1)
      If (i j = "38")
      {
         Hotkey, $~SC038VKA4, Off
         Hotkey, $~SC138VKA5, Off
      }
      Else If (i j = "37")
      {
         Hotkey, $~SC037, Off
         Hotkey, $$SC137, Off
      }
      Else If (i j = "36")
      {
         Hotkey, $~SC036, Off
         Hotkey, $~SC136VKA1, Off
      }
      Else If (i j = "2A")
      {
         Hotkey, $~SC02AVKA0, Off
         Hotkey, $~SC12A, Off
      }
      Else If (i j = "1D")
      {
         Hotkey, $~SC01DVKA2, Off
         Hotkey, $~SC11DVKA3, Off
      }
      Else If (i j = "0F")
         Hotkey, $~SC10F, Off
      Else If (i j != "00")
      {
         Hotkey, $~SC0%i%%j%, Off
         Hotkey, $~SC1%i%%j%, Off
      }
   }
}
Hotkey, <^Tab, MonitorCtrlTabPress, Off
Loop, Parse, ExtraButtonList, |
   Hotkey, $~%A_LoopField%, Off
Hotkey, IfWinActive
Return



Key:
Critical
GuiControlGet, F, 6: FocusV
GuiControl, 6:, %F%
Return



MonitorKeySCPress:
GuiControlGet, FKP, 1: Focus
IfNotInString, FKP, msctls_hotkey32
   Return
;Retrieve the instance number of the control
HkNbKP := SubStr(FKP, 16)
IfNotInString, RegisteredHkList, |%HkNbKP%|
   Return
;The thread can be launched more than once at a time, by several hotkeys pressed simultaneously.
;The KeyPressed variable allows it to be launched only once.
If KeyPressed
   Return
KeyPressed = 1
Key := SubStr(A_ThisHotkey, 3)
SCKey := Key
VKKey =
;As KeyWait does not work with a scan code, VK code must be retrieved
;Check if the VK code is already in the hotkey name
IfInString, SCKey, VK
{
   VKKey := SubStr(SCKey, -3)
   SCKey := SubStr(SCKey, 1, -4)
}
;If not, seach for keys down
Else
{
   N =
   Loop, Parse, VKFullList, |
   {
      If GetKeyState(A_LoopField,"P")
      {
         VKKey := A_LoopField
         N++
      }
   }
   ;key not held long enough to detect vk or more than one key down :
   If (N != 1)
      VKKey =

}
If ((VKKey ="VKA2") && GetKeyState("VKA5","P")) ;Workaround for AltGr key : AltGr-->RAlt
{
   VKKey := "VKA5"
   SCKey := "SC138"
   Key = %SCKey%%VKKey%
}
TooltipText = %VKKey%%SCKey% down
SetTimer, RefreshTooltip, 20
SetTimer, RefreshTooltipOff, -3000
If ((SCKey = "SC15B") || (SCKey = "SC15C")) ;15B = LWin ; 15C = RWin
   Send {Blind}{Ctrl} ;Prevent Start menu to popup on release
;We check if GetKeyState works with the scan code.
;If not, the hotkey must have a vk code too to monitor its state.
If !GetkeyState(SCKey, "P")
   Key = %SCKey%%VKKey%
;Note : If !VKKey and !GetkeyState(SCKey, "P") (rare), the key won't stay down if used as a hotkey,
;so it shouldn't be used as a modifier key.
KeyWait %VKKey%
If CtrlTabPressed
{
   Key%HkNbKP% := "SC00F"
   CtrlTabPressed =
}
Else If ((SCKey = "SC00E") &&  Key%HkNbKP%) ;00E = BackSpace
{
   GuiControl, 1:, Key%HkNbKP%
   Key%HkNbKP% =
}
Else If (SCKey = "SC136") ;136 = RShift (RShift produces an empty control)
{
   GuiControl, 1:, KeyV%HkNbKP%, SC036
   Key%HkNbKP% = %Key%
}
Else
{
   GuiControl, 1:, KeyV%HkNbKP%, %SCKey%%Key%
   Key%HkNbKP% = %Key%
}
GuiControlGet, FKP, 1:, KeyV%HkNbKP%
;The key press might not be detected by the control, however it is still usable as a hotkey.
;Thus we input something that produces an empty control (!= "None")
If (!FKP && (VKKey != "00E"))
   GuiControl, 1:, KeyV%HkNbKP%, 00
TooltipText = % VKKey SCKey " up`ndefined hk : " Key%HkNbKP%
SetTimer, RefreshTooltip, 20
SetTimer, RefreshTooltipOff, -3000
KeyPressed =
return



MonitorCtrlTabPress:
Critical
GuiControlGet, FTP, 1: Focus
IfNotInString, FTP, msctls_hotkey32
{
   Send {Blind}{Tab}
   Return
}
HkNbTP := SubStr(FTP, 16)
IfNotInString, RegisteredHkList, |%HkNbTP%|
{
   Send {Blind}{Tab}
   Return
}
If CtrlTabPressed
   Return
CtrlTabPressed = 1
GuiControl, 1:, KeyV%HkNbTP%, Tab
TooltipText = Tab pressed
SetTimer, RefreshTooltip, 20
SetTimer, RefreshTooltipOff, -3000
Return



MonitorMousePress:
Critical
GuiControlGet, F, 1: Focus
IfNotInString, F, msctls_hotkey32
   Return
MouseGetPos, , , , N
If (N != F)
   Return
HkNb := SubStr(F, 16)
IfNotInString, RegisteredHkList, |%HkNb%|
   Return
Key := SubStr(A_ThisHotkey, 3)
TooltipText = %Key%
SetTimer, RefreshTooltip, 20
SetTimer, RefreshTooltipOff, -3000
GuiControl, 1:, KeyV%HkNb%, %Key%
Key%HkNb% = %Key%
GuiControlGet, F, 1:, KeyV%HkNb%
;The key might not be detected by the control, however it is still usable as a hotkey.
;Thus we input something that produces an empty control (!= "None")
If !F
   GuiControl, 1:, KeyV%HkNb%, 00
PriorKey =
Return



Test:
;If a key is used in more than one control, its resulting hotkey will depend on the order
;in which the followng hotkeys are defined.
;Destroy the previous hotkeys
Loop, Parse, EnabledHkList, |
{
   If !A_LoopField
      Continue
   Hotkey, %A_LoopField%, Off
}
Loop, Parse, RegisteredHkList, |
{
   If !A_LoopField
      Continue
   Hotkey, % "*" Key%A_LoopField%, Key%A_LoopField%, On
}
/*   
Hotkey, *%Key1%, Key1
Hotkey, *%Key3%, Key3
Hotkey, *%Key4%, Key4
*/
EnabledHkList = *%Key1%|*%Key3%|*%Key4%
;Disable the gui window because the hotkeys defined for the hotkey controls disables the new defined hotkeys
WinActivate, Ahk_Class Shell_TrayWnd
return



Key1:
If Key1Pressed
   Return
Key1Pressed = 1
If (Key4Pressed && Key3Pressed)
tooltip Key3+Key4+Key1
Else If Key4Pressed
tooltip Key4+Key1
Else If Key3Pressed
tooltip Key3+Key1
Else
tooltip Key1

SC1Key := SubStr(A_ThisHotkey, 2)
VK1Key =
IfInString, SC1Key, VK
{
   VK1Key := SubStr(SC1Key, -3)
   SC1Key := SubStr(SC1Key, 1, -4)
}
If VK1Key
   KeyWait, %VK1Key%
Else
{
   Loop
   {
      If !GetKeyState(SC1Key, "P")
         Break
      Sleep 100
   }
}
tooltip Key1 Up
Key1Pressed =
Return

Key3:
If Key3Pressed
   Return
Key3Pressed = 1
If Key4Pressed
tooltip Key3+Key4
Else
tooltip Key3
SC3Key := SubStr(A_ThisHotkey, 2)
VK3Key =
IfInString, SC3Key, VK
{
   VK3Key := SubStr(SC3Key, -3)
   SC3Key := SubStr(SC3Key, 1, -4)
}
If VK3Key
   KeyWait, %VK3Key%
Else
{
   Loop
   {
      If !GetKeyState(SC3Key, "P")
         Break
      Sleep 100
   }
}
tooltip Key3 Up
Key3Pressed =
Return

Key4:
If Key4Pressed
   Return
Key4Pressed = 1
If Key3Pressed
tooltip Key3+Key4
Else
tooltip Key4
SC4Key := SubStr(A_ThisHotkey, 2)
VK4Key =
IfInString, SC4Key, VK
{
   VK4Key := SubStr(SC4Key, -3)
   SC4Key := SubStr(SC4Key, 1, -4)
}
If VK4Key
   KeyWait, %VK4Key%
Else
{
   Loop
   {
      If !GetKeyState(SC4Key, "P")
         Break
      Sleep 100
   }
}
tooltip Key4 Up
Key4Pressed =
Return



RefreshTooltip:
Tooltip, %TooltipText%
Return
RefreshTooltipOff:
SetTimer, RefreshTooltip, Off
TooltipText =
Tooltip
Return



OnLayoutChangeRequest(wParam, lParam)
{
tooltip %wParam%|%lParam%
   ;Thread that will be launched after layout change
   SetTimer, DetectLayoutChange, -1
}



DetectLayoutChange:
;Note that some changes may happen in normal hotkey controls, but sometimes they are wrong,
;and the hotkey really changes to some other.
Loop, Parse, RegisteredHkList, |
{
   If !A_LoopField
      Continue
   GuiControl, 1:, KeyV%A_LoopField%, % Key%A_LoopField%
   GuiControlGet, FLC, 1:, KeyV%A_LoopField%
   ;The key might not be detected by the control, however it is still usable as a hotkey.
   ;Thus we input something that produces an empty control (!= "None")
   If !FLC
      GuiControl, 1:, KeyV%A_LoopField%, 00
}
;With some layouts, the controls are not repainted properly
WinSet, Redraw, , Ahk_ID %Gui1ID%
Return