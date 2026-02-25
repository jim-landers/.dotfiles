autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey '^X^E' edit-command-line

bindkey '^F' autosuggest-accept
bindkey '^R' history-incremental-search-backward
