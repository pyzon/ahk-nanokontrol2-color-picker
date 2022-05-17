Mouse(nCode, wParam, lParam)
{
    global
    Critical
    WinGetPos, winX, winY,,, ahk_id %PickerHwnd%
    local mouseX := NumGet(lParam+0, 0, "int")
    local mouseY := NumGet(lParam+0, 4, "int")
    local x := mouseX - winX
    local y := mouseY - winY
    local colorX
    local colorY
    local colorZ
    switch wParam {
    case 0x201: ; Left button down
        if (InBoundaries(x, y, menuButtonW, 0, closeButtonX - menuButtonW, titleBarH)) {
            currentMouseDrag := "winMove"
            winGrabX := x
            winGrabY := y
        }
        if (InBoundaries(x, y, closeButtonX, closeButtonY, closeButtonW, closeButtonH)) {
            currentMouseDrag := "close"
        }
        if (InBoundaries(x, y, menuButtonX, menuButtonY, menuButtonW, menuButtonH)) {
            currentMouseDrag := "menu"
        }
        if (InBoundaries(x, y, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH)) {
            currentMouseDrag := "XY"
            colorX := (x - XY_CtrlX) / (XY_CtrlW - 1)
            colorY := ((XY_CtrlH - 1) - (y - XY_CtrlY)) / (XY_CtrlH - 1)
            switch pickerMode {
            case "Hue":
                swatches[currentSwatch].S := colorX
                swatches[currentSwatch].V := colorY
            case "Saturation":
                swatches[currentSwatch].H := colorX
                swatches[currentSwatch].V := colorY
            }
            Redraw()
        }
        if (InBoundaries(x, y, Z_SliderX, Z_SliderY, sliderW, sliderH)) {
            currentMouseDrag := "Z"
            colorZ := ((sliderH - 1) - (y - Z_SliderY)) / (sliderH - 1)
            switch pickerMode {
            case "Hue":
                swatches[currentSwatch].H := colorZ
            case "Saturation":
                swatches[currentSwatch].S := colorZ
            }
            Redraw()
        }
        if (InBoundaries(x, y, A_SliderX, A_SliderY, sliderW, sliderH)) {
            currentMouseDrag := "A"
            swatches[currentSwatch].A := ((sliderH - 1) - (y - A_SliderY)) / (sliderH - 1)
            Redraw()
        }
        if (InBoundaries(x, y, swatchesX, swatchesY, swatchesW, swatchesH)) {
            SelectSwatch(((y - swatchesY) // swatchH) * 4 + ((x - swatchesX) // swatchW) + 1)
            ; currentSwatch := ((y - swatchesY) // swatchH) * 4 + ((x - swatchesX) // swatchW) + 1
            Redraw()
        }
    case 0x200: ; Mouse move
        if GetKeyState("LButton") {
            switch currentMouseDrag {
            case "winMove":
                ; OutputDebug, % mouseX - winGrabX
                WinMove, Color Picker,, mouseX - winGrabX, mouseY - winGrabY
            case "XY":
                ; clamp the value to the edges of the controller
                colorX := x < XY_CtrlX ? 0
                : x >= XY_CtrlX + XY_CtrlW ? 1
                : (x - XY_CtrlX) / (XY_CtrlW - 1)
                colorY := y < XY_CtrlY ? 1
                : y >= XY_CtrlY + XY_CtrlH ? 0
                : ((XY_CtrlH - 1) - (y - XY_CtrlY)) / (XY_CtrlH - 1)
                switch pickerMode {
                case "Hue":
                    swatches[currentSwatch].S := colorX
                    swatches[currentSwatch].V := colorY
                case "Saturation":
                    swatches[currentSwatch].H := colorX
                    swatches[currentSwatch].V := colorY
                }
                Redraw()
            case "Z":
                colorZ := y < Z_SliderY ? 1
                : y >= Z_SliderY + sliderH ? 0
                : ((sliderH - 1) - (y - Z_SliderY)) / (sliderH - 1)
                switch pickerMode {
                case "Hue":
                    swatches[currentSwatch].H := colorZ
                case "Saturation":
                    swatches[currentSwatch].S := colorZ
                }
                Redraw()
            case "A":
                swatches[currentSwatch].A := y < A_SliderY ? 1
                : y >= A_SliderY + sliderH ? 0
                : ((sliderH - 1) - (y - A_SliderY)) / (sliderH - 1)
                Redraw()
            }
        } else {
            if (InBoundaries(x, y, closeButtonX, closeButtonY, closeButtonW, closeButtonH)) {
                if (!closeButtonHover) {
                    closeButtonHover := true
                    Redraw()
                }
            } else {
                if (closeButtonHover) {
                    closeButtonHover := false
                    Redraw()
                }
            }
            if (InBoundaries(x, y, menuButtonX, menuButtonY, menuButtonW, menuButtonH)) {
                if (!menuButtonHover) {
                    menuButtonHover := true
                    Redraw()
                }
            } else {
                if (menuButtonHover) {
                    menuButtonHover := false
                    Redraw()
                }
            }
        }
    case 0x202: ; Left button up
        if (currentMouseDrag = "close") {
            if (InBoundaries(x, y, closeButtonX, closeButtonY, closeButtonW, closeButtonH)) {
                WinHide, ahk_id %PickerHwnd%
            }
        }
        if (currentMouseDrag = "menu") {
            if (InBoundaries(x, y, menuButtonX, menuButtonY, menuButtonW, menuButtonH)) {
                Menu, SettingsMenu, Show, % menuButtonX, % menuButtonY + menuButtonH
            }
        }
        currentMouseDrag := ""
    }
    ; A cool tooltip for debugging:
    ; Tooltip, % (wParam = 0x201 ? "LBUTTONDOWN"
    ;    : wParam = 0x202 ? "LBUTTONUP"
    ;    : wParam = 0x200 ? "MOUSEMOVE"
    ;    : wParam = 0x20A ? "MOUSEWHEEL"
    ;    : wParam = 0x20E ? "MOUSEWHEEL"
    ;    : wParam = 0x204 ? "RBUTTONDOWN"
    ;    : wParam = 0x205 ? "RBUTTONUP"
    ;    : "?")
    ; . " ptX: " . NumGet(lParam+0, 0, "int")
    ; . " ptY: " . NumGet(lParam+0, 4, "int")
    ; . "`nmouseData: " . NumGet(lParam+0, 10, "short")
    ; . " flags: " . NumGet(lParam+0, 12, "uint")
    ; . " time: " . NumGet(lParam+0, 16, "uint")
    Return DllCall("CallNextHookEx", "Uint", 0, "int", nCode, "Uint", wParam, "Uint", lParam)
}

InBoundaries(x, y, boxX, boxY, boxW, boxH) {
    return x >= boxX && x < boxX + boxW && y >= boxY && y < boxY + boxH
}