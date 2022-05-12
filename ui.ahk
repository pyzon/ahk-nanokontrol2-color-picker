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

    bgBr := new Canvas.SolidBrush(backgroundColor)
    tbBr := new Canvas.SolidBrush(titleBarColor)
    bBr := new Canvas.SolidBrush(borderColor)

    cross := new Canvas.Surface
    cross.Load(A_ScriptDir . "\images\cross.png")
    thumb := new Canvas.Surface
    thumb.Load(A_ScriptDir . "\images\thumb.png")
    square := new Canvas.Surface
    square.Load(A_ScriptDir . "\images\square.png")
    
    alphaSliderBackground := CheckerSurface(sliderW, sliderH, checkerTileW, checkerColor1, checkerColor2)
    colorHolderBackground := CheckerSurface(colorHolderWHalf, colorHolderH, checkerTileW, checkerColor1, checkerColor2)
    swatchBackground := CheckerSurface(swatchWHalf, swatchH, checkerTileW, checkerColor1, checkerColor2)
    
    gosub, RedrawEverything

    return

RedrawEverything:
    gosub, InitialDraw
    gosub, UpdateRGB
    gosub, RedrawXY_Contoller
    gosub, RedrawZ_Thumb
    gosub, RedrawA_Thumb
    gosub, RedrawA_Slider
    gosub, RedrawColorHolder
    gosub, RedrawSwatches
    return

InitialDraw:
    ; things to draw only once, because they never get updated
    sf.Clear(backgroundColor)
    ; title bar
    sf.FillRectangle(tbBr, 0, 0, windowW, titleBarH)
    ; current color holder borders
    sf.FillRectangle(bBr, colorHolderX - borderW, colorHolderY - borderW, colorHolderW + 2 * borderW, colorHolderH + 2 * borderW)
    ; Z slider top and bottom borders
    sf.FillRectangle(bBr, Z_SliderX, Z_SliderY - borderW, sliderW, sliderH + 2 * borderW)
    ; A slider top and bottom borders
    sf.FillRectangle(bBr, A_SliderX, A_SliderY - borderW, sliderW, sliderH + 2 * borderW)
    ; Hue scale on Z slider
    p := new Canvas.Pen()
    loop, %sliderH% {
        c := HSV_Convert2RGB((sliderH - A_Index) / (sliderH - 1), 1, 1)
        p.Color := 0xff<<24|Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
        sf.Line(p, Z_SliderX, Z_SliderY + A_Index - 1, Z_SliderX + sliderW - 1, Z_SliderY + A_Index - 1)
    }
    vp.Refresh()
    return

RedrawXY_Contoller:
    sf.FillRectangle(bgBr, XY_CtrlX - crossWH, XY_CtrlY - crossWH, XY_CtrlW + 2 * crossWH, XY_CtrlH + 2 * crossWH)
    sf.FillRectangle(bBr, XY_CtrlX - borderW, XY_CtrlY - borderW, XY_CtrlW + 2 * borderW, XY_CtrlH + 2 * borderW)
    c := HSV_Convert2RGB(swatches[currentSwatch].H, 1, 1)
    cRGB := Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
    SGradBrush := new Canvas.LinearGradientBrush([XY_CtrlX, XY_CtrlY], [XY_CtrlX + XY_CtrlW, XY_CtrlY], 0xffffffff, 0xff<<24|cRGB)
    sf.FillRectangle(SGradBrush, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH)
    VGradBrush := new Canvas.LinearGradientBrush([XY_CtrlX, XY_CtrlY], [XY_CtrlX, XY_CtrlY + XY_CtrlH], 0x00000000, 0xff000000)
    sf.FillRectangle(VGradBrush, XY_CtrlX, XY_CtrlY, XY_CtrlW, XY_CtrlH)
    ; loop, 200 {
    ;     i := A_Index
    ;     loop, 200 {
    ;         j := A_Index
    ;         c := HSV_Convert2RGB(H, (i - 1) / 199, (200 - j) / 199)
    ;         ARGB := 0xff<<24|Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
    ;         sf.SetPixel(10 + i - 1, 60 + j - 1, ARGB)
    ;     }
    ; }
    sf.Draw(cross
        , XY_CtrlX - crossWH + Round(swatches[currentSwatch].S * (XY_CtrlW - 1))
        , XY_CtrlY - crossWH + (XY_CtrlH - 1) - Round(swatches[currentSwatch].V * (XY_CtrlH - 1))
        , crossW, crossW)
    vp.Refresh(XY_CtrlX - crossWH, XY_CtrlY - crossWH, XY_CtrlW + 2 * crossWH, XY_CtrlH + 2 * crossWH)
    return

