# Profile file. Runs on login. Is full of enviromental variables

# DEFAULT PROGRAMS

export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"
export FILE="thunar"
export TerminalEmulator=${TERMINAL}
export TERMINAL_EMULATOR=${TERMINAL}

# Configs belong to a .config directory

export GTK3_RC_FILES="${XDG_CONFIG_HOME}/gtk-3.0/gtkrc-3.0"

# Qute theme
export QT_QPA_PLATFORMTHEME=qt5ct

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Add rust to path
export PATH=~/.local/bin:$PATH
export PATH=~/.cargo/bin:$PATH

## BIND
#
export STEAM_COMPAT_DATA_PATH="~/proton"

export PATH=~/.local/bin:$PATH

