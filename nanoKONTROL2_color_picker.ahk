/*

nanoKONTROL2 color picker
A color picker tool to be used with a MIDI controller that has at least
four faders and a few buttons. The script is built for KORG nanoKONTROL2
device but can be customised for other devices.

Before using this, open Korg Kontrol Editor and change the Control Mode
to the default CC mode.

The default values for nanoKONTROL2 in CC mode are the following.

Control      | Channel | Note/CC  | Vel/Value | Off vel
-------------+---------+-------- -+-----------+---------
Track left   | 14      | CC 0     | 63        | 64
Track right  | 14      | CC 0     | 65        | 64
Cycle        | 14      | Note 15  | 2         | 64
Marker set   | 14      | Note 33  | 2         | 64
Marker left  | 14      | CC 35    | 63        | 64
Marker right | 14      | CC 35    | 65        | 64
Rewind       | 14      | Note 13  | 2         | 64
Fast forward | 14      | Note 14  | 2         | 64
Stop         | 14      | Note 11  | 2         | 64
Play         | 14      | Note 10  | 2         | 64
Rec          | 14      | Note 12  | 2         | 64
Solo1        | 1       | Note 48  | 127       | 64
Solo2        | 1       | Note 49  | 127       | 64
Solo3        | 1       | Note 50  | 127       | 64
Solo4        | 1       | Note 51  | 127       | 64
Solo5        | 1       | Note 52  | 127       | 64
Solo6        | 1       | Note 53  | 127       | 64
Solo7        | 1       | Note 54  | 127       | 64
Solo8        | 1       | Note 55  | 127       | 64
Mute1        | 1       | Note 60  | 127       | 64
Mute2        | 1       | Note 61  | 127       | 64
Mute3        | 1       | Note 62  | 127       | 64
Mute4        | 1       | Note 63  | 127       | 64
Mute5        | 1       | Note 64  | 127       | 64
Mute6        | 1       | Note 65  | 127       | 64
Mute7        | 1       | Note 66  | 127       | 64
Mute8        | 1       | Note 67  | 127       | 64
Rec1         | 1       | Note 72  | 127       | 64
Rec2         | 1       | Note 73  | 127       | 64
Rec3         | 1       | Note 74  | 127       | 64
Rec4         | 1       | Note 75  | 127       | 64
Rec5         | 1       | Note 76  | 127       | 64
Rec6         | 1       | Note 77  | 127       | 64
Rec7         | 1       | Note 78  | 127       | 64
Rec8         | 1       | Note 79  | 127       | 64
Knob1        | 1       | CC 0     | 0-127     |
Knob2        | 1       | CC 1     | 0-127     |
Knob3        | 1       | CC 2     | 0-127     |
Knob4        | 1       | CC 3     | 0-127     |
Knob5        | 1       | CC 4     | 0-127     |
Knob6        | 1       | CC 5     | 0-127     |
Knob7        | 1       | CC 6     | 0-127     |
Knob8        | 1       | CC 7     | 0-127     |
Slider1      | 1       | CC 36    | 0-127     |
Slider2      | 1       | CC 37    | 0-127     |
Slider3      | 1       | CC 38    | 0-127     |
Slider4      | 1       | CC 39    | 0-127     |
Slider5      | 1       | CC 40    | 0-127     |
Slider6      | 1       | CC 41    | 0-127     |
Slider7      | 1       | CC 42    | 0-127     |
Slider8      | 1       | CC 43    | 0-127     |

*/

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent
#SingleInstance
CoordMode, Mouse, Window
CoordMode, Pixel, Window
SetWinDelay, -1

Menu, Tray, Tip, Color Picker
Menu, Tray, Icon, images\color_wheel.ico
Menu, Tray, Click, 1
Menu, Tray, NoStandard
Menu, Tray, Add, Open, ShowWindow
Menu, Tray, Default, Open

OnExit("ExitFunc")
if (midi_in_Open(0)) ; param: midi in device ID
   ExitApp

Menu, Tray, Add
Menu, Tray, Add, Exit, ExitApp

hHookMouse := DllCall("SetWindowsHookEx", "int", 14, "Uint", RegisterCallback("Mouse", "Fast"), "Uint", 0, "Uint", 0)

hModule := OpenMidiAPI()
h_midiout := midiOutOpen(1) ; param: midi out device ID

;------------------------ Sending midi to light up LEDs ----------------------
; midiOutShortMsg
;   param1: midi out device handle
;   param2: message type
;   param3: channel
;   param4: data1 (note/cc)
;   param5: data2 (vel/val))
midiOutShortMsg(h_midiout, "N1", 14, 13, 127)
midiOutShortMsg(h_midiout, "N1", 14, 14, 127)
midiOutShortMsg(h_midiout, "N1", 14, 11, 127)
midiOutShortMsg(h_midiout, "N1", 14, 10, 127)
midiOutShortMsg(h_midiout, "N1", 14, 12, 127)
midiOutShortMsg(h_midiout, "N1", 14, 15, 127)
midiOutShortMsg(h_midiout, "N1", 1, 48, 127)
midiOutShortMsg(h_midiout, "N1", 1, 49, 127)
midiOutShortMsg(h_midiout, "N1", 1, 50, 127)
midiOutShortMsg(h_midiout, "N1", 1, 51, 127)
midiOutShortMsg(h_midiout, "N1", 1, 60, 127)
midiOutShortMsg(h_midiout, "N1", 1, 61, 127)
midiOutShortMsg(h_midiout, "N1", 1, 62, 127)
midiOutShortMsg(h_midiout, "N1", 1, 63, 127)

