#!/usr/bin/env zsh
# ============================================================================
# ZSH FUNCTIONS - Base
# ============================================================================
# This file contains base shell functions and utilities.
# Git-related functions are in .git-functions.zsh
# Sourced by .alias.zsh

# ============================================================================
# SHARED COLOR DEFINITIONS
# ============================================================================
typeset -g _CLR_RED=$'\e[31m'
typeset -g _CLR_GREEN=$'\e[32m'
typeset -g _CLR_YELLOW=$'\e[33m'
typeset -g _CLR_BLUE=$'\e[34m'
typeset -g _CLR_CYAN=$'\e[36m'
typeset -g _CLR_BOLD=$'\e[1m'
typeset -g _CLR_DIM=$'\e[2m'
typeset -g _CLR_RESET=$'\e[0m'

# Helper functions for consistent output
_msg_error() { echo -e "${_CLR_RED}❌ $1${_CLR_RESET}"; }
_msg_success() { echo -e "${_CLR_GREEN}✅ $1${_CLR_RESET}"; }
_msg_warn() { echo -e "${_CLR_YELLOW}⚠️  $1${_CLR_RESET}"; }
_msg_info() { echo "ℹ️  $1"; }
_msg_progress() { echo -e "${_CLR_BLUE}🔄 $1${_CLR_RESET}"; }

