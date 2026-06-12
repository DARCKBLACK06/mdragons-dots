
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Pywal fallback (no rompe nada)
[[ -f "$HOME/.cache/wal/colors.sh" ]] && source "$HOME/.cache/wal/colors.sh"

source $ZSH/oh-my-zsh.sh


# FZF
source <(fzf --zsh)

# Historial persistente
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Teclas Home/End
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

# Aliases lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias h='history'
alias cisco="picocom -b 9600 /dev/ttyUSB0"
alias cisco='picocom -b 9600 /dev/cisco --logfile ~/cisco-logs/cisco-$(date +%F-%H%M).log'


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Fastfetch al final
bash $HOME/.config/fastfetch/fastfetch-mini.sh | lolcat

#Export apps

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.spicetify:$PATH"
export MPD_HOST="Michas72@127.0.0.1"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/darckblack/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/darckblack/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/darckblack/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/darckblack/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

