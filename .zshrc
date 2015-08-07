# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="rkj-repos"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git autojump osx brew sudo xcode)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# vim mode
bindkey -v

# pythonbrew
[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc

# rvm
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# safe rm
# Don't remove the file, just move them to a temporary directory.
# Files are grouped by remove time.
# e.g.
#   # pwd => /home/work/
#   > rm -r -f aa
#   'aa' will move to ~/.TrashHistory/20141018/aa@120111@_home_work_aa
_RM_BACKUP_PATH=~/.TrashHistory
function safe_rm() {
    mkdir -p ${_RM_BACKUP_PATH}
    # skip cmd option, e.g. '-rf' in 'rm -rf a b' or '-r/-f' in 'rm -r -f a b'
    local first_char=${1:0:1}
    until [ ! "$first_char" = "-" ]
    do
        shift
        first_char=${1:0:1}
    done

    # check param
    if [ $# -lt 1 ]; then
        echo 'usage: rm [-f | -i] [-dPRrvW] file ...'
        exit 1
    fi

    local today=`date +"%Y%m%d"`
    local mvpath=${_RM_BACKUP_PATH}/$today

    # support for multi version
    local timestamp=`date +"%H%M%S"`

    # create dir if path non-exist
    if [ ! -d $mvpath ]; then
        mkdir $mvpath
    fi

    until [ $# -eq 0 ]
    do
        # fetch absolute path of the file
        local file_path=$1
        local fchar=`echo "${file_path:0:1}"`
        if [ "$fchar" = "/" ]; then
            local dist_path="_${file_path}"
        else
            local abs_fpath=`pwd`/$file_path
            local dist_path="${file_path}@${timestamp}@${abs_fpath}"
        fi

        # substitue '/' to '_'
        local final_dist_path=${dist_path//\//^}

        # mv to temp trash
        mv $file_path $mvpath/$final_dist_path

        # next file
        shift
    done
}

function unsafe_rm() {
    rm $*
}

# revert files that remove by safe_rm
# you can choose the right one in multi files removed
function revert_rm() {
    # process multi files
    until [ $# -eq 0 ]
    do
        echo "revert for $1:"
        for _f in `find $_RM_BACKUP_PATH -name "$1@*" -print`
        do
            local d=`echo $_f | awk -F\/ '{print $2}'`
            local t=`echo $_f | awk -F@ '{print $2}'`
            local file_path=`echo $_f | awk -F@ '{print $3}'`
            file_path=${file_path//^/\/}

            echo -n "      $file_path at ${d:0:4}-${d:4:2}-${d:6:2} ${t:0:2}:${t:2:2}:${t:4:2}   [y/n]? "
            read _confirm
            if [ "${_confirm}" = 'y' ]; then
                mv $_f $file_path
                break
            fi
        done

        shift
    done
}

alias urm='unsafe_rm'
alias rm='safe_rm'

