InitGui:
    ; Colors

    titleBarColor := 0xff262626
    backgroundColor := 0xff323232
    borderColor := 0xff464646
    checkerColor1 := 0xff5e5e5e
    checkerColor2 := 0xff878787

    ; Sizes and Positions

    titleBarH := 20
    bodyH := 270
    windowW := 310
    windowH := titleBarH + bodyH

    colorHolderW := 200
    colorHolderWHalf := colorHolderW / 2
    colorHolderH := 40
    colorHolderX := 10
    colorHolderY := titleBarH + 10

    XY_CtrlW := 200
    XY_CtrlH := 200
    XY_CtrlX := 10
    XY_CtrlY := colorHolderY + colorHolderH + 10

    swatchW := 20
    swatchWHalf := swatchW / 2
    swatchH := 20
    swatchesW := 4 * swatchW
    swatchesH := 2 * swatchH
    swatchesX := colorHolderX + colorHolderW + 10
    swatchesY := titleBarH + 10

    sliderW := 20
    sliderH := 200
    Z_SliderX := XY_CtrlX + XY_CtrlW + 20
    Z_SliderY := swatchesY + swatchesH + 10
    A_SliderX := Z_SliderX + sliderW + 20
    A_SliderY := Z_SliderY

    checkerTileW := 5
    borderW := 1

    crossW := 17 ; full width of the cross
    crossWH := 8 ; half width of the cross
    thumbW := 36 ; width of the whole thumb
    thumbWH := 8 ; width of a single part of the thumb
    thumbH := 11 ; full height of the thumb
    thumbHH := 5 ; half height of the thumb
    squareW := 26 ; full width of the square
    squareH := squareW ; full height of the square
    squareE := 3 ; square edge width

    ; Initializing stuff

    guiHidden := false

    Gui, Picker:New, -Caption ToolWindow AlwaysOnTop +HwndPickerHwnd, Color Picker
    Gui, Picker:Show, w%windowW% h%windowH%

    sf := new Canvas.Surface(windowW, windowH)
    vp := new Canvas.Viewport(PickerHwnd).Attach(sf)

    backgroundBr := new Canvas.SolidBrush(backgroundColor)
    titleBarBr := new Canvas.SolidBrush(titleBarColor)
    borderBr := new Canvas.SolidBrush(borderColor)

    cross := new Canvas.Surface
    cross.Load(A_ScriptDir . "\images\cross.png")
    thumb := new Canvas.Surface
    thumb.Load(A_ScriptDir . "\images\thumb.png")
    square := new Canvas.Surface
    square.Load(A_ScriptDir . "\images\square.png")
    hueSlider := new Canvas.Surface
    hueSlider.Load(A_ScriptDir . "\images\hue_slider.png")
    
    Redraw()
    return

Redraw() {
    global
    ClearWindow()
    DrawTitleBar()
    DrawColorHolder(swatches[currentSwatch])
    DrawSwatches(swatches, currentSwatch)
    DrawXY_Contoller("H", swatches[currentSwatch])
    DrawZ_Slider("H", swatches[currentSwatch])
    DrawA_Slider(swatches[currentSwatch])
    vp.Refresh()
}

ClearWindow() {
    global
    sf.Clear(backgroundColor)
}

DrawTitleBar() {
    global
    sf.FillRectangle(titleBarBr, 0, 0, windowW, titleBarH)
}

DrawXY_Contoller(mode, color) {
    global
    DrawBorder(sf, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH, borderW, borderBr)
    local x
    local y
    switch mode {
        case "H":
            local cRGB := HSV2RGB_Number({H: color.H, S: 1, V: 1})
            local SGradBrush := new Canvas.LinearGradientBrush([XY_CtrlX, XY_CtrlY]
                , [XY_CtrlX + XY_CtrlW, XY_CtrlY]
                , 0xffffffff, 0xff<<24|cRGB)
            sf.FillRectangle(SGradBrush, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH)
            local VGradBrush := new Canvas.LinearGradientBrush([XY_CtrlX, XY_CtrlY], [XY_CtrlX, XY_CtrlY + XY_CtrlH]
                , 0x00000000, 0xff000000)
            sf.FillRectangle(VGradBrush, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH)
            x := color.S
            y := color.V
    }
    sf.Draw(cross
        , XY_CtrlX - crossWH + Round(x * (XY_CtrlW - 1))
        , XY_CtrlY - crossWH + (XY_CtrlH - 1) - Round(y * (XY_CtrlH - 1))
        , crossW, crossW)
}

