#!/bin/bash
# ----------------------------------------
# 💻 dev_aliases.sh
# A collection of productivity aliases and functions
# for Linux developers using Git, Python, CLI, etc.
# ----------------------------------------

# -------------------------------
# 📁 Quick Navigation Aliases
# -------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias home='cd ~'
alias desk='cd ~/Desktop'
alias dls='cd ~/Downloads'
alias docs='cd ~/Documents'
alias tmp='cd ~/Documents/temp'
alias wrkspace='cd ~/eclipse-workspace'
alias build_kid='cd ~/Documents/centilio/Development/build_deployment'

# -------------------------------
# 🔧 Git Shortcuts
# -------------------------------
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gco='git checkout'
alias gp='git push'
alias gl='git log --oneline --graph --all'
alias gb='git branch'
alias gpull='git pull origin $(git branch --show-current)'

# -------------------------------
# 🐍 Python & Scripting Helpers
# -------------------------------
alias py='python3'
alias pipi='pip install'
alias serve='python3 -m http.server'

# Virtualenv shortcuts
alias venv-on='source ~/Documents/my-world/venv/bin/activate'
alias venv-off='deactivate'

# -------------------------------
# ⚙️ Shell Config & Utilities
# -------------------------------
alias reload='source ~/.bashrc'  # or ~/.zshrc
alias bashrc='nano ~/.bashrc'
alias c='clear'

# -------------------------------
# 💾 Disk & File Utilities
# -------------------------------
alias dus='du -sh * | sort -h'
alias dfh='df -h'
alias f='find . -name'           # Fast file search

# -------------------------------
# 🧠 Process & Port Monitoring
# -------------------------------
alias psf='ps aux | grep -v grep | grep'   # Find process
alias psg='ps -ef | grep'                  # Find service
alias ports='sudo lsof -i -P -n | grep LISTEN'  # Open ports

# -------------------------------
# 📁 Directory Bookmarks
# -------------------------------
alias setproj='export PROJECT_DIR=$(pwd)'
alias gotoproj='cd $PROJECT_DIR'

# -------------------------------
# 🗑️ Safe Delete with Trash CLI
# Requires: sudo apt install trash-cli
# -------------------------------
alias rm='trash'           # Move files to trash instead of permanent delete
alias emptytrash='trash-empty'

# -------------------------------
# 📦 Extract Anything
# -------------------------------
extract () {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1" ;;
      *.tar.gz)    tar xzf "$1" ;;
      *.bz2)       bunzip2 "$1" ;;
      *.rar)       unrar x "$1" ;;
      *.gz)        gunzip "$1" ;;
      *.tar)       tar xf "$1" ;;
      *.tbz2)      tar xjf "$1" ;;
      *.tgz)       tar xzf "$1" ;;
      *.zip)       unzip "$1" ;;
      *.Z)         uncompress "$1" ;;
      *.7z)        7z x "$1" ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# -------------------------------
# 🗂️ Open File Explorer from Terminal
# -------------------------------
alias ex='xdg-open "$PWD" >/dev/null 2>&1 &'

# -------------------------------
# 🔍 Live Log Watch with Filtering
# Usage: watchlog /var/log/syslog ERROR
# -------------------------------
watchlog () {
  tail -f "$1" | grep --color=auto -E "$2"
}




# ssh-cent   — SSH into a centilio.com subdomain as root
# Usage: ssh-cent <service>  or  ssh-cent -h
function ssh-cent() {
    local help_msg=$'Usage: ssh-cent [-h] <service>\n\nExamples:\n  ssh-cent account\n  ssh-cent drive\n  ssh-cent signlocal'
    # parse flags
    while getopts ":h" opt; do
        case $opt in
            h) echo "$help_msg"; return;;
            \?) echo "Invalid option: -$OPTARG" >&2; echo "$help_msg"; return 1;;
        esac
    done
    shift $((OPTIND-1))

    if [[ -z $1 ]]; then
        echo "✖ No service specified." >&2
        echo "$help_msg"
        return 1
    fi

    local svc=$1
    local host="${svc}.centilio.com"

    # basic sanity check (you could ping or nslookup here if you like)
    if ! ssh -o BatchMode=yes -o ConnectTimeout=5 root@"$host" true 2>/dev/null; then
        echo -e "✖ Cannot reach root@$host" >&2
        return 2
    fi

    echo -e "→ Connecting to root@$host…"
    ssh root@"$host"
}


# ssh-cent-menu — pick a Centilio host to SSH into as root
# Usage: ssh-cent-menu
function ssh-cent-menu() {
    # Help flag
    if [[ $1 == "-h" || $1 == "--help" ]]; then
        cat <<EOF
${BLUE}Usage:${NC} ssh-cent-menu

Presents a menu of predefined Centilio subdomains.
Select by number to SSH in as root (password prompt will appear).
EOF
        return 0
    fi

    # Define your services here
    local services=( account accountlocal drive drivelocal signlocal forms sign seobot seobotlocal forms) 

    echo -e "${GREEN}Available Centilio hosts:${NC}"
    for i in "${!services[@]}"; do
        printf "  ${BLUE}%2d)${NC} %s.centilio.com\n" "$i" "${services[$i]}"
    done

    # Prompt loop
    while true; do
        read -rp $'\n'"Select host number (or 'q' to quit): " choice

        # Quit
        if [[ $choice =~ ^[Qq]$ ]]; then
            echo "Aborted."
            return 1
        fi

        # Validate numeric choice
        if ! [[ $choice =~ ^[0-9]+$ ]]; then
            echo -e "${RED}Invalid input; enter a number.${NC}"
            continue
        fi

        # In-range?
        if (( choice < 0 || choice >= ${#services[@]} )); then
            echo -e "${RED}Number out of range.${NC}"
            continue
        fi

        # Build host and SSH
        local svc=${services[$choice]}
        local host="${svc}.centilio.com"
        echo -e "${GREEN}→ Connecting to root@$host…${NC}"
        ssh root@"$host"
        return $?
    done
}
