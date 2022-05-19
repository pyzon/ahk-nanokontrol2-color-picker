### version 1.0.0

- It is a tool window that is always on top and not showing on the taskbar nor the Alt+Tab list
- There are H, S, V, and A sliders that can be set with the first four sliders of the MIDI controller.
- The controller does its job even if the window is not active.
- There is a color holder rectangle that shows the current color.
- The third R button on the controller sends the current color code in the usual hexadecimal rrggbb format.
- The fourth R button sends the color with the alpha value in rrggbbaa format.
- The Record button can pick the color of the pixel where the cursor is. You can pick a color from anywhere on the screen.
- The buttons that have a function are lit so it's easier to find them. I don't know about other MIDI controllers but in the case of the nanoKONTROL2, this can be done by simply sending back the same note which the button is generating.

### version 1.0.1

- The sliders can be changed with mouse as well (click and drag).

### version 1.0.2

- The current color is saved to an ini file on exit and loaded back on start.
- Added # versions of the color insertion. The third M button sends the current color with a #. The fourth M button sends the current color with aplha and a #.

### version 1.1.0

- Complete GUI rework, with GDI+.
- The Saturation and Value sliders are replaced by a two-dimensional SV-controller.
- The mouse click-and-drag functions work with the new desing as well.
- There are 8 swatches, one of which is always selected and can be changed with the controls.
- All of the swatches are saved in the ini.
- The swatches can be selected with the Solo 1 to 4 and Mute 1 to 4 buttons and also by clicking them.
- The current color holder and each swatch show the aplha as well. The left half shows the opaque color and the right half shows the color with alpha in front of a checkerboard pattern background.
- The color code send buttons have been moved.
  - Rewind button: rrggbb
  - Fast forward button: #rrggbb
  - Stop button: rrggbbaa
  - Play button: #rrggbbaa
- The Cycle button can be used to hide/show the tool window. The program keeps running in the background when the window is hidden.
- Added code templates to set up hotkeys for the MIDI button functions, so the tool is useable even if there is no MIDI controller connected.

### version 1.1.1

- The traditional window title is replaced bar with a modern looking custom one. The new title bar has the following features.
  - Move the window by dragging the title bar.
  - Close the window (but not the app) by clicking the X in the top left corner.
  - Open a menu by clicking the menu button top right corner.
- The menu has the following options.
  - Chose a mode: Hue, Saturation, or Value. This setting determines which parameter should be on the first slider. The other two parameters can be set via the XY controller.
  - True Colors switch: check it, if you want to see the true colors on the hue scale at all times. Uncheck it for a better view of the hue.
  - Exit: exits the app.
- The tray icon is replaced with a nice rainbow circle icon.
- The tray icon menu is reworked. It no longer contains the default menu items, but the following ones:
  - Open: opens the color picker window. Same as if you click on the tray icon with the left mouse button.
  - Chose a MIDI-in device (unchanged).
  - Exit: exits the app.
