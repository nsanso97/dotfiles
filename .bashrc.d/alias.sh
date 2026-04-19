alias sudo="sudo "
alias git-lc="git ls-files | xargs -n1 git blame --line-porcelain | sed -n 's/^author //p' | sort -f | uniq -ic | sort -nr"
alias ls="ls --color=auto "
alias la="ls -a "
alias ll="ls -lah "
alias xc="xclip -sel c "

