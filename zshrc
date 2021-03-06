# GENERAL
# -----------------------------------------------------------------------
DOTFILES_DIR=$HOME/.dotfiles

# load prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
plugins=(git)

bindkey -v
bindkey '^R' history-incremental-search-backward

# .localrc for secrets
if [[ -a ~/.localrc ]]
then
	source ~/.localrc
fi

# load control sequence variables
source $DOTFILES_DIR/env_scripts/colors.sh
# load work folder locations
source $DOTFILES_DIR/env_scripts/folders.sh

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# don't save lines beginning in spaces in history
setopt histignorespace

# PATH SETUP
# -----------------------------------------------------------------------
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="$HOME/Library/Python/3.8/bin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/Cellar/mtr/0.93_1/sbin:$PATH"
eval "$(pyenv init -)"

# export PATH=~/_/scratch/fuchsia/.jiri_root/bin:$PATH
# source ~/_/scratch/fuchsia/scripts/fx-env.sh
#
# export LIBGS="$(brew --prefix ghostscript)/lib/libgs.9.dylib"

export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig"



# use gpg-agent for SSH
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye > /dev/null
gpgconf --launch gpg-agent

# fix Python libc issue
export DYLD_LIBRARY_PATH=/usr/lib:$DYLD_LIBRARY_PATH
# fix Python OpenSSL on Catalina
export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_FALLBACK_LIBRARY_PATH

# make homebrew more secure
export HOMEBREW_NO_ANALYTICS=1 
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

# ENV CONFIG
# -----------------------------------------------------------------------
export ANSIBLE_NOCOWS=1


# ALIASES
# -----------------------------------------------------------------------

# Reminder me what aliases do so I don't forget
_print_alias() {
	alias_name=$2
	highlight_color=$1
	i=0
	while read -r line; do
		if [ "$i" -eq 0 ]; then
			printf "$alias_name is an alias for: "
		else
			echo "$(color $highlight_color "$line")"
		fi
		i=$((i+1))
	done < <(echo $(type $alias_name))
}
remind_alias() {
	_print_alias cyan $1
}
alias ra=remind_alias
warn_alias() {
	_print_alias yellow $1
}

cheat() {
	curl "cheat.sh/$1?style=bw"
}


# commands
alias c='clear'
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias dc='cd'
alias h='history | rg'
alias q='exit'
alias v='vim'
alias vi='vim'
alias vv='vim ~/.dotfiles/init.vim'
alias zv='vim ~/.zshrc'
alias t='tmux'
alias ta='tmux attach'
alias x='xargs' # clobber xquartz
alias zh='less ~/.zhistory'
alias zrg='rg < ~/.zshrc'
alias zr!='. ~/.zshrc'

alias tika="java -jar ~/Downloads/tika-app-1.24.1.jar"

# clobber utilities with preferred options
alias python='python3'
alias pip='pip3'
if $(nvim -v &>/dev/null); then
	alias vim='nvim'
fi
if $(rg &>/dev/null); then
	alias grep='rg'
fi
if $(exa &>/dev/null); then
	alias ls='exa'
	alias l='exa'
	alias ll='exa -l'
	alias lll='exa -la'
fi

# helpful tools
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'
alias combinepdf='(remind_alias combinepdf)
	/usr/local/bin/gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=out.pdf'
alias dnsflush='dscacheutil -flushcache'
alias dockspace="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"spacer-tile\";}'; killall Dock"
alias spellcheck='aspell --dont-backup check'
alias chromescrot='chrome --headless --disable-gpu --screenshot'
writecheck() {
	file_to_check="$1"
	echo "$(color cyan 'spellcheck')"
	spellcheck $file_to_check
	echo "$(color cyan 'alex')"
	alex $file_to_check
	echo "$(color cyan 'diction')"
	diction $file_to_check
	echo "$(color cyan 'style')"
	style $file_to_check
}
randp() {
	gpg --gen-random --armor 0 36

}
pdf2svg() {
	pdf_name=$1
	# Inkscape needs absolute paths.
	pdf_name=$(realpath "$pdf_name")
	cmd="inkscape --export-plain-svg=\"$pdf_name.svg\" \"$pdf_name\""
	echo "$(color cyan $cmd)"
	eval $cmd
}

# folder jumping
alias n="cd $NOTES_FOLDER"
alias p="cd $SRC_FOLDER"
alias s="cd $SCRATCH_FOLDER"
tmp() {
	cd $(mktemp -d /tmp/$1.XXXX)
}

# fancy man page
function xman() {
    for i in "$@"; do
        if [ $(command -v $i) ]; then
            open x-man-page://$i
        elif; then
            printf "Can't find command: %s\n" "$i" >&2
        fi
    done
}

# git
alias gu!='(warn_alias gu!)
	git commit --all --amend --no-edit'
alias gp='git push origin HEAD'
alias gp!='(warn_alias gp!)
	git push -f origin HEAD'
alias gll="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset\
	%C(yellow)%d%Creset %Cgreen(%cr)%Creset' \
	--abbrev-commit --date=relative"
alias gl='gll --color=always | head' # globber coreutils ls
alias glb='git lb'
alias gd='git diff'
alias gds='git diff --staged'
alias gs='git status' # clobber ghostscript
alias gc='git commit'
alias gaa='git add --all'
alias gco='git checkout'
alias gcom='git checkout master'
alias gb='git -P branch'
alias gms='git merge --squash'
alias grb='git rebase'
alias grbc='gre --continue'
alias grba='gre --abort'
alias gppru='git pull --prune'
alias grm="(warn_alias grm)
	git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
		perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"
rmbranch() {
	branch_name=$1
	printf "$(color red "deleting branch locally and on remote: $(bold red $branch_name)") "
	printf "$(dim red "(ctrl-c to abort)")\n"
	sleep 2
	git push --delete origin $branch_name && git branch -d $branch_name
}
rgit() {
	for dir in `ls "$SRC_FOLDER"`; do
		echo ""
		echo "running in $dir:"
		cd "$dir"
		git "$@"
		cd -
	done
}
pr_init() {
	pr_title=$1
	branch=$2
	base_branch=${3:-master}
	printf "$(color blue "creating new branch")\n"
	git checkout -b "$branch"
	printf "$(color blue "committing")\n"
	git commit --all --allow-empty -m "$pr_title"
	printf "$(color blue "creating PR")\n"
	gh pr create --base "$base_branch" --draft --title "$pr_title" --body "[TODO]"
}

# cargo
alias cc='cargo check' # clobber llvm
alias cbr='cargo build --release'
alias crr='cargo run --release'
alias cb='cargo build'
alias ct='cargo test'
alias cf='cargo fmt'
alias cpr='(remind_alias cpr)
	cargo test && cargo clippy --all && cargo fmt'

# yarn
alias yr='yarn run'
alias fukjs='rm -rf node_modules;yarn install'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# terraform
alias tf='terraform'

# Wasmer
export WASMER_DIR="/Users/matt/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"
