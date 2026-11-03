# Setup zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
# Add config alias
alias config='/usr/bin/git --git-dir=/home/alexbeat/.dotfiles/ --work-tree=/home/alexbeat'

# Zinit plugins and configs
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
     zdharma/fast-syntax-highlighting \
  blockf \
     zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
     zsh-users/zsh-autosuggestions

# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship
# Alex custom commands
matlab() {
    LD_PRELOAD="$HOME/AlexDev/omarchy-customizations/matlabR2026a-archlinux-fix/matlab_fix.so:/usr/lib/libstdc++.so.6" \
        command "$HOME/matlab/bin/matlab" "$@"
}
export PATH="$HOME/.local/bin:$PATH"
