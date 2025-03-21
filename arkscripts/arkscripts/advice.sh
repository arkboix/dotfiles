#!/usr/bin/env sh

#!/bin/bash

# Hardcoded list of wisdom
ADVICE_LIST=(
    "Never trust a fart."
    "If it's stupid but works, it ain't stupid."
    "Eat before you're hungry, drink before you're thirsty."
    "Your dotfiles will never be finished."
    "Alias everything."
    "rm -rf / is a bad idea. Mostly."
    "Your wallpaper, $(~/arkscripts/swww.sh), is bad, change it"
    "Fish is love, Bash is life."
    "If it compiles, ship it."
    "Use Arch, BTW."
    "it works on my machine"
    "Anime girls are everything"
    "Fun Fact: NixOS users have never reproduced anything other than their own distro"
    "lolcat better"
    "stow is gud"
    "AGS sucks"
    "the font is Montserrat Alternates"
    "We charge extra for beans"
    "its Le-Nox"
    "AGS = Alyur's Gay Shell"
    "We have end 4 at home"
    "Dbus"
    "org.hypr.Window is static"
    "never watch anime"
    "meow"
    "How's the femboy?"
    "is this even advice?"
    "ln -s bad"
    "wallust is pretty cool"
    "also try out DWM!"
    "also try out Hyprland!"
    "also try out ML4w!"
    "also try out BSPWM!"
    "also try out Hypr!"
    "also try out Linux!"
    "also try out no games!"
    "quit gaming"
    "A watched 'yay' never builds."
    "Touch grass. But not rm -rf /."
    "Sudo does not mean 'please'."
    "Script everything. Future you will thank you."
    "Hyprland will break. Accept it."
    "99% of bugs are typos. The other 1% is your fault too."
    "Never fight a land war in Asia."
    "Rofi makes everything better."
)

# Pick a random piece of advice
ADVICE="${ADVICE_LIST[RANDOM % ${#ADVICE_LIST[@]}]}"

# Show it in Rofi
echo "$ADVICE" | rofi -dmenu -p "Advice:"
