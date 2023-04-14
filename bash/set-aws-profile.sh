#!/bin/bash
# COLOR CONFIG
red=$(tput setaf 1)
green=$(tput setaf 2)
bold=$(tput bold)
background_green=$(tput setab 2)
background_blue=$(tput setab 4)
reset=$(tput sgr0)
# VARIABLES
AWS_DEFAULT_PROFILE=""

usage(){
  printf "Used to set the default profile in your ~/.aws/config file${reset}\n\n"
  printf "Usage:\n $0 -p <<PROFILE_NAME>>\n${reset}"
  printf "${background_blue}${bold}***The profile name should be the same as in your ./aws/config file${reset}\n\n"
}

while getopts ":p:c:" o; do
    case "${o}" in
        p)
          AWS_DEFAULT_PROFILE=${OPTARG}
          ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

set_default_profile() {
  if [ -z "${AWS_DEFAULT_PROFILE}" ]; then
      printf "${red}${bold}You need to provide a profile name${reset}\n\n"
      exit 1;
  elif grep -q "${AWS_DEFAULT_PROFILE}" ~/.aws/config; then
    # remove # to uncomment previous default profile
    sed -i "s/\#\[/\[/" ~/.aws/config
    # Remove [default] line
    sed -i "/\[default\]/d" ~/.aws/config
    # Comment [profile $PROFILE_NAME] entry for the new default profile
    sed -i "s/\[profile ${AWS_DEFAULT_PROFILE}\]/\#\[profile ${AWS_DEFAULT_PROFILE}\]/" ~/.aws/config
    #Create [default] entry on the new default profile
    sed -i "/\#\[profile ${AWS_DEFAULT_PROFILE}\]/a \[default\]" ~/.aws/config
    printf "${green}Success: \n\nAWS_DEFAULT_PROFILE set to ${bold}${AWS_DEFAULT_PROFILE}${reset}\n\n"
  else
    printf "${background_green}${red}${bold}ERROR: \n\n Profile ${AWS_DEFAULT_PROFILE} not found on ~/.aws/config${reset}\n\n"
    exit 1;
  fi
}

check_default_profile() {
  DEFAULT=$(awk '/default/{print prev} {prev=$0}' ~/.aws/config)
  printf "${green}Default profile is: \n\n${bold}${DEFAULT}${reset}\n\n"
  AVAILABLE=$(grep 'profile' ~/.aws/config)
  printf "${green}Available profiles are: \n\n${bold}${AVAILABLE}${reset}\n\n"
}

if [ -z "${AWS_DEFAULT_PROFILE}" ]; then
  usage
  check_default_profile
else
    set_default_profile
fi