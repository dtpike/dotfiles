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
  ccache -M 50 > /dev/null
  # Don't use cached preprocessor output
  export CCACHE_CPP2=true
fi

# Ensure Google Test tests always show colour output:
export GTEST_COLOR=yes

alias l='ls -lhtr'

# general aliases
alias jad='cmake --build --preset debug -- -j 12 '
alias ja='cmake --build --preset development -- -j 12 '
alias jap='cmake --build --preset production -- -j 12 '
alias now='watch -x -t -n 0.01 date +%s.%N'
alias du='du -h --max-depth=1'
alias df='df -h'
alias watch_cpus='watch -n.1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias head='head -n 40'
alias gcoa='git checkout \*'
alias htree='tree --prune -P "*.h"'
alias gbc='git branch | cat | grep -v master | xargs git branch -D {}'
alias clswp="find -name '*.swp' -exec rm {} \;"

# Docker run aliases
alias dps='docker ps --format "table {{.Names}} \t {{.Status}} \t {{.Ports}}"'

# Alias to check for avx and avx2 instructions
alias checkavx1='find -type f -executable | xargs objdump --disassemble | egrep "(vbroadcastss|vbroadcastsd|vbroadcastf128|vinsertf128|vextractf128|vmaskmovps|vmaskmovpd|vpermilps|vpermilpd|vperm2f128|vzeroall|vzeroupper)"'

alias checkavx2='find -type f -executable | xargs objdump --disassemble | egrep "(vpbroadcastb|vpbroadcastw|vpbroadcastd|vpbroadcastq|vbroadcasti128|vinserti128|vextracti128|vgatherdpd|vgatherqpd|vgatherdps|vgatherqps|vpgatherdd|vpgatherdq|vpgatherqd|vpgatherqq|vpmaskmovd|vpmaskmovq|vpermps|vpermd|vpermpd|vpermq|vperm2i128|vpblendd|vpsllvd|vpsllvq|vpsrlvd|vpsrlvq|vpsravd)"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.pathrc ] && source ~/.pathrc
[ -f ~/.dircolors ] && eval "$(dircolors ~/.dircolors)"
[ -f ~/.venv/bin/activate ] && source ~/.venv/bin/activate # Source virtual environment if activate script exists

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH="$HOME/bin:$PATH"

# Increase the sccache size
export SCCACHE_CACHE_SIZE="50G"


# Turn off the fucking bell
unsetopt BEEP
