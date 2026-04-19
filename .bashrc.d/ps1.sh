source /usr/share/git-core/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1

export CLR_CYAN='\[\033[00;33m\]'
export CLR_CLR='\[\033[00m\]'
export PS1="[${CLR_CYAN}\u@\h \W${CLR_CLR}] \$(__git_ps1 '(%s) ')${CLR_CYAN}\\$ ${CLR_CLR}"
