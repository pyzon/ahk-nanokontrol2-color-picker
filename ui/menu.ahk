SetUpMenu() {
    global modeMenuItems := { "H": "Hue", "S": "Saturation", "V": "Value" }
    for key, value in modeMenuItems {
        Menu, ModeMenu, Add, %value%, SelectMode, +Radio
    }
    global pickerMode
    Menu, ModeMenu, Check, % modeMenuItems[pickerMode] ; checkmark the current mode initially
    Menu, SettingsMenu, Add, Mode, :ModeMenu
    Menu, SettingsMenu, Add, True Colors, ToggleTrueColors
    global trueColors
    if (trueColors) {
        Menu, SettingsMenu, Check, True Colors
    }

    Menu, SettingsMenu, Add
    Menu, SettingsMenu, Add, Exit, ExitApplication

    global H_SettingsMenu := MenuGetHandle("SettingsMenu")
}

SelectMode:
    global modeMenuItems
    global pickerMode
    Menu, ModeMenu, Uncheck, % modeMenuItems[pickerMode]
    pickerMode := GetMode(A_ThisMenuItem)
    Menu, ModeMenu, Check, %A_ThisMenuItem%
    Redraw()
return

GetMode(modeText) {
    global modeMenuItems
    for key, value in modeMenuItems {
        if (value = modeText) {
            return key
        }
    }
    throw "mode " . modeText . "not found"
}

ToggleTrueColors:
    trueColors := trueColors ? 0 : 1
    Menu, SettingsMenu, ToggleCheck, True Colors
    Redraw()
return