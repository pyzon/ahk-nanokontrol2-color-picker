InitGui:
    guiHidden := false

    BackgroundColor := 0xff323232
    BorderColor := 0xff464646
    CheckerboardColor1 := 0xff5e5e5e
    CheckerboardColor2 := 0xff878787

    Gui, Picker:New, ToolWindow AlwaysOnTop +HwndPickerHwnd, Color Picker
    Gui, Picker:Show, w310 h270

    sf := new Canvas.Surface(310, 270)
    vp := new Canvas.Viewport(PickerHwnd).Attach(sf)

    backgroundBrush := new Canvas.SolidBrush(BackgroundColor)
    borderBrush := new Canvas.SolidBrush(BorderColor)

    cross := new Canvas.Surface
    cross.Load(A_ScriptDir . "\images\cross.png")
    thumb := new Canvas.Surface
    thumb.Load(A_ScriptDir . "\images\thumb.png")
    square := new Canvas.Surface
    square.Load(A_ScriptDir . "\images\square.png")
    
    ASliderBackground := CheckerboardSurface(20, 200, 5, CheckerboardColor1, CheckerboardColor2)
    ColorHolderBackground := CheckerboardSurface(100, 40, 5, CheckerboardColor1, CheckerboardColor2)
    SwatchBackground := CheckerboardSurface(10, 20, 5, CheckerboardColor1, CheckerboardColor2)
    
    gosub, RedrawEverything

    return

RedrawEverything:
    gosub, InitialDraw
    gosub, UpdateRGB
    gosub, RedrawSVContoller
    gosub, RedrawHThumb
    gosub, RedrawAThumb
    gosub, RedrawASlider
    gosub, RedrawColorHolder
    gosub, RedrawSwatches
    return

InitialDraw:
    sf.Clear(BackgroundColor)
    ; current color holder borders
    sf.FillRectangle(borderBrush, 9, 9, 202, 42)
    ; sf.Line(p, 10, 9, 209, 9)
    ; sf.Line(p, 10, 50, 209, 50)
    ; sf.Line(p, 9, 9, 9, 50)
    ; sf.Line(p, 210, 9, 210, 50)
    ; H top and bottom borders
    sf.FillRectangle(borderBrush, 229, 59, 22, 202)
    ; sf.Line(p, 230, 59, 249, 59)
    ; sf.Line(p, 230, 260, 249, 260)
    ; A top and bottom borders
    sf.FillRectangle(borderBrush, 269, 59, 22, 202)
    ; sf.Line(p, 270, 59, 289, 59)
    ; sf.Line(p, 270, 260, 289, 260)
    ; H slider
    p := new Canvas.Pen()
    loop, 200 {
        c := HSV_Convert2RGB((200 - A_Index) / 199, 1, 1)
        p.Color := 0xff<<24|Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
        sf.Line(p, 230, 60 + A_Index - 1, 249, 60 + A_Index - 1)
    }
    vp.Refresh()
    return

RedrawSVContoller:
    sf.FillRectangle(backgroundBrush, 2, 52, 216, 216)
    sf.FillRectangle(borderBrush, 9, 59, 202, 202)
    c := HSV_Convert2RGB(swatches[currentSwatch].H, 1, 1)
    cRGB := Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
    SGradBrush := new Canvas.LinearGradientBrush([10, 60], [210, 60], 0xffffffff, 0xff<<24|cRGB)
    sf.FillRectangle(SGradBrush, 10, 60, 200, 200)
    VGradBrush := new Canvas.LinearGradientBrush([10, 60], [10, 260], 0x00000000, 0xff000000)
    sf.FillRectangle(VGradBrush, 10, 60, 200, 200)
    ; loop, 200 {
    ;     i := A_Index
    ;     loop, 200 {
    ;         j := A_Index
    ;         c := HSV_Convert2RGB(H, (i - 1) / 199, (200 - j) / 199)
    ;         ARGB := 0xff<<24|Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
    ;         sf.SetPixel(10 + i - 1, 60 + j - 1, ARGB)
    ;     }
    ; }
    sf.Draw(cross, 2 + Round(swatches[currentSwatch].S * 199), 52 + 199 - Round(swatches[currentSwatch].V * 199), 17, 17)
    vp.Refresh(2, 52, 216, 216)
    return