RedrawZ_Thumb:
    ; clear area under left half of thumb
    sf.FillRectangle(bgBr, Z_SliderX - thumbWH, Z_SliderY - thumbHH, thumbWH, sliderH + 2 * thumbHH)
    ; clear area under right half of thumb
    sf.FillRectangle(bgBr, Z_SliderX + sliderW, Z_SliderY - thumbHH, thumbWH, sliderH + 2 * thumbHH)
    ; left border
    sf.FillRectangle(bBr, Z_SliderX - borderW, Z_SliderY - borderW, borderW, sliderH + 2 * borderW)
    ; right border
    sf.FillRectangle(bBr, Z_SliderX + sliderW - borderW, Z_SliderY - borderW, borderW, sliderH + 2 * borderW)
    sf.Draw(thumb
        , Z_SliderX - thumbWH
        , Z_SliderY - thumbHH + (sliderH - 1) - Round(swatches[currentSwatch].H * (sliderH - 1))
        , thumbW, thumbH)
    vp.Refresh(Z_SliderX - thumbWH, Z_SliderY - thumbHH, thumbWH, sliderH + 2 * thumbHH)
    vp.Refresh(Z_SliderX + sliderW, Z_SliderY - thumbHH, thumbWH, sliderH + 2 * thumbHH)
    return

RedrawA_Thumb:
    ; clear area under left half of thumb
    sf.FillRectangle(bgBr, A_SliderX - thumbWH, A_SliderY - thumbHH, thumbWH, sliderH + 2 * thumbHH)
    sf.FillRectangle(bgBr, A_SliderX + sliderW, A_SliderY - thumbHH, thumbWH, sliderH + 2 * thumbHH)
    sf.FillRectangle(bBr, A_SliderX - borderW, A_SliderY - borderW, borderW, sliderH + 2 * borderW)
    sf.FillRectangle(bBr, A_SliderX + sliderW - borderW, A_SliderY - borderW, borderW, sliderH + 2 * borderW)
    sf.Draw(thumb
        , A_SliderX - thumbWH
        , A_SliderY - thumbHH + (sliderH - 1) - Round(swatches[currentSwatch].A * (sliderH - 1))
        , thumbW, thumbH)
    vp.Refresh(A_SliderX - thumbWH, A_SliderY - thumbHH, thumbWH, sliderH + 2 * thumbHH)
    vp.Refresh(A_SliderX + sliderW, A_SliderY - thumbHH, thumbWH, sliderH + 2 * thumbHH)
    return

RedrawA_Slider:
    sf.Draw(alphaSliderBackground, A_SliderX, A_SliderY, sliderW, sliderH)
    AGradBrush := new Canvas.LinearGradientBrush([A_SliderX, A_SliderY], [A_SliderX, A_SliderY + sliderH], 0xff<<24|RGB, RGB)
    sf.FillRectangle(AGradBrush, A_SliderX, A_SliderY, sliderW, sliderH)
    vp.Refresh(A_SliderX, A_SliderY, sliderW, sliderH)
    return

RedrawColorHolder:
    sf.Draw(colorHolderBackground, colorHolderX + colorHolderWHalf, colorHolderY, colorHolderWHalf, colorHolderH)
    sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|RGB), colorHolderX, colorHolderY, colorHolderWHalf, colorHolderH)
    sf.FillRectangle(new Canvas.SolidBrush(Round(swatches[currentSwatch].A*255)<<24|RGB)
        , colorHolderX + colorHolderWHalf, colorHolderY, colorHolderWHalf, colorHolderH)
    vp.Refresh(colorHolderX, colorHolderY, colorHolderW, colorHolderH)
    return

RedrawCurrentSwatch:
    x := swatchesX + mod(currentSwatch - 1, 4) * swatchW
    y := swatchesY + (currentSwatch - 1) // 4 * swatchH
    sf.Draw(swatchBackground, x + swatchWHalf, y, swatchWHalf, swatchH)
    sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|RGB), x, y, swatchWHalf, swatchH)
    sf.FillRectangle(new Canvas.SolidBrush(Round(swatches[currentSwatch].A*255)<<24|RGB), x + swatchWHalf, y, swatchWHalf, swatchH)
    vp.Refresh(x, y, swatchW, swatchH)
    return

