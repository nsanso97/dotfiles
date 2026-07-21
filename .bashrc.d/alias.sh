alias sudo="sudo "
alias ls="ls -a --color=auto "
alias ll="ls -lah "
alias xc="xclip -sel c "

alias glc="git ls-files | xargs -n1 git blame --line-porcelain | sed -n 's/^author //p' | sort -f | uniq -ic | sort -nr"
alias gbr="git branch -r --sort=-committerdate --format='%format='%(refname:short)%09%(committerdate:relative)%09%(authorname)%09(contents:subject)' | column -t -s $'\t' "
alias gl="git log --pretty=format:'%Cblue%h%Creset%x09%s%x09%Cred%ar%Creset%x09%Cgreen%an%Creset' "
