## path variables
PATH_CONFIG=$HOME/.config
PATH="$HOME/.local/bin:$PATH"
setopt menu_complete

## OhMyZsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="simple"
plugins=(git tinted-shell tmux)
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_FIXTERM_WITH_256COLOR=tmux-256color
source $ZSH/oh-my-zsh.sh

## Alias
alias python="python3"
alias pip="pip3"
alias vi="vim"
alias ls='ls -Gh --color=auto'
alias l='ls -l'
alias ll='l -a'
alias -s {c,h,md,conf}=vim
alias -g L='| less'
alias rm="trash"
alias svi="sudo vim"
  
## sudo
alias pacman="sudo pacman"
alias systemctl="sudo systemctl"
alias ufw="sudo ufw"
alias qmk="sudo qmk"

## Functions
cd() { builtin cd "$@"; l; }
update() {
  # package upgrade&clean
  pacman --noconfirm -Syu
  pacman --noconfirm -Qdtq | ifne sudo pacman -Rns -

  vim -E +PluginUpdate +qall

  ~/.tmux/plugins/tpm/bin/update_plugins all

  python3 ~/.vim/bundle/youcompleteme/install.py --clangd-completer --ts-completer --quiet

  omz update
}

ghfetch() {
  git fetch upstream
  git merge upstream/master
  git push
}

mkvenv() {
  python -m venv $PATH_CONFIG/venv/$1
  source $PATH_CONFIG/venv/$1/bin/activate
}

venv() {
  source $PATH_CONFIG/venv/$1/bin/activate
}

keebuild() {
  QMK_PATH=$HOME/.qmk
  KEYMAP_PATH=$QMK_PATH/keyboards/keyboardio/atreus/keymaps/hazeleet

  pushd $QMK_PATH
  command rm -rf $KEYMAP_PATH
  git pull
  command cp -a $PATH_CONFIG/keymap $KEYMAP_PATH
  qmk flash -kb keyboardio/atreus -km hazeleet
  popd
}

keebedit() {
  vi $PATH_CONFIG/keymap
}

x() {
  echo $(($1))
}
