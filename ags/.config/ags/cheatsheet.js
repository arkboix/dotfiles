import { App, Window, Widget } from "ags";

const cheatsheetWindow = () => Window({
    name: "cheatsheet",
    visible: false,
    anchor: ['top', 'bottom', 'left', 'right'], // Fullscreen overlay
    child: Widget.Box({
        vertical: true,
        css: "background-color: rgba(0, 0, 0, 0.8); padding: 30px; border-radius: 10px;",
        children: [
            Widget.Label({
                label: "Hyprland Cheatsheet",
                css: "font-size: 24px; font-weight: bold; color: yellow;",
            }),
            Widget.Label({ label: " " }),
            Widget.Label({ label: "[ Windows ]", css: "color: cyan; font-weight: bold;" }),
            Widget.Label({ label: "SUPER+SHIFT+Arrow   Move Window" }),
            Widget.Label({ label: "SUPER+ALT+Arrow     Resize Window" }),
            Widget.Label({ label: "SUPER+T             Toggle Floating" }),
            Widget.Label({ label: "SUPER+F             Fullscreen" }),
            Widget.Label({ label: " " }),
            Widget.Label({ label: "[ Workspaces ]", css: "color: cyan; font-weight: bold;" }),
            Widget.Label({ label: "SUPER+[1-9,0]       Switch workspace" }),
            Widget.Label({ label: "SUPER+SHIFT+[1-9,0] Move window to workspace" }),
            Widget.Label({ label: "SUPER+S             Special workspace" }),
            Widget.Label({ label: "SUPER+N             Cycle Layout" }),
            Widget.Label({ label: " " }),
            Widget.Label({ label: "[ Apps ]", css: "color: cyan; font-weight: bold;" }),
            Widget.Label({ label: "SUPER+B  Browser" }),
            Widget.Label({ label: "SUPER+A  Video Editor" }),
            Widget.Label({ label: "SUPER+C  Wallpaper Selector" }),
            Widget.Label({ label: "SUPER+R  Color Picker" }),
            Widget.Label({ label: "SUPER+D  Emoji Picker" }),
            Widget.Label({ label: "SUPER+TAB Window Switcher" }),
            Widget.Label({ label: "SUPER+RETURN Terminal" }),
            Widget.Label({ label: " " }),
            Widget.Label({ label: "[ Misc ]", css: "color: cyan; font-weight: bold;" }),
            Widget.Label({ label: "ALT+X   Random Wallpaper" }),
            Widget.Label({ label: "Print   Screenshot" }),
            Widget.Label({ label: "SUPER+V Clipboard Manager" }),
        ],
    }),
});

// Define the App with the cheatsheet window
export default App({
    windows: [cheatsheetWindow()],
});

// Toggle the window with a global function
globalThis.toggle_cheatsheet = () => {
    const win = App.getWindow("cheatsheet");
    win.visible = !win.visible;
};
