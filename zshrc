# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Install trusty old zgen if it's not installed
if [[ ! -d "${HOME}/.zgen" ]]; then
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

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

  # Powerlevel 10k
  zgen load romkatv/powerlevel10k powerlevel10k
fi

CASE_SENSITIVE="true"

export EDITOR=nvim

# Ensure Google Test tests always show colour output:
export GTEST_COLOR=yes

# general aliases
alias jad='cmake --build --preset debug -- -j 8 '
alias ja='cmake --build --preset development -- -j 8 '
alias now='watch -x -t -n 0.01 date +%s.%N'
alias du='du -h --max-depth=1'
alias df='df -h'
alias watch_cpus='watch -n.1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias head='head -n 40'
alias gcoa='git checkout \*'
alias htree='tree --prune -P "*.h"'
alias gbc='git branch | cat | grep -v master | xargs git branch -D {}'
alias clswp="find -name '*.swp' -exec rm {} \;"
alias tf='terraform'

# Docker run aliases
alias dps='docker ps --format "table {{.Names}} \t {{.Status}} \t {{.Ports}}"'
alias dri='docker run -ti --rm -v /home/$USER:/home/$USER --user $(id -u):$(id -g)'
alias http='http --verify=no'

# Alias to clean all branches that have been pushed
# alias git-branch-clean="git fetch --all --prune && git branch -D $(git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }')"

# Alias to check for avx and avx2 instructions
alias checkavx1='find -type f -executable | xargs objdump --disassemble | egrep "(vbroadcastss|vbroadcastsd|vbroadcastf128|vinsertf128|vextractf128|vmaskmovps|vmaskmovpd|vpermilps|vpermilpd|vperm2f128|vzeroall|vzeroupper)"'

alias checkavx2='find -type f -executable | xargs objdump --disassemble | egrep "(vpbroadcastb|vpbroadcastw|vpbroadcastd|vpbroadcastq|vbroadcasti128|vinserti128|vextracti128|vgatherdpd|vgatherqpd|vgatherdps|vgatherqps|vpgatherdd|vpgatherdq|vpgatherqd|vpgatherqq|vpmaskmovd|vpmaskmovq|vpermps|vpermd|vpermpd|vpermq|vperm2i128|vpblendd|vpsllvd|vpsllvq|vpsrlvd|vpsrlvq|vpsravd)"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.pathrc ] && source ~/.pathrc
[ -f ~/.dircolors ] && eval "$(dircolors ~/.dircolors)"
[ -f ~/.venv/bin/activate ] && source ~/.venv/bin/activate # Source virtual environment if activate script exists
[ -f ~/.localrc ] && source ~/.localrc # Source a file with local zsh settings we don't want in github

# alias l='colorls -lA --sd'
alias l='ls -ltrh'
# source $(dirname $(gem which colorls))/tab_complete.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH="$HOME/bin:$PATH"

# Increase the sccache size
export SCCACHE_CACHE_SIZE="50G"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
