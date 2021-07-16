# load zgen
source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
  # Load the oh-my-zsh's library.
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/command-not-found


  # Syntax highlighting bundle.
  zgen load zsh-users/zsh-syntax-highlighting

  # Plugin to check if a 256 colour terminal
  # is available, and enable all colours if
  # it is
  zgen load chrissicool/zsh-256color

  # Load the theme.
  zgen oh-my-zsh themes/pygmalion
fi

export EDITOR=vim

BASE16_SHELL="$HOME/.config/base16-shell/"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Default to ccache if available
if type ccache > /dev/null; then
  ccache -M 10 > /dev/null
  # export CCACHE_PREFIX='icecc'
  # Don't use cached preprocessor output
  export CCACHE_CPP2=true
fi

# Ensure Google Test tests always show colour output:
export GTEST_COLOR=yes

# Set up ninja tab completion
source ~/dotfiles/ninja/_ninja

alias l='ls -lhtr'

# general aliases
alias ja='ninja'
alias now='watch -x -t -n 0.01 date +%s.%N'
alias du='du -h --max-depth=1'
alias df='df -h'
alias dstart='docker start -i'
alias watch_cpus='watch -n.1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias head='head -n 40'
alias gcoa='git checkout \*'

# Alias to check for avx and avx2 instructions
alias checkavx1='find -type f -executable | xargs objdump --disassemble | egrep "(vbroadcastss|vbroadcastsd|vbroadcastf128|vinsertf128|vextractf128|vmaskmovps|vmaskmovpd|vpermilps|vpermilpd|vperm2f128|vzeroall|vzeroupper)"'

alias checkavx2='find -type f -executable | xargs objdump --disassemble | egrep "(vpbroadcastb|vpbroadcastw|vpbroadcastd|vpbroadcastq|vbroadcasti128|vinserti128|vextracti128|vgatherdpd|vgatherqpd|vgatherdps|vgatherqps|vpgatherdd|vpgatherdq|vpgatherqd|vpgatherqq|vpmaskmovd|vpmaskmovq|vpermps|vpermd|vpermpd|vpermq|vperm2i128|vpblendd|vpsllvd|vpsllvq|vpsrlvd|vpsrlvq|vpsravd)"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.localrc ] && source ~/.localrc
[ -f ~/.pathrc ] && source ~/.pathrc
[ -f ~/.dircolors ] && eval "$(dircolors ~/.dircolors)"
[ -f ~/venv/bin/activate ] && source ~/venv/bin/activate # Source virtual environment if activate script exists

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# kdesrc-build ##################################################

## Add kdesrc-build to PATH
export PATH="$HOME/kde/src/kdesrc-build:$PATH"

## Run projects built with kdesrc-build
function kdesrc-run
{
  source "$HOME/kde/build/$1/prefix.sh" && "$HOME/kde/usr/bin/$@"
}
#################################################################

