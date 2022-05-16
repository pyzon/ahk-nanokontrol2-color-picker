SetUpMenu() {
    global modeMenuItems := [{sub: "SelectModeH", name: "Hue"}
    ,{sub: "SelectModeS", name: "Saturation"}]
    for index, item in modeMenuItems {
        Menu, ModeMenu, Add, % item.name, % item.sub, +Radio
    }
    global pickerMode
    Menu, ModeMenu, Check, % pickerMode ; check the current mode initially
    Menu, SettingsMenu, Add, Picker Mode, :ModeMenu
    Menu, SettingsMenu, Add, Exit, ExitApplication
}

SelectModeH:
    SelectMode("Hue")
return
SelectModeS:
    SelectMode("Saturation")
return

SelectMode(mode) {
    global pickerMode
    pickerMode := mode
    UncheckAllModes()
    Menu, ModeMenu, Check, % mode
    Redraw()
}

UncheckAllModes() {
    global modeMenuItems
    for index, item in modeMenuItems {
        Menu, ModeMenu, Uncheck, % item.name
    }
}