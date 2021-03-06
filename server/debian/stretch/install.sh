#!/bin/bash

#Script Template
#==============================================================================
#title           :
#description     :
#author		 :Marc Landolt, @FailDef
#date            :
#version         :0.1
#usage		 :
#notes           :
#bash_version    :
#==============================================================================


# Define Editor
#==============================================================================
#EDITOR=$(which nano)
EDITOR=$(which vim)
#==============================================================================


# Color Definitions
#==============================================================================
red="\e[91m"
default="\e[39m"
#==============================================================================


# Define which Linux Distribution
#==============================================================================
#distro=jessie
distro=stretch
#==============================================================================


# Helper Function to show first the command that is beeing executed
#==============================================================================
function ShowAndExecute {
#show command
echo -e "${red} $1 ${default}"
#execute command
$1
#test if it worked or give an ERROR Message in red, return code of apt is stored in $?
rc=$?; if [[ $rc != 0 ]]; then echo -e ${red}ERROR${default} $rc; fi
}
##test if everything worked
#==============================================================================


# Helper Function for YES or NO Answers
#------------------------------------------------------------------------------
# Example YESNO "Question to ask" "command to be executed"
#==============================================================================
function YESNO {
echo -e -n "
${red}$1 [y/N]${default} "
read -d'' -s -n1 answer
echo
if  [ "$answer" = "y" ] || [ "$answer" = "Y" ]
then
return 0
else
echo -e "
"
return 1
fi
}
#==============================================================================


# Test if script runs as root otherweise exit with exit code 1
#==============================================================================
if [[ $EUID -ne 0 ]]; then
  echo -e -n "
${red}You must be a root user to run this script${default}
at the moment you are " 2>&1
  id | cut -d " " -f1
  echo
  exit 1
fi
#==============================================================================


# Test if user has given enough parameters
#==============================================================================
if "$1" = ""
then
echo -e "
Usage:
------
Enter the (new) Database Password as parameter ${red}sudo ${0} 123456${default} "
echo
echo " arguments ---------------->  ${@}     "
echo " \$1 ----------------------->  $1       "
echo " \$2 ----------------------->  $2       "
echo " path to script ----------->  ${0}     "
echo " parent path -------------->  ${0%/*}  "
echo " script name -------------->  ${0##*/} "
echo
exit 0
fi
#==============================================================================

echo -e "${red}${0} ${@}${default}"

# get the newest updates
#==============================================================================
ShowAndExecute "cat -e /var/lib/dpkg/lock"

ShowAndExecute "apt --fix-broken install"

ShowAndExecute "dpkg --configure -a"

ShowAndExecute "apt-get -y update"

ShowAndExecute "apt-get -y upgrade"

ShowAndExecute "apt-get -y dist-upgrade"

ShowAndExecute "apt-get -y install sudo git vim nano"
#==============================================================================

# edit repository list
#==============================================================================
if YESNO "Edit /etc/apt/sources.list?"
then
ShowAndExecute "$EDITOR /etc/apt/sources.list"
fi

if YESNO "Use TOR (The Onion Router) for APT Transport?"
then

  ShowAndExecute "apt-get -y install torsocks apt-transport-tor"

  cp /etc/apt/sources.list /etc/apt/sources.list-$(date +%Y%m%d-%H%M%S.bak)
  echo "
deb tor+http://vwakviie2ienjx6t.onion/debian/ $codename main contrib
deb tor+http://earthqfvaeuv5bla.onion/debian/ $codename main contrib
" > /etc/apt/sources.list

ShowAndExecute "apt-get -y update"

ShowAndExecute "apt-get -y upgrade"

ShowAndExecute "apt-get -y install tor tor-arm"
fi

if YESNO "Use normal httpredir.debian.org for APT Transport?"
then
  cp /etc/apt/sources.list /etc/apt/sources.list-$(date +%Y%m%d-%H%M%S.bak)
  echo "
deb http://httpredir.debian.org/debian/ $distro main contrib
deb-src http://httpredir.debian.org/debian/ $distro main contrib

deb http://security.debian.org/ $distro/updates main contrib
deb-src http://security.debian.org/ $distro/updates main contrib

deb http://httpredir.debian.org/debian/ $distro-updates main contrib
deb-src http://httpredir.debian.org/debian/ $distro-updates main contrib
" >/etc/apt/sources.list

fi

# edit repository list after modification
#==============================================================================
if YESNO "Edit /etc/apt/sources.list?"
then
ShowAndExecute "$EDITOR /etc/apt/sources.list"

ShowAndExecute "apt-get -y update"

ShowAndExecute "apt-get -y upgrade"
fi

# edit repository list after modification
#==============================================================================
ShowAndExecute "apt-get -y install md5deep"
ShowAndExecute "apt-get -y install rdfind"
ShowAndExecute "apt-get -y install nmap"
ShowAndExecute "apt-get -y install rsync"
ShowAndExecute "apt-get -y install snmp"
ShowAndExecute "apt-get -y install snmpd"
ShowAndExecute "apt-get -y install jigdo-file"
ShowAndExecute "apt-get -y install build-essential"
ShowAndExecute "apt-get -y install pkg-config "
ShowAndExecute "apt-get -y install libdbus-1-dev"
ShowAndExecute "apt-get -y install apt-file"
ShowAndExecute "apt-file update"
ShowAndExecute "apt-get -y install figlet"
ShowAndExecute "apt-get -y install git"
ShowAndExecute "apt-get -y install tcpdump"
ShowAndExecute "apt-get -y install iptraf"
ShowAndExecute "apt-get -y install screen"

#printf "install pamusb (y/n)"
#gparted
#/usr/bin/pamusb-conf --add-device seven
#/usr/bin/pamusb-conf --add-user $(id -u 1000 -n)

#printf "install tripwire?"
#echo -e "Benutzer \e[92mguest\e[39m erstellen mit zweitem mini MemoryStick, den man auch stecken lassen kann und keine Admin-rechte hat (y/n)?"

#echo -e "generell Bunt einschalten im vim"
#echo "syntax on" >>$HOME/.vimrc
#printf "install torbrowser-launcher non-free"

ShowAndExecute "apt-get autoremove"


