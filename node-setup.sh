#!/bin/bash
set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

#########################################################################
totalRpc=0
totalValidator=0
totalNodes=$(($totalRpc + $totalValidator))

#########################################################################

#+-----------------------------------------------------------------------------------------------+
#|                                                                                                                              |
#|                                                      FUNCTIONS                                                |
#|                                                                                                                              |     
#+------------------------------------------------------------------------------------------------+

task1(){
  # update and upgrade the server TASK 1
  echo -e "\n\n${ORANGE}TASK: ${GREEN}[running upgrade]${NC}\n"
  apt update && apt upgrade -y
  echo -e "\n${GREEN}[TASK 1 PASSED]${NC}\n"
}

task2(){
  # installing build-essential TASK 2
  echo -e "\n${ORANGE}TASK: ${GREEN}[installing build-essential]${NC}\n"
  apt -y install build-essential tree
  echo -e "\n${GREEN}[TASK 2 PASSED]${NC}\n"
}

task3(){
  # getting golang TASK 3
  echo -e "\n${ORANGE}TASK: ${GREEN}[getting golang v 1.17.3]${NC}\n"
  cd ./tmp && wget "https://go.dev/dl/go1.17.3.linux-amd64.tar.gz"
  echo -e "\n${GREEN}[TASK 3 PASSED]${NC}\n"
}

task4(){
  # setting up golang TASK 4
  echo -e "\n${ORANGE}TASK: ${GREEN}[installing golang]${NC}\n"
  rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.3.linux-amd64.tar.gz
  echo "PATH=$PATH:/usr/local/go/bin" >>/etc/profile
  export PATH=$PATH:/usr/local/go/bin
  go env -w GO111MODULE=off
  echo -e "\n${GREEN}[TASK 4 PASSED]${NC}\n"
}

task5(){
  # set proper group and permissions TASK 5
  echo -e "\n${ORANGE}TASK: ${GREEN}[setting up group and permissions]${NC}\n"
  ls -all
  cd ../
  ls -all
  chown -R root:root ./
  chmod a+x ./node-start.sh
  echo -e "\n${GREEN}[TASK 5 PASSED]${NC}\n"
}

task6(){
  # do make all TASK 6
  echo -e "\n${ORANGE}TASK: ${GREEN}[making all]${NC}\n"
  cd node_src
  make all
  echo -e "\n${GREEN}[TASK 6 PASSED]${NC}\n"
}

task7(){
  # setting up directories and structure for node/s TASK 7
  echo -e "\n${ORANGE}TASK: ${GREEN}[setting up directories]${NC}\n"

  cd ../

  i=1
  while [[ $i -le $totalNodes ]]; do
    mkdir ./chaindata/node$i
    ((i += 1))
  done

  tree ./chaindata
  echo -e "\n${GREEN}[TASK 7 PASSED]${NC}\n"
}

task8(){
  #TASK 8
  echo -e "\n${ORANGE}TASK: ${GREEN}[getting password for account]${NC}\n"
  echo -e "\n${ORANGE}This step is very important. Input a password that will be used for a newly created validator account. In next step you will recieve a public key for your validator account"
  echo -e "${ORANGE}Once a validator account is created using your given password, I'll give you where the keystore file is located so you can import it in metamask\n\n${NC}"

  i=1
  while [[ $i -le $totalValidator ]]; do
    echo -e "\n\n${GREEN}+-----------------------------------------------------------------------------------------------------+"
    read -p "\nEnter password for validator $i:  " password
    echo $password >./chaindata/node$i/pass.txt
    ./node_src/build/bin/geth --datadir ./chaindata/node$i account new --password ./chaindata/node$i/pass.txt
    ./node_src/build/bin/geth --datadir ./chaindata/node$i init ./genesis.json
    ((i += 1))
  done

  echo -e "\n${GREEN}[TASK 8 PASSED]${NC}\n"
}

