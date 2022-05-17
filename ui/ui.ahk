#include .\canvas\Canvas.ahk
#include .\color\HSV.ahk
#include .\ui\menu.ahk
#include .\ui\mouse.ahk

InitGui:
    gosub, InitConstants

    ; Set up window and canvas

    guiHidden := false
    closeButtonHover := false
    menuButtonHover := false
    currentMouseDrag := "" ; Keeps track of whatever that has been clicked and dragged
    windowActive := true

    Gui, Picker:New, -Caption ToolWindow AlwaysOnTop +HwndPickerHwnd, Color Picker
    FrameShadow(PickerHwnd)
    Gui, Picker:Show, w%windowW% h%windowH%
    DllCall("RegisterShellHookWindow", UInt, PickerHwnd)
    MsgNum := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
    OnMessage(MsgNum, "ShellMessage")

    sf := new Canvas.Surface(windowW, windowH)
    vp := new Canvas.Viewport(PickerHwnd).Attach(sf)

    SetUpMenu()

    Redraw()
return

InitConstants:

    ; Colors

    titleBarBgColor := 0xff232324
    titleBarFgColor := 0xfff7f7f7
    titleBarBgColor2 := 0xff3e3f41
    titleBarFgColor2 := 0xff8e8e92
    backgroundColor := 0xff313233
    borderColor := 0xff464646
    checkerColor1 := 0xff5e5e5e
    checkerColor2 := 0xff878787
    closeButtonColor := 0xffd61a1a
    menuButtonBgColor := 0xff5c5e60

    ; Brushes and Pens

    titleBarBgBr := new Canvas.SolidBrush(titleBarBgColor)
    titleBarFgBr := new Canvas.SolidBrush(titleBarFgColor)
    titleBarFgP := new Canvas.Pen(titleBarFgColor)
    titleBarBgBr2 := new Canvas.SolidBrush(titleBarBgColor2)
    titleBarFgBr2 := new Canvas.SolidBrush(titleBarFgColor2)
    titleBarFgP2 := new Canvas.Pen(titleBarFgColor2)
    borderBr := new Canvas.SolidBrush(borderColor)
    closeButtonBr := new Canvas.SolidBrush(closeButtonColor)
    menuButtonBr := new Canvas.SolidBrush(menuButtonBgColor)

    ; Sizes and Positions

    titleBarH := 21
    bodyH := 270
    windowW := 310
    windowH := titleBarH + bodyH

    colorHolderW := 200
    colorHolderW_Half := colorHolderW / 2
    colorHolderH := 40
    colorHolderX := 10
    colorHolderY := titleBarH + 10

    XY_CtrlW := 200
    XY_CtrlH := 200
    XY_CtrlX := 10
    XY_CtrlY := colorHolderY + colorHolderH + 10

    swatchW := 20
    swatchW_Half := swatchW / 2
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
    crossWH := crossW // 2 ; half width of the cross
    thumbW := 36 ; width of the whole thumb
    thumbWH := 8 ; width of a single part of the thumb
    thumbH := 11 ; full height of the thumb
    thumbHH := 5 ; half height of the thumb
    squareW := 26 ; full width of the square
    squareH := squareW ; full height of the square
    squareE := 3 ; square edge width

    titleTopMargin := 2

    closeButtonW := 29
    closeButtonW_Half := 14
    closeButtonH := titleBarH
    closeButtonH_Half := titleBarH // 2
    closeButtonX := windowW - closeButtonW
    closeButtonY := 0
    closeXW := 9
    closeXW_Half := closeXW // 2

    menuButtonW := closeButtonW
    menuButtonW_Half := closeButtonW_Half
    menuButtonH := closeButtonH
    menuButtonH_Half := closeButtonH_Half
    menuButtonX := 0
    menuButtonY := closeButtonY
    menuDashDist := 3
    menuDashL := 11
    menuDashL_Half := 5

    ; Fonts

    titleFont := new Canvas.Font("Segoe UI", 12)
    titleFont.Align := "Center"

    ; Images

    cross := new Canvas.Surface
    cross.Load(A_ScriptDir . "\images\cross.png")
    thumb := new Canvas.Surface
    thumb.Load(A_ScriptDir . "\images\thumb.png")
    square := new Canvas.Surface
    square.Load(A_ScriptDir . "\images\square.png")
    hueSlider := new Canvas.Surface
    hueSlider.Load(A_ScriptDir . "\images\hue_slider.png")
    hueX := new Canvas.Surface
    hueX.Load(A_ScriptDir . "\images\hue_x.png")
