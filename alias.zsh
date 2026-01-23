#!/usr/bin/env zsh
# ============================================================================
# ZSH ALIASES
# ============================================================================
# Simple aliases only. Complex functions are in .functions.zsh

DISABLE_AUTO_TITLE="true"

# Source functions files (from same directory as this file)
source "${0:A:h}/.functions.zsh"
source "${0:A:h}/.git-functions.zsh"

# ============================================================================
# TERMINAL TITLE
# ============================================================================
precmd() { echo -ne "\e]1;${PWD##*/}\a"; }

alias k="clear"

# Navigation
alias in='cd '
alias out='cd ../'
alias peek='nav'

# GIT - Basic Operations
alias clone="git clone"
alias commit="git commit -m"
# Function to add all files and commit with message
# Usage: gca "commit message" or gca word1 word2 word3
# Note: Unalias oh-my-zsh's gca first (git commit --verbose --all)
unalias gca 2>/dev/null
function gca() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: gca \"commit message\""
    return 1
  fi
  git add -A
  git commit -m "$*"
}
alias cherry="git cherry-pick"
alias continue="git cherry-pick --continue"

# Git Status
alias stats="git status -sb"
alias statm="git status -uno"

# Git Stash
alias pop="git stash pop"
alias save="git stash push --include-untracked"

# ============================================================================
# GIT - Function-backed (see .functions.zsh)
# ============================================================================
alias push="push_with_upstream"
alias to="to_branch"
alias cc="prepare_merge_branch"
alias kdb="git_cleanup"
alias report="git_status_report"
# ============================================================================
# PROJECT
# ============================================================================
alias cleanup="rm -rf node_modules/ && rm -f bun.lock && bun pm cache rm"

# ============================================================================
# PROCESS
# ============================================================================
alias killnode="killall -9 node"
alias killport='f() { lsof -ti:$1 | xargs kill -9 2>/dev/null && echo "Killed process on port $1" || echo "No process on port $1"; }; f'
# ============================================================================
# SYSTEM
# ============================================================================
alias chrome='open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security'
alias dnsclr='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias pip="pip3"
alias py="/usr/bin/python3"
alias code='NODE_OPTIONS="" code'

# ============================================================================
# WORK
# ============================================================================
alias go="sis -p"
