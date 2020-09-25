# Profile file. Runs on login. Is full of enviromental variables

# DEFAULT PROGRAMS

export EDITOR="vim"
export TERMINAL="st"
export BROWSER="elinks"
export READER="zathura"
export FILE="nnn"

# Vulkan

export VULKAN_SDK=~/Documents/vulkan/1.2.148.1/x86_64
export PATH=$VULKAN_SDK/bin:$PATH
export LD_LIBRARY_PATH=$VULKAN_SDK/lib:$LD_LIBRARY_PATH
export VK_LAYER_PATH=$VULKAN_SDK/etc/vulkan/explicit_layer.d

# Configs belong to a .config directory

export GTK3_RC_FILES="$HOME/.config/gtk-3.0/gtkrc-3.0"
export QT_QPA_PLATFORMTHEME=gtk2

export ZDOTDIR="$HOME/.config/zsh"