return

Redraw() {
    global
    ClearWindow()
    DrawTitleBar()
    DrawColorHolder(swatches[currentSwatch])
    DrawSwatches(swatches, currentSwatch)
    DrawXY_Contoller(pickerMode, swatches[currentSwatch])
    DrawZ_Slider(pickerMode, swatches[currentSwatch])
    DrawA_Slider(swatches[currentSwatch])
    vp.Refresh()
}

ClearWindow() {
    global
    sf.Clear(backgroundColor)
}

DrawTitleBar() {
    global
    local xImg
    local bgBr
    local fgBr
    local fgPen
    if (windowActive) {
        bgBr := titleBarBgBr
        fgBr := titleBarFgBr
        fgPen := titleBarFgP
    } else {
        bgBr := titleBarBgBr2
        fgBr := titleBarFgBr2
        fgPen := titleBarFgP2
    }
    local menuPen := fgPen
    sf.FillRectangle(bgBr, 0, 0, windowW, titleBarH)
    sf.Text(fgBr, titleFont, "Color Picker", 0, titleTopMargin, windowW)
    ; close button
    if (closeButtonHover) {
        fgPen := titleBarFgP
        sf.FillRectangle(closeButtonBr, closeButtonX, closeButtonY, closeButtonW, closeButtonH)
    }
    sf.Line(fgPen
    , closeButtonX + closeButtonW_Half - closeXW_Half
    , closeButtonY + closeButtonH_Half - closeXW_Half
    , closeButtonX + closeButtonW_Half + closeXW_Half
    , closeButtonY + closeButtonH_Half + closeXW_Half)
    sf.Line(fgPen
    , closeButtonX + closeButtonW_Half - closeXW_Half
    , closeButtonY + closeButtonH_Half + closeXW_Half
    , closeButtonX + closeButtonW_Half + closeXW_Half
    , closeButtonY + closeButtonH_Half - closeXW_Half)
    ; menu button
    if (menuButtonHover) {
        menuPen := titleBarFgP
        sf.FillRectangle(menuButtonBr, menuButtonX, menuButtonY, menuButtonW, menuButtonH)
    }
    sf.Line(menuPen
    , menuButtonX + menuButtonW_Half - menuDashL_Half
    , menuButtonY + menuButtonH_Half - menuDashDist
    , menuButtonX + menuButtonW_Half + menuDashL_Half
    , menuButtonY + menuButtonH_Half - menuDashDist)
    sf.Line(menuPen
    , menuButtonX + menuButtonW_Half - menuDashL_Half
    , menuButtonY + menuButtonH_Half
    , menuButtonX + menuButtonW_Half + menuDashL_Half
    , menuButtonY + menuButtonH_Half)
    sf.Line(menuPen
    , menuButtonX + menuButtonW_Half - menuDashL_Half
    , menuButtonY + menuButtonH_Half + menuDashDist
    , menuButtonX + menuButtonW_Half + menuDashL_Half
    , menuButtonY + menuButtonH_Half + menuDashDist)
}