RedrawSwatches:
    sf.FillRectangle(bgBr, swatchesX - squareE, swatchesY - squareE, swatchesW + 2 * squareE, swatchesH + 2 * squareE)
    sf.FillRectangle(bBr, swatchesX - borderW, swatchesY - borderW, swatchesW + 2 * borderW, swatchesH + 2 * borderW)
    for i, sw in swatches {
        x := swatchesX + mod(i - 1, 4) * swatchW
        y := swatchesY + (i - 1) // 4 * swatchH
        sf.Draw(swatchBackground, x + swatchWHalf, y, swatchWHalf, swatchH)
        c := HSV_Convert2RGB(sw.H, sw.S, sw.V)
        RGB := Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
        sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|RGB), x, y, swatchWHalf, swatchH)
        sf.FillRectangle(new Canvas.SolidBrush(Round(sw.A*255)<<24|RGB), x + swatchWHalf, y, swatchWHalf, swatchH)
    }
    sf.Draw(square
        , swatchesX + mod(currentSwatch - 1, 4) * swatchW - squareE
        , swatchesY + (currentSwatch - 1) // 4 * swatchH - squareE
        , squareW, squareH)
    vp.Refresh(swatchesX - squareE, swatchesY - squareE, swatchesW + 2 * squareE, swatchesH + 2 * squareE)
    return

UpdateRGB:
    c := HSV_Convert2RGB(swatches[currentSwatch].H, swatches[currentSwatch].S, swatches[currentSwatch].V)
    RGB := Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
    return

CheckerSurface(Width, Height, TileWidth, FirstColor, SecondColor) {
    sf := new Canvas.Surface(Width, Height)
    sf.Clear(FirstColor)
    b := new Canvas.SolidBrush(SecondColor)
    i := 0
    while i < Width / TileWidth {
        j := 0
        while j < Height / TileWidth {
            if (mod(i + j, 2) == 1) {
                x := i * TileWidth
                y := j * TileWidth
                w := TileWidth
                h := TileWidth
                if (TileWidth > Width - x) {
                    w := Width - x
                }
                if (TileWidth > Height - y) {
                    h := Height - y
                }
                sf.FillRectangle(b, x, y, w, h)
            }
            j++
        }
        i++
    }
    return sf
}

HSVChanged:
    gosub, UpdateRGB
    gosub, RedrawXY_Contoller
    gosub, RedrawZ_Thumb
    gosub, RedrawA_Thumb
    gosub, RedrawA_Slider
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
HChanged:
    gosub, UpdateRGB
    gosub, RedrawXY_Contoller
    gosub, RedrawZ_Thumb
    gosub, RedrawA_Slider
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
SChanged:
    gosub, UpdateRGB
    gosub, RedrawXY_Contoller
    gosub, RedrawA_Slider
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
VChanged:
    gosub, UpdateRGB
    gosub, RedrawXY_Contoller
    gosub, RedrawA_Slider
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
AChanged:
    gosub, UpdateRGB
    gosub, RedrawA_Thumb
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
currentSwatchChanged:
    gosub, UpdateRGB
    gosub, RedrawXY_Contoller
    gosub, RedrawZ_Thumb
    gosub, RedrawA_Thumb
    gosub, RedrawA_Slider
    gosub, RedrawColorHolder
    gosub, RedrawSwatches


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
            gosub, SChanged
            gosub, VChanged
        }
        if (x >= Z_SliderX && x < Z_SliderX + sliderW && y >= Z_SliderY && y < Z_SliderY + sliderH) {
            currentSlider := "H"
            swatches[currentSwatch].H := ((sliderH - 1) - (y - Z_SliderY)) / (sliderH - 1)
            gosub, HChanged
        }
        if (x >= A_SliderX && x < A_SliderX + sliderW && y >= A_SliderY && y < A_SliderY + sliderH) {
            currentSlider := "A"
            swatches[currentSwatch].A := ((sliderH - 1) - (y - A_SliderY)) / (sliderH - 1)
            gosub, AChanged
        }
        if (x >= swatchesX && x < swatchesX + swatchesW && y >= swatchesY && y < swatchesY + swatchesH) {
            currentSwatch := ((y - swatchesY) // swatchH) * 4 + ((x - swatchesX) // swatchW) + 1
            gosub, currentSwatchChanged
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
                gosub, SChanged
                gosub, VChanged
            case "H":
                swatches[currentSwatch].H := y < Z_SliderY ? 1
                : y >= Z_SliderY + sliderH ? 0
                : ((sliderH - 1) - (y - Z_SliderY)) / (sliderH - 1)
                gosub, HChanged
            case "A":
                swatches[currentSwatch].A := y < A_SliderY ? 1
                : y >= A_SliderY + sliderH ? 0
                : ((sliderH - 1) - (y - A_SliderY)) / (sliderH - 1)
                gosub, AChanged
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
