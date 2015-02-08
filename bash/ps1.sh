RED=31
GREEN=32
YELLOW=33

git_repo() {
  [[ `git rev-parse --is-inside-work-tree 2>/dev/null` == true ]]
}

git_modified() {
  [[ `git ls-files -m` != '' ]]
}

git_untracked() {
  [[ `git ls-files -o --exclude-standard` != '' ]]
}

git_staged() {
  [[ `git diff --staged --name-only` != '' ]]
}

git_dirty() {
  git_modified || git_untracked || git_staged
}

git_branch_color() {
  if git_repo; then
    if git_dirty; then
      echo $RED
    else
      echo $GREEN
    fi
  fi
}

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

git_branch_name() {
  git rev-parse --abbrev-ref HEAD
}

ruby_version() {
  echo `~/.rvm/bin/rvm-prompt`
}

print_pre_prompt() {
  printf "\e[1;30m%$(($COLUMNS))s" $(ruby_version)
}

command_state() {
  echo "\$(if [[ \$? == 0 ]]; then echo \"\[\033[0;32m\]☺\"; else echo \"\[\033[0;31m\]☹\"; fi)\[\033[00m\]"
}

PROMPT_COMMAND=print_pre_prompt
export CLICOLOR=1
export PS1="$(command_state) \[\033[\$(echo $YELLOW)m\]\w \[\033[\$(git_branch_color)m\]\$(git_branch)\[\033[00m\]"
#export PS1="$(command_state) \[\033[0;36m\]\u\[\033[00m\]:\[\033[\$(echo $YELLOW)m\]\w \[\033[\$(git_branch_color)m\]\$(git_branch)\[\033[1;33m\]$\[\033[00m\] "
#export PS1='[\u@\h \w$(__git_ps1 " (%s)")]\$ '