labelNodes(){
  i=1
  while [[ $i -le $totalValidator ]]; do
    touch ./chaindata/node$i/.validator
    ((i += 1))
  done 

  i=$((totalValidator + 1))
  while [[ $i -le $totalNodes ]]; do
    touch ./chaindata/node$i/.rpc
    ((i += 1))
  done 


}

displayStatus(){
  # start the node
  echo -e "\n Your newly created account and password is located at ./chaindata/node1"
  echo -e "\n${ORANGE}STATUS: ${GREEN}ALL TASK PASSED!\n This program will now exit\n Now run ./node-start.sh${NC}\n"
}

displayWelcome(){
  # display welcome message
  echo -e "\n\n\t${ORANGE}Total RPC to be created: $totalRpc"
  echo -e "\t${ORANGE}Total Validators to be created: $totalValidator"
  echo -e "\t${ORANGE}Total nodes to be created: $totalNodes"
  echo -e "${GREEN}
  \t+------------------------------------------------+
  \t|   DPos node installation Wizard
  \t|   Target OS: Ubuntu 20.04 LTS (Focal Fossa)
  \t|   Your OS: $(. /etc/os-release && printf '%s\n' "${PRETTY_NAME}") 
  \t+------------------------------------------------+
  ${NC}\n"

  echo -e "${ORANGE}
  \t+------------------------------------------------+
  \t+------------------------------------------------+
  ${NC}"
}

createRpc(){
  task1
  task2
  task3
  task4
  task5
  task6
  task7
}

createValidator(){
   task8
}

finalize(){
  displayWelcome
  createRpc
  createValidator
  labelNodes
  displayStatus
}


#########################################################################

#+-----------------------------------------------------------------------------------------------+
#|                                                                                                                             |
#|                                                                                                                             |
#|                                                      UTILITY                                                        |
#|                                                                                                                             |
#|                                                                                                                             |
#+-----------------------------------------------------------------------------------------------+


# Default variable values
verbose_mode=false
output_file=""

# Function to display script usage
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo " -h, --help      Display this help message"
  echo " -v, --verbose   Enable verbose mode"
  echo " -f, --file      FILE Specify an output file"
  echo "--rpc  <whole number>     Specify number of rpc node to create"
  echo "--validator  <whole number>     Specify number of validator node to create"
}

has_argument() {
  [[ ("$1" == *=* && -n ${1#*=}) || (! -z "$2" && "$2" != -*) ]]
}

extract_argument() {
  echo "${2:-${1#*=}}"
}

# Function to handle options and arguments
handle_options() {
  while [ $# -gt 0 ]; do
    case $1 in

    # display help
    -h | --help)
      usage
      exit 0
      ;;

    # toggle verbose
    -v | --verbose)
      verbose_mode=true
      ;;

    # take file input
    -f | --file*)
      if ! has_argument $@; then
        echo "File not specified." >&2
        usage
        exit 1
      fi

      output_file=$(extract_argument $@)

      shift
      ;;

    # take ROC count
    --rpc*)
      if ! has_argument $@; then
        echo "No number given" >&2
        usage
        exit 1
      fi
      totalRpc=$(extract_argument $@)
      totalNodes=$(($totalRpc + $totalValidator))
      shift
      ;;

    # take validator count
    --validator*)
      if ! has_argument $@; then
        echo "No number given" >&2
        usage
        exit 1
      fi
      totalValidator=$(extract_argument $@)
      totalNodes=$(($totalRpc + $totalValidator))
      shift
      ;;

    *)
      echo "Invalid option: $1" >&2
      usage
      exit 1
      ;;

    esac
    shift
  done
}

# Main script execution
handle_options "$@"

# Perform the desired actions based on the provided flags and arguments
if [ "$verbose_mode" = true ]; then
  echo "Verbose mode enabled."
fi

if [ -n "$output_file" ]; then
  echo "Output file specified: $output_file"
fi

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    usage
    exit 1
fi



finalize

