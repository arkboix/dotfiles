# What are dotfiles?

dotfiles are actually files that are hidden, they begin with a dot, most dotfiles in linux are used to configure your system,
for example, .themes is where you put your external themes in.

# My dotfiles

I have shared my dotfiles in the .config diretory, these are configurations for apps and other stuff

the file "i3" is a config file for i3wm, the window manager i use.

# Installation

install and you're done

this is the kind of experience i have when reading the installation guide of something so might as well do the exact same thing

jokes asside,

## Dependencies

The following dependenices are needed for the configuration to work properly.

`feh, kitty, librewolf, starship, flameshot, xdotool, pamixer, copyq, nemo, cava, tty-clock, i3blocks, picom, nm-applet, blueman-manager, vim, nvim, fontawesome, agave nerd font, fastfetch`

### To install;

#### For Debian-based distributions
``sudo apt update && sudo apt install -y feh kitty flameshot xdotool pamixer copyq nemo cava tty-clock i3blocks picom network-manager-gnome blueman vim neovim fonts-font-awesome fonts-agave fastfetch``

CAUTION: LibreWolf and Starship have to be installed externally. (starship.rs & librewolf.net)

#### For Arch/Arch-based

``sudo pacman -S feh kitty flameshot xdotool pamixer copyq nemo cava tty-clock i3blocks picom network-manager-gnome blueman vim neovim fonts-font-awesome fonts-agave fastfetch``
