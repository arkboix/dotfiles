#!/bin/bash

kitty --class=cheatsheet --hold sh -c "
    echo -e '\e[1;34m=== Cheatsheet ===\e[0m'
    echo -e '\e[1;36mKeybinds\e[0m'
    echo -e '\e[1;34m_________\e[0m'
    echo -e '\e[1;32mS + Enter:\e[0m Terminal Kitty'
    echo -e '\e[1;32mC + SPC:\e[0m Rofi App Launcher'
    echo -e '\e[1;32mS + m:\e[0m Exit Hyprland'
    echo -e '\e[1;32mS + d:\e[0m Emoji Picker'
    echo -e '\e[1;32mS + SH + Arrow:\e[0m Move Window'
    echo -e '\e[1;32mS + M + Arrow:\e[0m Resize Window'
    echo -e '\e[1;32mS + Alternate Vim Keys (U I O P):\e[0m Move Focus'
    echo -e '\e[1;32mS + [Num]:\e[0m Switch Workspace'
    echo -e '\e[1;32mS + s:\e[0m Scratchpad'
    echo -e '\e[1;32mS + SH + s:\e[0m Move to scratchpad'
    read -p 'Press enter to close...'
"
