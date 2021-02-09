;------------------------ Saved code just in case --------------------

; Write console
;FileAppend, %val%`n, *

; Set the gui slider value
;GuiControl,, H, % H * 360
; This is needed in the control change functions when using sliders
;Gui, Submit, nohide

; Gui Sliders
;~ Gui, Add, Slider, x+0 yp w40 h200 Range0-360 Center Invert Vertical vH gHChanged, %H%
;~ Gui, Add, Slider, x+m yp w40 h200 Range0-100 Center Invert Vertical vS gSChanged, %S%
;~ Gui, Add, Slider, x+m yp w40 h200 Range0-100 Center Invert Vertical vV gVChanged, %V%
;~ Gui, Add, Slider, x+0 yp w40 h200 Range0-255 Center Invert Vertical vR gRChanged, %R%
;~ Gui, Add, Slider, x+m yp w40 h200 Range0-255 Center Invert Vertical vG gGChanged, %G%
;~ Gui, Add, Slider, x+m yp w40 h200 Range0-255 Center Invert Vertical vB gBChanged, %B%


; RGB sliders
;~ slider1(cc, val) {
   ;~ global R
   ;~ global G
   ;~ global B
   ;~ global Picker
   ;~ global ColorHolder
   ;~ Gui, %Picker%:Default
   ;~ Gui, Submit, nohide
   ;~ R := val * 2
   ;~ GuiControl,, R, % R
   ;~ c := Format("+c{1:02X}{2:02X}{3:02X}", R, G, B)
   ;~ GuiControl, %c%, %ColorHolder%
   ;~ gosub RChanged
   ;~ return
;~ }
;~ slider2(cc, val) {
   ;~ global R
   ;~ global G
   ;~ global B
   ;~ global Picker
   ;~ global ColorHolder
   ;~ Gui, %Picker%:Default
   ;~ Gui, Submit, nohide
   ;~ G := val * 2
   ;~ GuiControl,, G, % G
   ;~ c := Format("+c{1:02X}{2:02X}{3:02X}", R, G, B)
   ;~ GuiControl, %c%, %ColorHolder%
   ;~ gosub GChanged
   ;~ return
;~ }
;~ slider3(cc, val) {
   ;~ global R
   ;~ global G
   ;~ global B
   ;~ global Picker
   ;~ global ColorHolder
   ;~ Gui, %Picker%:Default
   ;~ Gui, Submit, nohide
   ;~ B := val * 2
   ;~ GuiControl,, B, % B
   ;~ c := Format("+c{1:02X}{2:02X}{3:02X}", R, G, B)
   ;~ GuiControl, %c%, %ColorHolder%
   ;~ gosub GChanged
   ;~ return
;~ }