DrawZ_Slider(mode, color) {
    global
    DrawBorder(sf, Z_SliderX, Z_SliderY, sliderW, sliderH, borderW, borderBr)
    local z
    switch mode {
        case "H":
            sf.Draw(hueSlider, Z_SliderX, Z_SliderY, sliderW, sliderH)
            z := color.H
    }
    sf.Draw(thumb
        , Z_SliderX - thumbWH
        , Z_SliderY - thumbHH + (sliderH - 1) - Round(z * (sliderH - 1))
        , thumbW, thumbH)
}

DrawA_Slider(color) {
    global
    DrawBorder(sf, A_SliderX, A_SliderY, sliderW, sliderH, borderW, borderBr)
    DrawChecker(sf, A_SliderX, A_SliderY, sliderW, sliderH, checkerTileW, checkerColor1, checkerColor2)
    local cRGB := HSV2RGB_Number(color)
    local AGradBrush := new Canvas.LinearGradientBrush([A_SliderX, A_SliderY]
        , [A_SliderX, A_SliderY + sliderH]
        , 0xff<<24|cRGB, cRGB)
    sf.FillRectangle(AGradBrush, A_SliderX, A_SliderY, sliderW, sliderH)
    sf.Draw(thumb
        , A_SliderX - thumbWH
        , A_SliderY - thumbHH + (sliderH - 1) - Round(color.A * (sliderH - 1))
        , thumbW, thumbH)
}

DrawColorHolder(color) {
    global
    DrawBorder(sf, colorHolderX, colorHolderY, colorHolderW, colorHolderH, borderW, borderBr)
    local cRGB := HSV2RGB_Number(color)
    ; left side, opaque color
    sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|cRGB), colorHolderX, colorHolderY, colorHolderWHalf, colorHolderH)
    ; right side, color with alpha
    DrawChecker(sf
        , colorHolderX + colorHolderWHalf
        , colorHolderY
        , colorHolderWHalf
        , colorHolderH
        , checkerTileW, checkerColor1, checkerColor2)
    sf.FillRectangle(new Canvas.SolidBrush(Round(color.A*255)<<24|cRGB)
        , colorHolderX + colorHolderWHalf, colorHolderY, colorHolderWHalf, colorHolderH)
}

DrawSwatches(swatches, currentSwatch) {
    global
    DrawBorder(sf, swatchesX, swatchesY, swatchesW, swatchesH, borderW, borderBr)
    for i, sw in swatches {
        local x := swatchesX + mod(i - 1, 4) * swatchW
        local y := swatchesY + (i - 1) // 4 * swatchH
        DrawChecker(sf, x + swatchWHalf, y, swatchWHalf, swatchH, checkerTileW, checkerColor1, checkerColor2)
        cRGB := HSV2RGB_Number(sw)
        ; left half, opaque color
        sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|cRGB), x, y, swatchWHalf, swatchH)
        ; right half, color with alpha
        sf.FillRectangle(new Canvas.SolidBrush(Round(sw.A*255)<<24|cRGB), x + swatchWHalf, y, swatchWHalf, swatchH)
    }
    sf.Draw(square
        , swatchesX + mod(currentSwatch - 1, 4) * swatchW - squareE
        , swatchesY + (currentSwatch - 1) // 4 * swatchH - squareE
        , squareW, squareH)
}

