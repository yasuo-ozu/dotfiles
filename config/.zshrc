
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

autoload -Uz compinit
compinit

export EDITOR=vim

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify auto_pushd hist_ignore_space

hash -d doc=~/ドキュメント
bindkey -e


alias vi=vim
alias ls="ls -a --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -la --color=auto"
alias l=ls
alias objdump="objdump -CSlw -M intel"
alias clear="tput reset"

mkcd(){
	mkdir -p $1
	cd $1
}

setopt prompt_subst
autoload -Uz colors
colors

local return_code="%(?..%{$fg[red]%}%? %{$reset_color%})"
PROMPT='\
%{$fg[blue]%}{ %c } \
%{$fg[green]%}`  git rev-parse --abbrev-ref HEAD 2> /dev/null || echo ""  `%{$reset_color%} \
%{$fg[red]%}%(!.#.»)%{$reset_color%} '

PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

RPS1='%{$fg[blue]%}%~%{$reset_color%} ${return_code} '

export PATH=$PATH:~/bin

export GOPATH=$HOME/.go



#alias "open=sh -c \"nautilus . &> /dev/null\" &"

open() {
	if [ $# -gt 0 ]; then
		xdg-open $@
	else
		xdg-open .
	fi
}

# export GDK_BACKEND=x11
alias grep='grep --color=auto' 
PATH=/usr/local/heroku/bin:~/.local/bin:$PATH

export LESS='-i -R'
export PAGER=less

export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

export LESSOPEN='| ~/.local/bin/lesspipe.sh %s'
alias vimdiff="vim -d"

PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

rm() {
	local flag=0
	for arg in "$@"; do
		if [[ "$arg" =~ ^-  ]]; then
			if [ $(echo "$arg" | grep -e 'f') ]; then
				: $(( flag += 1 ))
			fi
		fi
	done
	if [ $flag -eq 0 ]; then
		trash-put "$@"
	else
		/usr/bin/rm "$@"
	fi
}

home() {
	local DATESTR=$(date +%y%m%d)
	local DIRBASE=/home/$(whoami)/Documents
	if [ $# -eq 1 ]; then
		DIRBASE="$DIRBASE/$1"
		if [ ! -d "$DIRBASE" ]; then
			echo "$DIRBASE is not a directory" 1>&2
			return 1
		fi
	fi
	while read LINE; do
		local DIR="$DIRBASE/$LINE"
		if [ -z "$(cd $DIR; /bin/ls -A)" ]; then
			rmdir $DIR
		fi
	done < <(find "$DIRBASE/" -maxdepth 1 -type d | sed -s 's:^.*/\([^/]*\)$:\1:'| sed -ne '/^[0-9]\{6\}$/p')
	local DIRNAME="$DIRBASE/$DATESTR"
	mkdir -p "$DIRNAME"
	cd "$DIRNAME"
}
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

# zsh editor
#autoload zed

# zsh run cmd
alias -s {txt,md}='less'

# zsh abbreviations
setopt extended_glob
#typeset -A abbreviations
#abbreviations=(
#	"clone" "git clone"
#	"C" "cat"
#	"-Syu" "sudo pacman -Syu"
#	"-Ss" "pacman -Ss"
#	"-S" "sudo pacman -S"
#	"-Rss" "sudo pacman -Rss"
#)
#magic-abbrev-expand() {
#    local MATCH
#    LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
#    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
#    zle self-insert
#
#}
#
#no-magic-abbrev-expand() {
#    LBUFFER+=' '
#
#}
#
#zle -N magic-abbrev-expand
#zle -N no-magic-abbrev-expand
#bindkey " " magic-abbrev-expand
#bindkey "^x " no-magic-abbrev-expand
#

say() {
	local WAVFILE=$(mktemp "/tmp/say-XXXXXX.wav")
	local TEXTFILE=$(mktemp "/tmp/say-XXXXXX.txt")
	/bin/echo $1 > $TEXTFILE
	open_jtalk -x /usr/share/open-jtalk/dic -ow $WAVFILE -m /usr/share/open-jtalk/voices/mei_normal.htsvoice $TEXTFILE &> /dev/null
	aplay $WAVFILE &> /dev/null
}

dup() {
	if [ "$#" -ge 1 ]; then
		( cd "$1"; gnome-terminal . ) &> /dev/null
	else
		gnome-terminal . &> /dev/null
	fi
}

today() {
	while read LINE; do
		local DIR="./$LINE"
		if [ -z "$(cd $DIR; /bin/ls -A)" ]; then
			rmdir $DIR
		fi
	done < <(find "." -maxdepth 1 -type d | sed -s 's:^.*/\([^/]*\)$:\1:'| sed -ne '/^[0-9]\{2\}_[0-9]\{2\}$/p')
	while read LINE; do
		local FILE="./$LINE"
		if [ ! -s "$FILE" ]; then
			rm "$FILE"
		fi
	done < <(find "." -maxdepth 1 -type f | sed -s 's:^.*/\([^/]*\)$:\1:'| sed -ne '/^[0-9]\{2\}_[0-9]\{2\}\.txt$/p')
	local TODAY=$(date '+%m_%d')
	local FNAME=${TODAY}.txt
	vim "$FNAME"
	if [ ! -e "$FNAME" ]; then
		mkdir -p "$TODAY"
		cd "$TODAY"
	fi
}

runtex() {
	TEXFILE="$1"
	shift
	if [ ! -f "$TEXFILE" ]; then
		echo "Usage: runtex texfile.tex" 1>&2
		return 1
	fi
	TEXDIR="${TEXFILE}.files"
	if [ ! -d "$TEXDIR" ]; then
		cp -r "$HOME/.local/share/runtex" "$TEXDIR"
	fi
	PWD="$TEXDIR" make -C "$TEXDIR" "$@"
}

list_dangling_vim_swap_file() {
	local SWAPDIR="$(cd ~/.vim/swap/; pwd)"
	local SWAPLIST="$(find "$SWAPDIR" -type f)"
	local PROCLIST=(`pidof vim nvim`)
	for P in "${PROCLIST[@]}"; do
		local FDLIST=($(find "/proc/$P/fd/"))
		for L in "${FDLIST[@]}"; do
			if [ -h "$L" ]; then
				local F="$(readlink "$L")"
				SWAPLIST="$(diff <(echo "$SWAPLIST") <(echo "$F") | sed -ne '/< /p' | cut -c 3-)"
			fi
		done
	done
	echo "$SWAPLIST"
}
		
