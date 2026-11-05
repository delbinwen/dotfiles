# .zprofile — sourced for login shells (iTerm2 opens login shells by default)

# Homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