DrawChecker(Surface, X, Y, Width, Height, TileWidth, FirstColor, SecondColor) {
    checkerSf := new Canvas.Surface(2 * TileWidth, 2 * TileWidth)
    checkerSf.Clear(FirstColor)
    b := new Canvas.SolidBrush(SecondColor)
    checkerSf.FillRectangle(b, 0, 0, TileWidth, TileWidth)
    checkerSf.FillRectangle(b, TileWidth, TileWidth, TileWidth, TileWidth)
    checkerBrush := new Canvas.TextureBrush(checkerSf)
    Surface.FillRectangle(checkerBrush, X, Y, Width, Height)
}
DrawBorder(Surface, X, Y, Width, Height, BorderWidth, BorderBrush) {
    Surface.FillRectangle(BorderBrush, X - BorderWidth, Y - BorderWidth, Width + 2 * BorderWidth, Height + 2 * BorderWidth)
}

HSV2RGB_Number(color) {
    c := HSV_Convert2RGB(color.H, color.S, color.V)
    return Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
}


Mouse(nCode, wParam, lParam)
{
    global
    Critical
    ; global currentSlider
    ; global swatches
    ; global currentSwatch
    ; global PickerHwnd
    ; global XY_CtrlX
    ; global XY_CtrlY
    ; global XY_CtrlW
    ; global XY_CtrlH
    ; global Z_SliderX
    ; global Z_SliderY
    ; global sliderW
    ; global sliderH
    WinGetPos, winX, winY,,, ahk_id %PickerHwnd%
    local x := NumGet(lParam+0, 0, "int") - winX
    local y := NumGet(lParam+0, 4, "int") - winY
    switch wParam {
    case 0x201: ; Left button down
        if (x >= XY_CtrlX && x < XY_CtrlX + XY_CtrlW && y >= XY_CtrlY && y < XY_CtrlY + XY_CtrlH) {
            currentSlider := "SV"
            swatches[currentSwatch].S := (x - XY_CtrlX) / (XY_CtrlW - 1)
            swatches[currentSwatch].V := ((XY_CtrlH - 1) - (y - XY_CtrlY)) / (XY_CtrlH - 1)
            Redraw()
        }
        if (x >= Z_SliderX && x < Z_SliderX + sliderW && y >= Z_SliderY && y < Z_SliderY + sliderH) {
            currentSlider := "H"
            swatches[currentSwatch].H := ((sliderH - 1) - (y - Z_SliderY)) / (sliderH - 1)
            Redraw()
        }
        if (x >= A_SliderX && x < A_SliderX + sliderW && y >= A_SliderY && y < A_SliderY + sliderH) {
            currentSlider := "A"
            swatches[currentSwatch].A := ((sliderH - 1) - (y - A_SliderY)) / (sliderH - 1)
            Redraw()
        }
        if (x >= swatchesX && x < swatchesX + swatchesW && y >= swatchesY && y < swatchesY + swatchesH) {
            currentSwatch := ((y - swatchesY) // swatchH) * 4 + ((x - swatchesX) // swatchW) + 1
            Redraw()
        }
    case 0x200: ; Mouse move
        if GetKeyState("LButton") {
            switch currentSlider {
            case "SV":
                ; clamp the value to the edges of the controller
                swatches[currentSwatch].S := x < XY_CtrlX ? 0
                : x >= XY_CtrlX + XY_CtrlW ? 1
                : (x - XY_CtrlX) / (XY_CtrlW - 1)
                swatches[currentSwatch].V := y < XY_CtrlY ? 1
                : y >= XY_CtrlY + XY_CtrlH ? 0
                : ((XY_CtrlH - 1) - (y - XY_CtrlY)) / (XY_CtrlH - 1)
                Redraw()
            case "H":
                swatches[currentSwatch].H := y < Z_SliderY ? 1
                : y >= Z_SliderY + sliderH ? 0
                : ((sliderH - 1) - (y - Z_SliderY)) / (sliderH - 1)
                Redraw()
            case "A":
                swatches[currentSwatch].A := y < A_SliderY ? 1
                : y >= A_SliderY + sliderH ? 0
                : ((sliderH - 1) - (y - A_SliderY)) / (sliderH - 1)
                Redraw()
            }
        }
    case 0x202: ; Left button up
        currentSlider := ""
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

#include .\canvas\Canvas.ahk
#include HSV.ahk
