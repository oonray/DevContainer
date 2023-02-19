export PATH=$PATH:/usr/local/go/bin

export ZSH="{{home}}/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"

export PATH="$PATH:$GOROOT/bin"
export PATH="$PATH:$GOPATH/bin"

if [[ $TERM == xterm ]]; then
    TERM=xterm-256color
fi

if [[ $TERM == screen ]]; then
]    TERM=screen-256color
fi

#---------------------------------------
WORDCHARS=${WORDCHARS//\/}

# hide EOL sign ('%')
export PROMPT_EOL_MARK=""

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PROMPT=$'{{prompt}}'
    RPROMPT=$'{{rprompt}}'

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
  unsetopt ksharrays
  . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
  ZSH_HIGHLIGHT_STYLES[default]=none
  ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
  ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
  ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
  ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
  ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
  ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
  ZSH_HIGHLIGHT_STYLES[path]=underline
  ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
  ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
  ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
  ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
  ZSH_HIGHLIGHT_STYLES[command-substitution]=none
  ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[process-substitution]=none
  ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
  ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
  ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[assign]=none
  ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
  ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
  ZSH_HIGHLIGHT_STYLES[named-fd]=none
  ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
  ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
  ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
  ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
  ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
  ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
  ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
  ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
  ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
fi
unset color_prompt force_color_prompt

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Base16 Shell
BASE16_SHELL="/home/oonray/.config/base16-shell/base16-shell-master"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

plugins=(vi-mode git terraform docker docker-compose python man nmap golang kubectl perl pip sudo systemd tmux history-substring-search)

source $ZSH/oh-my-zsh.sh