# ============================================================================
# HELP - Show all available commands
# ============================================================================
function help() {
  local filter="$1"

  cat <<EOF

${_CLR_BOLD}${_CLR_CYAN}╔══════════════════════════════════════════════════════════════════════════╗
║                        🚀 CUSTOM SHELL COMMANDS                          ║
╚══════════════════════════════════════════════════════════════════════════╝${_CLR_RESET}

EOF

  # Navigation section
  if [[ -z "$filter" || "$filter" == "nav" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}📂 NAVIGATION${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}k${_CLR_RESET}              Clear terminal
  ${_CLR_GREEN}in${_CLR_RESET} <dir>       cd to directory
  ${_CLR_GREEN}out${_CLR_RESET}            cd to parent directory
  ${_CLR_GREEN}peek${_CLR_RESET}           Interactive directory navigator (fzf)

EOF
  fi

  # Git basic section
  if [[ -z "$filter" || "$filter" == "git" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}📦 GIT - BASIC${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}clone${_CLR_RESET} <url>    Clone a repository
  ${_CLR_GREEN}commit${_CLR_RESET} <msg>   Commit with message
  ${_CLR_GREEN}gca${_CLR_RESET} <msg>      Add all files and commit with message
  ${_CLR_GREEN}cherry${_CLR_RESET} <hash>  Cherry-pick a commit
  ${_CLR_GREEN}continue${_CLR_RESET}       Continue cherry-pick after resolving conflicts

EOF
  fi

  # Git status section
  if [[ -z "$filter" || "$filter" == "git" || "$filter" == "status" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}📊 GIT - STATUS${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}stat${_CLR_RESET}           Enhanced git status (compact row format)
    ${_CLR_DIM}-a, --all${_CLR_RESET}      Run on all linked repos via sis
    ${_CLR_DIM}-v, --verbose${_CLR_RESET}  Show file list below status
  ${_CLR_GREEN}stats${_CLR_RESET}          Short git status (git status -sb)
  ${_CLR_GREEN}statm${_CLR_RESET}          Git status without untracked (git status -uno)
  ${_CLR_GREEN}report${_CLR_RESET}         Multi-repo status report
    ${_CLR_DIM}--fetch${_CLR_RESET}        Fetch before checking
    ${_CLR_DIM}--quiet${_CLR_RESET}        Only show repos with changes

EOF
  fi

  # Git stash section
  if [[ -z "$filter" || "$filter" == "git" || "$filter" == "stash" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}📥 GIT - STASH${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}save${_CLR_RESET}           Stash changes (including untracked)
  ${_CLR_GREEN}pop${_CLR_RESET}            Pop last stash

EOF
  fi

  # Git branch section
  if [[ -z "$filter" || "$filter" == "git" || "$filter" == "branch" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}🌿 GIT - BRANCH${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}to${_CLR_RESET} <branch>    Switch to branch (unified branch management)
    ${_CLR_DIM}-n, --new${_CLR_RESET}      Create NEW branch and push to origin
    ${_CLR_DIM}-s, --sync${_CLR_RESET}     Checkout and pull with rebase
    ${_CLR_DIM}-r, --reset${_CLR_RESET}    Delete local and recreate from origin
    ${_CLR_DIM}-a, --all${_CLR_RESET}      Switch all linked repos via sis
    ${_CLR_DIM}-p, --parallel${_CLR_RESET} Run on all subdirs in parallel
  ${_CLR_GREEN}kdb${_CLR_RESET}            Cleanup stale local branches
    ${_CLR_DIM}--delete-gone${_CLR_RESET}  Delete branches with [gone] upstream
    ${_CLR_DIM}--dry-run${_CLR_RESET}      Preview deletion list

EOF
  fi

  # Git push/pull section
  if [[ -z "$filter" || "$filter" == "git" || "$filter" == "sync" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}🔄 GIT - PUSH/PULL${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}pull${_CLR_RESET} [branch]  Pull with rebase (defaults to current branch)
  ${_CLR_GREEN}push${_CLR_RESET}           Push (auto sets upstream if needed)

EOF
  fi

  # Git PR section
  if [[ -z "$filter" || "$filter" == "git" || "$filter" == "pr" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}🔀 GIT - PULL REQUESTS${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}pr${_CLR_RESET} [target]    Create PR with gh CLI (opens in browser on success)
    ${_CLR_DIM}-m, --manual${_CLR_RESET}   Open PR in browser instead of CLI
    ${_CLR_DIM}-j, --jira${_CLR_RESET}     Jira ticket ID (prepends to title)
    ${_CLR_DIM}-d, --description${_CLR_RESET} PR description (optional)
    ${_CLR_DIM}-t, --title${_CLR_RESET}    Custom title (defaults to last commit)
  ${_CLR_GREEN}cc${_CLR_RESET} <target>    Cherry-pick workflow: create merge branch + PR
  ${_CLR_GREEN}msync${_CLR_RESET} [branch]  Sync current branch with master (or specified branch)

EOF
  fi

  # Project section
  if [[ -z "$filter" || "$filter" == "project" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}📁 PROJECT${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}cleanup${_CLR_RESET}        Remove node_modules, bun.lock, and clear bun cache
  ${_CLR_GREEN}go${_CLR_RESET}             Start project via sis -p

EOF
  fi

  # Process section
  if [[ -z "$filter" || "$filter" == "process" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}⚙️  PROCESS${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}killnode${_CLR_RESET}       Kill all node processes
  ${_CLR_GREEN}killport${_CLR_RESET} <n>   Kill process on specified port

EOF
  fi

  # System section
  if [[ -z "$filter" || "$filter" == "system" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}🖥️  SYSTEM${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}chrome${_CLR_RESET}         Open Chrome with disabled web security
  ${_CLR_GREEN}dnsclr${_CLR_RESET}         Flush DNS cache
  ${_CLR_GREEN}py${_CLR_RESET}             Python3
  ${_CLR_GREEN}pip${_CLR_RESET}            pip3
  ${_CLR_GREEN}code${_CLR_RESET}           VS Code (with NODE_OPTIONS cleared)

EOF
  fi

  # API section
  if [[ -z "$filter" || "$filter" == "api" || "$filter" == "crawler" ]]; then
    cat <<EOF
${_CLR_BOLD}${_CLR_BLUE}🕷️  CRAWLER API${_CLR_RESET}
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
  ${_CLR_GREEN}crawl${_CLR_RESET}          Trigger web crawl (wiki/reddit)
    ${_CLR_DIM}-t, --topic${_CLR_RESET}    Topic to crawl
    ${_CLR_DIM}-s, --source${_CLR_RESET}   Source: wiki, reddit, or both
    ${_CLR_DIM}-r, --subreddit${_CLR_RESET} Single subreddit
  ${_CLR_GREEN}getCrawled${_CLR_RESET}     Fetch crawled articles
    ${_CLR_DIM}-s, --source${_CLR_RESET}   Filter by source
    ${_CLR_DIM}-i, --id${_CLR_RESET}       Get specific article
    ${_CLR_DIM}-f, --format${_CLR_RESET}   Output: table, json, full

EOF
  fi

  # Footer
  cat <<EOF
${_CLR_DIM}────────────────────────────────────────────────────────────────────────────${_CLR_RESET}
${_CLR_BOLD}💡 TIP:${_CLR_RESET} Use ${_CLR_GREEN}help <category>${_CLR_RESET} to filter by category
       Categories: ${_CLR_CYAN}nav${_CLR_RESET}, ${_CLR_CYAN}git${_CLR_RESET}, ${_CLR_CYAN}status${_CLR_RESET}, ${_CLR_CYAN}stash${_CLR_RESET}, ${_CLR_CYAN}branch${_CLR_RESET}, ${_CLR_CYAN}sync${_CLR_RESET}, ${_CLR_CYAN}pr${_CLR_RESET}, ${_CLR_CYAN}project${_CLR_RESET}, ${_CLR_CYAN}process${_CLR_RESET}, ${_CLR_CYAN}system${_CLR_RESET}, ${_CLR_CYAN}crawler${_CLR_RESET}
       Most commands support ${_CLR_GREEN}-h${_CLR_RESET} or ${_CLR_GREEN}--help${_CLR_RESET} for detailed usage.

EOF
}

# ============================================================================
# Interactive Directory Navigator
# ============================================================================
# Usage: nav [starting_directory]
nav() {
  local dir="${1:-$PWD}"
  local parent_dir=$(dirname "$dir")
  
  # List directories only
  local selected
  selected=$( 
    {
      [[ "$dir" != "/" ]] && echo ".."
      find "$dir" -maxdepth 1 -type d ! -path "$dir" -exec basename {} \; 2>/dev/null | sort
    } | fzf \
      --height=40% \
      --layout=default \
      --border=rounded \
      --header="📍 $dir" \
      --prompt="cd > " \
      --preview="[[ {} == '..' ]] && ls -1A '$parent_dir' || ls -1A '$dir/{}'" \
      --preview-window=right:50% \
      --preview-label="[ Contents ]"
  )
  
  # Exit if nothing selected
  [[ -z "$selected" ]] && return 0
  
  # Navigate
  if [[ "$selected" == ".." ]]; then
    cd "$parent_dir" && _msg_success "Changed to: $(pwd)"
  elif [[ -d "$dir/$selected" ]]; then
    cd "$dir/$selected" && _msg_success "Changed to: $(pwd)"
  fi
}

# ============================================================================
# CRAWLER API FUNCTIONS
# ============================================================================
# Base URL for the crawler API
typeset -g _CRAWLER_API_URL="https://crawler.chouhan-abhik.workers.dev"

# crawl - Trigger a manual crawl for topics
# Usage: crawl [-t topic] [-s source] [-r subreddit] [-R sub1,sub2,...]
#   -t, --topic      Topic to crawl (used for both wiki and reddit)
#   -s, --source     Source to crawl: wiki, reddit, or both (default: both)
#   -r, --subreddit  Single subreddit to crawl
#   -R, --subreddits Comma-separated list of subreddits
#   -h, --help       Show this help message
crawl() {
  local topic=""
  local source=""
  local subreddit=""
  local subreddits=""
  local show_help=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -t|--topic)
        topic="$2"
        shift 2
        ;;
      -s|--source)
        source="$2"
        shift 2
        ;;
      -r|--subreddit)
        subreddit="$2"
        shift 2
        ;;
      -R|--subreddits)
        subreddits="$2"
        shift 2
        ;;
      -h|--help)
        show_help=true
        shift
        ;;
      *)
        # Treat first positional arg as topic
        if [[ -z "$topic" ]]; then
          topic="$1"
        fi
        shift
        ;;
    esac
  done

  if $show_help; then
    cat <<EOF
${_CLR_BOLD}${_CLR_CYAN}╔══════════════════════════════════════════════════════════════════════════╗
║                         🕷️  CRAWL - Web Crawler                          ║
╚══════════════════════════════════════════════════════════════════════════╝${_CLR_RESET}

${_CLR_BOLD}USAGE:${_CLR_RESET}
  crawl [topic]                    Crawl a topic from wiki & reddit
  crawl -t <topic> -s <source>     Crawl specific source
  crawl -r <subreddit>             Crawl specific subreddit

${_CLR_BOLD}OPTIONS:${_CLR_RESET}
  ${_CLR_GREEN}-t, --topic${_CLR_RESET}      Topic to crawl (wiki page name / subreddit)
  ${_CLR_GREEN}-s, --source${_CLR_RESET}     Source: wiki, reddit, or both (default: both)
  ${_CLR_GREEN}-r, --subreddit${_CLR_RESET}  Single subreddit to crawl
  ${_CLR_GREEN}-R, --subreddits${_CLR_RESET} Comma-separated subreddits (e.g., "ai,ml,tech")
  ${_CLR_GREEN}-h, --help${_CLR_RESET}       Show this help message

${_CLR_BOLD}EXAMPLES:${_CLR_RESET}
  crawl AI                         # Crawl "AI" from wiki & reddit
  crawl -t javascript -s wiki      # Crawl only Wikipedia
  crawl -r programming             # Crawl r/programming
  crawl -R "ai,machinelearning"    # Crawl multiple subreddits
EOF
    return 0
  fi

  _msg_progress "Initiating crawl..."

  # Build JSON payload
  local json_payload="{"
  local has_field=false

  if [[ -n "$topic" ]]; then
    json_payload+="\"topic\":\"$topic\""
    has_field=true
  fi

  if [[ -n "$source" ]]; then
    [[ $has_field == true ]] && json_payload+=","
    json_payload+="\"source\":\"$source\""
    has_field=true
  fi

  if [[ -n "$subreddit" ]]; then
    [[ $has_field == true ]] && json_payload+=","
    json_payload+="\"subreddit\":\"$subreddit\""
    has_field=true
  fi

  if [[ -n "$subreddits" ]]; then
    [[ $has_field == true ]] && json_payload+=","
    # Convert comma-separated to JSON array
    local subs_array=$(echo "$subreddits" | sed 's/,/","/g')
    json_payload+="\"subreddits\":[\"$subs_array\"]"
    has_field=true
  fi

  json_payload+="}"

  echo "${_CLR_DIM}Request: POST ${_CRAWLER_API_URL}/crawl${_CLR_RESET}"
  echo "${_CLR_DIM}Payload: $json_payload${_CLR_RESET}"
  echo ""

  # Make the API call
  local response
  response=$(curl -sk --location --request POST "${_CRAWLER_API_URL}/crawl" \
    --header 'Content-Type: application/json' \
    --data "$json_payload" 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    _msg_error "Failed to connect to crawler API"
    return 1
  fi

  # Parse and display results
  echo "${_CLR_BOLD}${_CLR_CYAN}╔══════════════════════════════════════════════════════════════════════════╗"
  echo "║                          🕷️  CRAWL RESULTS                              ║"
  echo "╚══════════════════════════════════════════════════════════════════════════╝${_CLR_RESET}"
  echo ""

  echo "$response" | jq -r '
    .[] |
    if .source == "wiki" then
      "  📚 \(.status | ascii_upcase) | Wiki: \(.title // .url)"
    elif .source == "reddit" then
      "  🔴 \(.status | ascii_upcase) | r/\(.subreddit) (\(.count // 0) posts)"
    else
      "  📄 \(.status | ascii_upcase) | \(.url // .subreddit)"
    end
  ' 2>/dev/null || echo "$response"

  echo ""
  _msg_success "Crawl complete!"
}

# getCrawled - Fetch crawled articles from the API
# Usage: getCrawled [-s source] [-i id] [-f format]
#   -s, --source   Filter by source: wiki or reddit
#   -i, --id       Get specific article by source:id (e.g., wiki:AI)
#   -f, --format   Output format: table, json, or full (default: table)
#   -h, --help     Show this help message
getCrawled() {
  local source=""
  local article_id=""
  local format="table"
  local show_help=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--source)
        source="$2"
        shift 2
        ;;
      -i|--id)
        article_id="$2"
        shift 2
        ;;
      -f|--format)
        format="$2"
        shift 2
        ;;
      -h|--help)
        show_help=true
        shift
        ;;
      *)
        # Treat first positional arg as source or id
        if [[ "$1" == *":"* ]]; then
          article_id="$1"
        elif [[ -z "$source" ]]; then
          source="$1"
        fi
        shift
        ;;
    esac
  done

  if $show_help; then
    cat <<EOF
${_CLR_BOLD}${_CLR_CYAN}╔══════════════════════════════════════════════════════════════════════════╗
║                      📰 GETCRAWLED - View Articles                        ║
╚══════════════════════════════════════════════════════════════════════════╝${_CLR_RESET}

${_CLR_BOLD}USAGE:${_CLR_RESET}
  getCrawled                       List all crawled articles
  getCrawled -s wiki               List only Wikipedia articles
  getCrawled -i wiki:AI            Get specific article by ID
  getCrawled -f json               Output as raw JSON

${_CLR_BOLD}OPTIONS:${_CLR_RESET}
  ${_CLR_GREEN}-s, --source${_CLR_RESET}   Filter by source: wiki or reddit
  ${_CLR_GREEN}-i, --id${_CLR_RESET}       Get specific article (format: source:id, e.g., wiki:AI)
  ${_CLR_GREEN}-f, --format${_CLR_RESET}   Output format: table, json, or full (default: table)
  ${_CLR_GREEN}-h, --help${_CLR_RESET}     Show this help message

${_CLR_BOLD}EXAMPLES:${_CLR_RESET}
  getCrawled                       # List all articles
  getCrawled wiki                  # List wiki articles only
  getCrawled -s reddit             # List reddit posts only
  getCrawled -i wiki:javascript    # Get specific wiki article
  getCrawled -f json               # Output as JSON
  getCrawled -s wiki -f full       # Full details for wiki articles
EOF
    return 0
  fi

  local url="${_CRAWLER_API_URL}/articles"
  local response

  # If fetching specific article
  if [[ -n "$article_id" ]]; then
    url="${_CRAWLER_API_URL}/articles/${article_id}"
    _msg_progress "Fetching article: $article_id"
  else
    _msg_progress "Fetching articles..."
    # Add source filter if specified
    if [[ -n "$source" ]]; then
      url="${url}?source=${source}"
    fi
  fi

  echo "${_CLR_DIM}Request: GET $url${_CLR_RESET}"
  echo ""

  response=$(curl -sk --location "$url" 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    _msg_error "Failed to connect to crawler API"
    return 1
  fi

  # Check for 404
  if [[ "$response" == "Not Found" ]]; then
    _msg_error "Article not found"
    return 1
  fi

  # Output based on format
  case "$format" in
    json)
      echo "$response" | jq '.'
      ;;
    full)
      if [[ -n "$article_id" ]]; then
        # Single article full view
        echo "$response" | jq -r '