RedrawHThumb:
    sf.FillRectangle(backgroundBrush, 222, 55, 8, 210)
    sf.FillRectangle(backgroundBrush, 250, 55, 8, 210)
    sf.FillRectangle(borderBrush, 229, 59, 1, 202)
    sf.FillRectangle(borderBrush, 250, 59, 1, 202)
    sf.Draw(thumb, 222, 55 + 199 - Round(swatches[currentSwatch].H * 199), 36, 11)
    vp.Refresh(222, 55, 8, 210)
    vp.Refresh(250, 55, 8, 210)
    return

RedrawAThumb:
    sf.FillRectangle(backgroundBrush, 262, 55, 8, 210)
    sf.FillRectangle(backgroundBrush, 290, 55, 8, 210)
    sf.FillRectangle(borderBrush, 269, 59, 1, 202)
    sf.FillRectangle(borderBrush, 290, 59, 1, 202)
    sf.Draw(thumb, 262, 55 + 199 - Round(swatches[currentSwatch].A * 199), 36, 11)
    vp.Refresh(262, 55, 8, 210)
    vp.Refresh(290, 55, 8, 210)
    return

RedrawASlider:
    sf.Draw(ASliderBackground, 270, 60, 20, 200)
    AGradBrush := new Canvas.LinearGradientBrush([270, 60], [270, 260], 0xff<<24|RGB, RGB)
    sf.FillRectangle(AGradBrush, 270, 60, 20, 200)
    vp.Refresh(270, 60, 20, 200)
    return

RedrawColorHolder:
    sf.Draw(ColorHolderBackground, 110, 10, 100, 40)
    sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|RGB), 10, 10, 100, 40)
    sf.FillRectangle(new Canvas.SolidBrush(Round(swatches[currentSwatch].A*255)<<24|RGB), 110, 10, 100, 40)
    vp.Refresh(10, 10, 200, 40)
    return

RedrawCurrentSwatch:
    x := 220 + mod(currentSwatch - 1, 4) * 20
    y := 10 + (currentSwatch - 1) // 4 * 20
    sf.Draw(SwatchBackground, x + 10, y, 10, 20)
    sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|RGB), x, y, 10, 20)
    sf.FillRectangle(new Canvas.SolidBrush(Round(swatches[currentSwatch].A*255)<<24|RGB), x + 10, y, 10, 20)
    vp.Refresh(x, y, 20, 20)
    return

RedrawSwatches:
    sf.FillRectangle(backgroundBrush, 217, 7, 86, 46)
    for i, sw in swatches {
        x := 220 + mod(i - 1, 4) * 20
        y := 10 + (i - 1) // 4 * 20
        sf.Draw(SwatchBackground, x + 10, y, 10, 20)
        c := HSV_Convert2RGB(sw.H, sw.S, sw.V)
        RGB := Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
        sf.FillRectangle(new Canvas.SolidBrush(0xff<<24|RGB), x, y, 10, 20)
        sf.FillRectangle(new Canvas.SolidBrush(Round(sw.A*255)<<24|RGB), x + 10, y, 10, 20)
    }
    sf.Draw(square, 220 + mod(currentSwatch - 1, 4) * 20 - 3, 10 + (currentSwatch - 1) // 4 * 20 - 3, 26, 26)
    vp.Refresh(217, 7, 86, 46)
    return

UpdateRGB:
    c := HSV_Convert2RGB(swatches[currentSwatch].H, swatches[currentSwatch].S, swatches[currentSwatch].V)
    RGB := Round(c.R*255)<<16|Round(c.G*255)<<8|Round(c.B*255)
    return

CheckerboardSurface(Width, Height, TileWidth, FirstColor, SecondColor) {
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
    gosub, RedrawSVContoller
    gosub, RedrawHThumb
    gosub, RedrawAThumb
    gosub, RedrawASlider
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
HChanged:
    gosub, UpdateRGB
    gosub, RedrawSVContoller
    gosub, RedrawHThumb
    gosub, RedrawASlider
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
SChanged:
    gosub, UpdateRGB
    gosub, RedrawSVContoller
    gosub, RedrawASlider
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
VChanged:
    gosub, UpdateRGB
    gosub, RedrawSVContoller
    gosub, RedrawASlider
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
AChanged:
    gosub, UpdateRGB
    gosub, RedrawAThumb
    gosub, RedrawColorHolder
    gosub, RedrawCurrentSwatch
    return
currentSwatchChanged:
    gosub, UpdateRGB
    gosub, RedrawSVContoller
    gosub, RedrawHThumb
    gosub, RedrawAThumb
    gosub, RedrawASlider
    gosub, RedrawColorHolder
    gosub, RedrawSwatches

#include .\canvas\Canvas.ahk
#include HSV.ahk