;------------------------  MIDI hotkey mappings  ---------------------------
; see the readme (https://github.com/micahstubbs/midi4ahk) for how these work
listenCC(0, "trackLeft", 14)
listenCC(0, "trackRight", 14)
listenNote(15, "cycle", 14)
listenNote(33, "markerSet", 14)
listenCC(35, "markerLeft", 14)
listenCC(35, "markerRight", 14)
listenNote(13, "rewind", 14)
listenNote(14, "fastForward", 14)
listenNote(11, "stop", 14)
listenNote(10, "play", 14)
listenNote(12, "rec", 14)
listenNote(48, "solo1", 1)
listenNote(49, "solo2", 1)
listenNote(50, "solo3", 1)
listenNote(51, "solo4", 1)
listenNote(52, "solo5", 1)
listenNote(53, "solo6", 1)
listenNote(54, "solo7", 1)
listenNote(55, "solo8", 1)
listenNote(60, "mute1", 1)
listenNote(61, "mute2", 1)
listenNote(62, "mute3", 1)
listenNote(63, "mute4", 1)
listenNote(64, "mute5", 1)
listenNote(65, "mute6", 1)
listenNote(66, "mute7", 1)
listenNote(67, "mute8", 1)
listenNote(72, "rec1", 1)
listenNote(73, "rec2", 1)
listenNote(74, "rec3", 1)
listenNote(75, "rec4", 1)
listenNote(76, "rec5", 1)
listenNote(77, "rec6", 1)
listenNote(78, "rec7", 1)
listenNote(79, "rec8", 1)
listenCC(0, "knob1", 1)
listenCC(1, "knob2", 1)
listenCC(2, "knob3", 1)
listenCC(3, "knob4", 1)
listenCC(4, "knob5", 1)
listenCC(5, "knob6", 1)
listenCC(6, "knob7", 1)
listenCC(7, "knob8", 1)
listenCC(36, "slider1", 1)
listenCC(37, "slider2", 1)
listenCC(38, "slider3", 1)
listenCC(39, "slider4", 1)
listenCC(40, "slider5", 1)
listenCC(41, "slider6", 1)
listenCC(42, "slider7", 1)
listenCC(43, "slider8", 1)

; Loading saved state
numberOfSwatches := 8
swatches := []
IniRead, currentSwatch, save.ini, General, CurrentSwatch, 1
loop %numberOfSwatches% {
   IniRead, H, save.ini, % "Swatch" . A_Index, H, 1
   IniRead, S, save.ini, % "Swatch" . A_Index, S, 0
   IniRead, V, save.ini, % "Swatch" . A_Index, V, 0
   IniRead, A, save.ini, % "Swatch" . A_Index, A, 1
   swatches.Push({H:H, S:S, V:V, A:A})
}

gosub, InitGui

return
;------------------------- End of auto execute section -----------------------

ExitApp:
ExitApp

ShowWindow:
   WinShow, ahk_id %PickerHwnd%
   WinActivate, ahk_id %PickerHwnd%
return

ToggleWindowVisibility() {
   global guiHidden
   global PickerHwnd
   if guiHidden {
      WinShow, ahk_id %PickerHwnd%
   } else {
      WinHide, ahk_id %PickerHwnd%
   }
   guiHidden := !guiHidden
return
}

ExitFunc(ExitReason, ExitCode) {
   global h_midiout
   ; Turn off LEDs
   midiOutShortMsg(h_midiout, "N0", 14, 13, 127)
   midiOutShortMsg(h_midiout, "N0", 14, 14, 127)
   midiOutShortMsg(h_midiout, "N0", 14, 11, 127)
   midiOutShortMsg(h_midiout, "N0", 14, 10, 127)
   midiOutShortMsg(h_midiout, "N0", 14, 12, 127)
   midiOutShortMsg(h_midiout, "N0", 14, 15, 127)
   midiOutShortMsg(h_midiout, "N0", 1, 48, 127)
   midiOutShortMsg(h_midiout, "N0", 1, 49, 127)
   midiOutShortMsg(h_midiout, "N0", 1, 50, 127)
   midiOutShortMsg(h_midiout, "N0", 1, 51, 127)
   midiOutShortMsg(h_midiout, "N0", 1, 60, 127)
   midiOutShortMsg(h_midiout, "N0", 1, 61, 127)
   midiOutShortMsg(h_midiout, "N0", 1, 62, 127)
   midiOutShortMsg(h_midiout, "N0", 1, 63, 127)
   ; Close MIDI ports
   midiOutClose(h_midiout)
   midi_in_Close()
   ; Unhook mouse
   DllCall("UnhookWindowsHookEx", "Uint", hHookMouse)
   ; Save state
   global numberOfSwatches
   global swatches
   global currentSwatch
   IniWrite, %currentSwatch%, save.ini, General, CurrentSwatch
   loop %numberOfSwatches% {
      H := swatches[A_Index].H
      S := swatches[A_Index].S
      V := swatches[A_Index].V
      A := swatches[A_Index].A
      IniWrite, %H%, save.ini, % "Swatch" . A_Index, H
      IniWrite, %S%, save.ini, % "Swatch" . A_Index, S
      IniWrite, %V%, save.ini, % "Swatch" . A_Index, V
      IniWrite, %A%, save.ini, % "Swatch" . A_Index, A
   }
   if ErrorLevel {
      MsgBox, There was an error writing the save.ini file
   }
   ; ExitApp not needed
}

PickColorUnderCursor() {
   MouseGetPos, MouseX, MouseY
   PixelGetColor, color, %MouseX%, %MouseY%
   R := (color & 0x0000ff) / 256
   G := ((color & 0x00ff00)>>8) / 256
   B := ((color & 0xff0000)>>16) / 256
   c := HSV_Convert2HSV(R, G, B)
   global swatches
   global currentSwatch
   swatches[currentSwatch].H := c.H
   swatches[currentSwatch].S := c.S
   swatches[currentSwatch].V := c.V
   Redraw()
}
SendColorHexCode(WithHash := false, WithAlpha := false) {
   global swatches
   global currentSwatch
   cRGB := HSV2RGB_Number(swatches[currentSwatch])
   if (WithAlpha) {
      Alpha := Round(swatches[currentSwatch].A*255)
      color := Format("{1:06x}{2:02x}", cRGB, Alpha)
   } else {
      color := Format("{:06x}", cRGB)
   }
   if (WithHash) {
      color := "#" . color
   }
   SendRaw, %color%
}
SelectSwatch(n) {
   global numberOfSwatches
   if (n is not Number or n < 1 or n > numberOfSwatches)
      throw Exception("INVALID_INPUT",-1,"Invalid swatch number: " . n)
   global currentSwatch
   currentSwatch := n
   Redraw()
}

;------------------------ Midi hotkey handler functions ----------------------
; For CC handler
;   param1: cc number
;   param2: value
; For note handler
;   param1: note
;   param2: velocity

; HSVA sliders
slider1(cc, val) {
   global swatches
   global currentSwatch
   swatches[currentSwatch].H := val / 127 ; Scale to range 0 to 1
   Redraw()
return
}
slider2(cc, val) {
   global swatches
   global currentSwatch
   swatches[currentSwatch].S := val / 127 ; Scale to range 0 to 1
   Redraw()
return
}
slider3(cc, val) {
   global swatches
   global currentSwatch
   swatches[currentSwatch].V := val / 127 ; Scale to range 0 to 1
   Redraw()
return
}
slider4(cc, val) {
   global swatches
   global currentSwatch
   swatches[currentSwatch].A := val / 127 ; Scale to range 0 to 1
   Redraw()
return
}

cycle(note, vel) {
   if (vel == 2) {
      ToggleWindowVisibility()
   }
}
rec(note, vel) {
   if (vel == 2) {
      PickColorUnderCursor()
   }
}
rewind(note, vel) {
   if (vel == 2) {
      SendColorHexCode()
   }
}
fastForward(note, vel) {
   if (vel == 2) {
      SendColorHexCode(true)
   }
}
stop(note, vel) {
   if (vel == 2) {
      SendColorHexCode(, true)
   }
}
play(note, vel) {
   if (vel == 2) {
      SendColorHexCode(true, true)
   }
}
solo1(note, vel) {
   if (vel == 127) {
      SelectSwatch(1)
   }
}
solo2(note, vel) {
   if (vel == 127) {
      SelectSwatch(2)
   }
}
solo3(note, vel) {
   if (vel == 127) {
      SelectSwatch(3)
   }
}
solo4(note, vel) {
   if (vel == 127) {
      SelectSwatch(4)
   }
}
mute1(note, vel) {
   if (vel == 127) {
      SelectSwatch(5)
   }
}
mute2(note, vel) {
   if (vel == 127) {
      SelectSwatch(6)
   }
}
mute3(note, vel) {
   if (vel == 127) {
      SelectSwatch(7)
   }
}
mute4(note, vel) {
   if (vel == 127) {
      SelectSwatch(8)
   }
}
;----------------------------------- Hotkeys ---------------------------------
; To set up hotkeys for the functions, chose a hotkey and call the appropriate function.
; Examples:

; Pause::
;    ToggleWindowVisibility()
;    return
; ^Ins::
;    SendColorHexCode(true)
;    return

;----------------------------------- Includes --------------------------------
#include midi_in_lib.ahk
#include HSV.ahk
#include midi_out_functions.ahk
#include .\canvas\Canvas.ahk

#include ui.ahk
