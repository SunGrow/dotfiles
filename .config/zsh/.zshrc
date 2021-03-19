# SunGrow's ZSHell config

### BASE ###

# Enable colors and change prompt:
[[ "$COLORTERM" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor
#ESC[ 38;2;⟨r⟩;⟨g⟩;⟨b⟩ m Select RGB foreground color
#ESC[ 48;2;⟨r⟩;⟨g⟩;⟨b⟩ m Select RGB background color
PS1=$'%B%F%{\e[38;2;231;111;81m%}[%F%{\e[38;2;244;162;97m%}%n%F%{\e[38;2;233;196;106m%}@%M%F%{\e[38;2;168;218;220m%} %~ %{\e[38;2;243;230;190m%}%@%F%{\e[38;2;231;111;81m%}]%f%b%# %{\e[0m%}'

# History in cache directory:
HISTSIZE=2048
SAVEHIST=2048
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

### VI MODE ###
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    if [[ ${TMUX} ]] then
        echo -ne '\ePtmux;\e\e[2 q\e\\'
    else
        echo -ne '\e[2 q'
    fi
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    if [[ ${TMUX} ]] then
        echo -ne '\ePtmux;\e\e[5 q\e\\'
    else
        echo -ne '\e[5 q'
    fi
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use nnn to switch directories and bind it to ctrl-o
nnncd () {
    tmp="$(mktemp)"
    nnn -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'nnncd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

### ARCHIVE EXTRACTION ###
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;      
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


### ALIASES ###

# confirm on overwrite
alias cp="cp -i"
alias mv="mv -i"

# add flags for convenience
alias ls="ls -A --color -h -s --group-directories-first"
alias df="df -h"
alias free="free -h"
alias lynx="lynx -vikeys -cfg=$XDG_CONFIG_HOME/lynx/lynx.cfg"

## BIND
#
export STEAM_COMPAT_DATA_PATH="~/proton"

export PATH=~/.local/bin:$PATH
