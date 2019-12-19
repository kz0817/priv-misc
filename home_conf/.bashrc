# Basic setting -----------------------------------------------
OS_TYPE=`uname`
if [ -z $OS_TYPE ]; then
  OS_TYPE="unknown"
fi

# for Japanese and English ------------------------------------
alias utf='export LANG=ja_JP.UTF-8; export LANGUAGE=ja_JP.UTF-8; export LC_ALL=ja_JP.UTF-8'
alias en='export LANG=en_US.UTF-8; export LANGUAGE=en_US.UTF-8; export LC_ALL=en_US.UTF-8'

# Source the Machine independent setting  ------------------------
if [ -f .bashrc.local ]; then
  source .bashrc.local
fi

if [ x$USER = x"root" ]; then
  PMARK="#"
else
  PMARK="$"
fi

HISTSIZE=100000
HISTFILESIZE=100000

if [ x$NICKNAME != x ]; then
  PS1="[$NICKNAME]\w $PMARK "
else
  PS1="[\h]\w $PMARK "
fi


# Editor --------------------------------------------------------
export EDITOR=vim
export SVN_EDITOR=$EDITOR

# distcc ---------------------------------------------------------
#export DISTCC_HOSTS='localhost'

# screen ---------------------------------------------------------
alias screen='screen -U'
alias screen-flow-offs='screen -X defflow off; screen -X flow off'
alias ssh-auth-sock-update='~/misc/blade/bin/ssh-auth-sock-update.py > ~/.new-ssh-auth-sock-env && . ~/.new-ssh-auth-sock-env'

# grep -----------------------------------------------------------
export GREP_COLOR='1;37;41'
alias grep='grep -E --color=auto'

# PATH -----------------------------------------------------------
export PATH=~/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:~/android-sdk-linux_86/tools

DEVTOOLSET2_DIR=/opt/rh/devtoolset-2
DEVTOOLSET2_BIN_DIR=$DEVTOOLSET2_DIR/root/usr/bin
if [ -d $DEVTOOLSET2_BIN_DIR ]; then
  export PATH=$DEVTOOLSET2_BIN_DIR:$PATH
fi

# Scala ----------------------------------------------------------
if [ $OS_TYPE = "Darwin" ]; then
  export SCALA_HOME=/opt/scala
fi
if [ -e $SCALA_HOME ]; then
  export PATH=$PATH:$SCALA_HOME/bin
fi

# Gradle ----------------------------------------------------------
if [ -e $GRADLE_HOME ]; then
  export PATH=$PATH:$GRADLE_HOME/bin
fi

# CUDA ----------------------------------------------------------
# CUDA_DIR has to be set in another place (e.g. .bashrc.local)
if [ -e $CUDA_DIR ]; then
  export PATH=$CUDA_DIR/bin:$PATH
fi

# Aliases --------------------------------------------------------
alias vi=vim

alias cp='cp -iv'
alias rm='rm -iv'
alias mv='mv -iv'
if [ $OS_TYPE = "Linux" ]; then
  alias od='od -tx1z -Ax -v'
fi
if [ $OS_TYPE = "Darwin" ]; then
  alias od='od -tx1 -Ax'
fi


alias su='su -'
alias less='less -R'
alias gdb='gdb -q'

alias reset2='reset; stty sane; tput rs1; clear; echo -e "\033c"'

# ls -------------------------------------------------------------
if [ $OS_TYPE = "Linux" ]; then
  alias ls='ls -h'
  alias ll='ls -lhs'
  alias lla='ls -alhs'

  export LS_COLORS='no=97:fi=97:di=96:ln=92:pi=93:so=95:bd=93:cd=93:or=92:ex=93:su=93;44:sg=93;44:ow=97;45:*core=91'
  alias ls='ls --color=auto --show-control-chars'
fi
if [ $OS_TYPE = "Darwin" ]; then
  alias ls='ls -Gh'
  alias ll='ls -lGhs'
  alias lla='ls -aGlhs'
  export BLOCKSIZE=1048576
  export LSCOLORS=GxCxcxdxDxegedabagHfHf
fi

# GNU screen: title ----------------------------------------------
if [ x$NICKNAME != x ]; then
   export SCREEN_HOST=$NICKNAME:
else
   export SCREEN_HOST=`echo $HOSTNAME | sed "s,\..*$,,"`:
fi

if [ x$TERM = xscreen -o x$TERM = xscreen-256color ]; then
  USE_SCREEN=1
else
  USE_SCREEN=0
fi

function title_screen () {
  cmd=`history 1 | sed s/\ *[0-9]*\ *//`
  echo -en "\033k$SCREEN_HOST$cmd\033\\"
}

if [ $USE_SCREEN -eq 1 ]; then
  trap "title_screen" DEBUG
fi

function printdir() {
  echo -en "\033k[$SCREEN_HOST$(pwd | awk '{ print $(NF) }' FS='/')]\033\\"
}

if [ $USE_SCREEN -eq 1 ]; then
  PROMPT_COMMAND='printdir'
fi