"╔══════════════════════════════════════════════════════════════════════════╗
 📰 \(.title)
╚══════════════════════════════════════════════════════════════════════════╝

🔗 URL: \(.url)
📅 Last Updated: \(.lastUpdated | split("T")[0])
📊 References: \(.referencesCount // "N/A")
🏷️  Source: \(.source)

📂 CATEGORIES:
\(.categories[0:10] | map("   • " + .) | join("\n"))

" + (if .infobox and (.infobox | length) > 0 then
"ℹ️  INFOBOX:
\(.infobox | to_entries[0:10] | map("   • \(.key): \(.value | tostring | .[0:60])") | join("\n"))
" else "" end)
        '
      else
        # Multiple articles full view
        echo "$response" | jq -r '
"╔══════════════════════════════════════════════════════════════════════════╗
║                         📰 CRAWLED ARTICLES                               ║
╚══════════════════════════════════════════════════════════════════════════╝

Total: \(length) articles
" +
(to_entries | map(
"┌──────────────────────────────────────────────────────────────────────────┐
│ #\(.key + 1) \(.value.title)
├──────────────────────────────────────────────────────────────────────────┤
│ 🔗 \(.value.url)
│ 📅 \(.value.lastUpdated | split("T")[0]) | 📊 \(.value.referencesCount // "N/A") refs | 🏷️ \(.value.source)
│ 📂 \(.value.categories[0:4] | join(", "))
└──────────────────────────────────────────────────────────────────────────┘
") | join("\n"))
        '
      fi
      ;;
    table|*)
      echo "${_CLR_BOLD}${_CLR_CYAN}╔══════════════════════════════════════════════════════════════════════════╗"
      echo "║                         📰 CRAWLED ARTICLES                               ║"
      echo "╚══════════════════════════════════════════════════════════════════════════╝${_CLR_RESET}"
      echo ""

      if [[ -n "$article_id" ]]; then
        # Single article table view
        echo "$response" | jq -r '
"  📰 Title:    \(.title)
  🔗 URL:      \(.url)
  📅 Updated:  \(.lastUpdated | split("T")[0])
  📊 Refs:     \(.referencesCount // "N/A")
  🏷️  Source:   \(.source)
  📂 Tags:     \(.categories[0:5] | join(", "))
"'
      else
        # Multiple articles table view
        local count=$(echo "$response" | jq 'length')
        echo "  ${_CLR_DIM}Found ${count} articles${_CLR_RESET}"
        echo ""
        echo "  ${_CLR_BOLD}#   SOURCE   TITLE                                    UPDATED      REFS${_CLR_RESET}"
        echo "  ${_CLR_DIM}─── ──────── ──────────────────────────────────────── ──────────── ─────${_CLR_RESET}"

        echo "$response" | jq -r '
to_entries | .[] |
"  \(.key + 1 | tostring | if length < 2 then " " + . else . end)  " +
(if .value.source == "wiki" then "📚 wiki  " else "🔴 reddit" end) + " " +
(.value.title | .[0:40] | . + (" " * (40 - length))) + " " +
(.value.lastUpdated | split("T")[0]) + " " +
(.value.referencesCount // 0 | tostring | (" " * (5 - length)) + .)
        '
      fi
      echo ""
      ;;
  esac

  _msg_success "Done!"
}
