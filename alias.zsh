DISABLE_AUTO_TITLE="true"

precmd() {
  # sets the tab title to current dir
  echo -ne "\e]1;${PWD##*/}\a"
}

# Git Aliases
alias kill="killall -9 node"
alias check="git checkout"
alias pop="git stash pop"
alias save="git stash push --include-untracked"
alias stat="git status"
alias commit="git commit -m"
alias cherry="git cherry-pick"
alias clone="git clone"
alias sy="checkout_and_pull"
alias push="push_with_upstream"
alias ga="git add"
alias gb="git branch"
alias gcb="git rev-parse --abbrev-ref HEAD && git rev-parse --abbrev-ref HEAD | pbcopy"
alias gca="git add . && git commit -m"
alias gpu="pull"
alias gpum="pullMerge"
alias gcc="git rev-parse HEAD && git rev-parse HEAD | pbcopy"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias glo="git log --graph --oneline"
alias gpo="git push origin HEAD"
alias gl="git log --graph"
alias gundo="git stash save --keep-index --include-untracked && git stash drop"
alias cleanup="rm -rf node_modules/ && rm -f && yarn cache clean"

dmgcreator() {
	hdiutil create -volname "$1" -srcfolder "$1.app" -ov -format UDZO "$1.dmg"
	open "$1.dmg"
}
alias dmg="dmgcreator"

# NPM/Yarn Aliases
alias n="npm"
alias nb="npm run build"
alias nd="npm run dev"
alias ni="npm install"
alias nci="rm -rf node_modules/ && rm -f package-lock.json && npm install"
alias nr="npm run"
alias ns="npm start"
alias y="yarn"
alias yb="yarn build"
alias yc="yarn compile"
alias yd="yarn dev"
alias yi="yarn install"
alias ya="yarn android-dev"
alias yi="yarn ios-dev"
alias yid="yarn ios-dev-device"
alias yip="yarn ios-prod-device"
alias ys="yarn start"

# System Aliases
alias clr="clear"
alias cd="z"
alias chrome='open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security'
alias dnsclr='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder'
alias htop="htop"
alias ll="ls"
alias ls="eza --all --color=always --long --icons=always --no-time --no-user --no-permissions"
alias lst="eza --all --color=always --long --icons=always --no-time --no-user --no-permissions --tree --level=2"
alias pip="pip3"
alias py="/usr/bin/python3"
alias exit="exit"

# Custom Aliases
alias amfe="agg unlink @sequoiaconsulting/mfe-config-essentials ; agg ; agg link @sequoiaconsulting/mfe-config-essentials"
alias code='NODE_OPTIONS="" code'
alias ymfe="yarn unlink @sequoiaconsulting/mfe-config-essentials ; yarn ; yarn link @sequoiaconsulting/mfe-config-essentials"

# Functions
function pull(){
  branch="$(git rev-parse --abbrev-ref HEAD)"
  if [ $# -eq 0 ]; then
    git pull origin $branch --rebase
  else
    git pull origin $1 --rebase
  fi
}

function pullMerge(){
  branch="$(git rev-parse --abbrev-ref HEAD)"
  if [ $# -eq 0 ]; then
    git pull origin $branch
  else
    git pull origin $1
  fi
}

function gpi(){
  branch=$(git symbolic-ref --short HEAD)
  remote=$(git config --get remote.origin.url)
  removeDotGit="${remote/.git/}"
  removeColon="${removeDotGit/://}"
  url=${removeColon/git@/https:\/\/}
  open "${url}/issues/new?title=deploy%20${branch}"
}

function gprm(){
  eval "push"
  branch=$(git symbolic-ref --short HEAD)
  remote=$(git config --get remote.origin.url)
  removeDotGit="${remote/.git/}"
  removeColon="${removeDotGit/://}"
  url=${removeColon/git@/https:\/\/}
  if [ $1 ]; then
    secondArg=$1
  else
    secondArg="dev"
  fi
  count=0
  title=""
  description=""
  while (( $# )); do
    case $1 in
      -t=*|--title=*) title="${1#*=}" ;;
      -d=*|--description=*) description="${1#*=}" ;;
      *) if [ $count -eq 1 ]; then branch=$secondArg; target=$1; else target=$1; fi ;;
    esac
    count=$((count+1))
    shift
  done

  if [ $count -eq 0 ]; then
    base="${url}/compare/${branch}"
  else
    base="${url}/compare/${target}...${branch}"
  fi
  temp="${base}?expand=1"

  if [ $title ] && [ $description ]; then
    temp="${temp}&title=${title}&body=${description}"
  elif [ $title ]; then
    temp="${temp}&title=${title}"
  elif [ $description ]; then
    temp="${temp}&body=${description}"
  fi

  open "${temp}"

  unset target
  unset count
  unset title
  unset description
  unset secondArg
  unset final
}

function gpr() {
  branch=$(git symbolic-ref --short HEAD)
  remote=$(git config --get remote.origin.url)
  removeDotGit="${remote/.git/}"
  removeColon="${removeDotGit/://}"
  url=${removeColon/git@/https:\/\/}

  if [ $1 ]; then
    secondArg=$1
  else
    secondArg="dev"
  fi
  count=0

  if [ $# -eq 0 ] ; then
    _gpr_usage
    return 0
  fi

  while (( $# )); do
    case $1 in
      -j | --jira) shift; ticket="${1}" ;;
      -d | --description) shift; description="${1}" ;;
      -t | --title) shift; title="${1}" ;;
      -h | --help) _gpr_usage ;;
      *) shift ;;
    esac
    count=$((count+1))
  done

  target=$secondArg

  if [ $count -eq 0 ]; then
    base="${branch}"
  else
    base="${target}"
    head="${branch}"
  fi

  body="${description}"

  if [ $title ] || [ $ticket ]; then
    if [ $ticket ]; then
      title="${ticket} ${description}"
      body="### Description\nJira Id: ${ticket}\nLink to Jira Ticket: https://sequoiacg.atlassian.net/browse/${ticket}\nRemarks: ${description}"
    fi

    gh pr create --base "${base}" --head "${head}" --title "${title}" --body "${body}"
  fi

  unset target
  unset count
  unset title
  unset ticket
  unset body
  unset description
  unset secondArg
  unset final
  unset base
  unset head
}

function checkout_and_pull() {
  local branch_name=$1
  local command="check $branch_name && git pull"
  eval $command
}


function push_with_upstream() {
  local branch_name=$(git rev-parse --abbrev-ref HEAD)
  git push
  if [ $? -ne 0 ]; then
    git push --set-upstream origin $branch_name
  fi
}