DrawXY_Contoller(mode, color) {
    global
    DrawBorder(sf, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH, borderW, borderBr)
    local x
    local y
    switch mode {
    case "Hue":
        local hRGB := HSV2RGB_Number({H: color.H, S: 1, V: 1})
        local SGradBrush := new Canvas.LinearGradientBrush([XY_CtrlX, XY_CtrlY]
        , [XY_CtrlX + XY_CtrlW, XY_CtrlY]
        , 0xffffffff, 0xff<<24|hRGB)
        sf.FillRectangle(SGradBrush, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH)
        local VGradBrush := new Canvas.LinearGradientBrush([XY_CtrlX, XY_CtrlY], [XY_CtrlX, XY_CtrlY + XY_CtrlH]
        , 0x00000000, 0xff000000)
        sf.FillRectangle(VGradBrush, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH)
        x := color.S
        y := color.V
    case "Saturation":
        sf.Draw(hueX, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH)
        local VGradBrush := new Canvas.LinearGradientBrush([XY_CtrlX, XY_CtrlY], [XY_CtrlX, XY_CtrlY + XY_CtrlH]
        , 0x00000000, 0xff000000)
        sf.FillRectangle(VGradBrush, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH)
        x := color.H
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
    case "Hue":
        sf.Draw(hueSlider, Z_SliderX, Z_SliderY, sliderW, sliderH)
        z := color.H
    case "Saturation":
        local hvRGBs1 := HSV2RGB_Number({H: color.H, S: 1, V: color.V})
        local hvRGBs0 := HSV2RGB_Number({H: color.H, S: 0, V: color.V})
        local SGradBrush := new Canvas.LinearGradientBrush([Z_SliderX, Z_SliderY]
        , [Z_SliderX, Z_SliderY + sliderH]
        , 0xff<<24|hvRGBs1, 0xff<<24|hvRGBs0)
        sf.FillRectangle(SGradBrush, Z_SliderX, Z_SliderY, sliderW, sliderH)
        z := color.S
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
    sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|cRGB), colorHolderX, colorHolderY, colorHolderW_Half, colorHolderH)
    ; right side, color with alpha
    DrawChecker(sf
    , colorHolderX + colorHolderW_Half
    , colorHolderY
    , colorHolderW_Half
    , colorHolderH
    , checkerTileW, checkerColor1, checkerColor2)
    sf.FillRectangle(new Canvas.SolidBrush(Round(color.A*255)<<24|cRGB)
    , colorHolderX + colorHolderW_Half, colorHolderY, colorHolderW_Half, colorHolderH)
}

DrawSwatches(swatches, currentSwatch) {
    global
    DrawBorder(sf, swatchesX, swatchesY, swatchesW, swatchesH, borderW, borderBr)
    for i, sw in swatches {
        local x := swatchesX + mod(i - 1, 4) * swatchW
        local y := swatchesY + (i - 1) // 4 * swatchH
        DrawChecker(sf, x + swatchW_Half, y, swatchW_Half, swatchH, checkerTileW, checkerColor1, checkerColor2)
        cRGB := HSV2RGB_Number(sw)
        ; left half, opaque color
        sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|cRGB), x, y, swatchW_Half, swatchH)
        ; right half, color with alpha
        sf.FillRectangle(new Canvas.SolidBrush(Round(sw.A*255)<<24|cRGB), x + swatchW_Half, y, swatchW_Half, swatchH)
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

FrameShadow(HGui) {
    ; makes the captionless window a drop shadow
    ; code borrowed from here: https://www.autohotkey.com/boards/viewtopic.php?t=29117
    DllCall("dwmapi\DwmIsCompositionEnabled","IntP",_ISENABLED) ; Get if DWM Manager is Enabled
    if !_ISENABLED ; if DWM is not enabled, Make Basic Shadow
        DllCall("SetClassLong","UInt",HGui,"Int",-26,"Int",DllCall("GetClassLong","UInt",HGui,"Int",-26)|0x20000)
    else {
        VarSetCapacity(_MARGINS,16)
        NumPut(1,&_MARGINS,0,"UInt")
        NumPut(1,&_MARGINS,4,"UInt")
        NumPut(1,&_MARGINS,8,"UInt")
        NumPut(1,&_MARGINS,12,"UInt")
        DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", HGui, "UInt", 2, "Int*", 2, "UInt", 4)
        DllCall("dwmapi\DwmExtendFrameIntoClientArea", "Ptr", HGui, "Ptr", &_MARGINS)
    }
}

ShellMessage(wParam, lParam)
{
    global PickerHwnd
    global windowActive
    if (wParam = 32772) { ; HSHELL_RUDEAPPACTIVATED
        res := WinActive("ahk_id" PickerHwnd)
        if (res = 0) {
            if (windowActive) {
                windowActive := false
                Redraw()
            }
        } else {
            if (!windowActive) {
                windowActive := true
                Redraw()
            }
        }
    }
}
