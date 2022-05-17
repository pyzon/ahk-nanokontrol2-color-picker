InitTitleBarConstants:
    titleBarBgColor := 0xff232324
    titleBarFgColor := 0xfff7f7f7
    titleBarBgColor2 := 0xff3e3f41
    titleBarFgColor2 := 0xff8e8e92
    closeButtonColor := 0xffd61a1a
    menuButtonBgColor := 0xff5c5e60

    titleBarBgBr := new Canvas.SolidBrush(titleBarBgColor)
    titleBarFgBr := new Canvas.SolidBrush(titleBarFgColor)
    titleBarFgP := new Canvas.Pen(titleBarFgColor)
    titleBarBgBr2 := new Canvas.SolidBrush(titleBarBgColor2)
    titleBarFgBr2 := new Canvas.SolidBrush(titleBarFgColor2)
    titleBarFgP2 := new Canvas.Pen(titleBarFgColor2)
    closeButtonBr := new Canvas.SolidBrush(closeButtonColor)
    menuButtonBr := new Canvas.SolidBrush(menuButtonBgColor)

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

    titleFont := new Canvas.Font("Segoe UI", 12)
    titleFont.Align := "Center"
return

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