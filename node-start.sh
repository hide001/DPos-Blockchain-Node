#!/bin/bash
#set -x

set -e


GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

#########################################################################
totalRpc=0
totalValidator=0
totalNodes=$(($totalRpc + $totalValidator))
rpcFlag=.rpc
validatoFlag=.validator
isRPC=false
isValidator=false
#########################################################################


source ./.env



# echo -e "${GREEN}**********************************************************************"
# echo -e "Starting node"


#     if tmux has-session -t 0 > /dev/null 2>&1; then
#         :
#     else
#         tmux new-session -d -s 0
#         tmux send-keys -t 0 "./node_src/build/bin/geth --datadir ./chaindata/node1 --networkid $CHAINID --bootnodes $BOOTNODE --mine --unlock 0 --password ./chaindata/node1/pass.txt --syncmode=full console" Enter
#     fi

# echo -e "${ORANGE}Node started\nEnter ${GREEN}tmux attach -t 0 ${ORANGE}to see node in action${NC}"
# echo -e "\n${ORANGE}Now give your tmux-geth instance sometime to sync till the recent block. Once it's done you can go to staking page and activate your validator by staking"
# echo -e "\n${ORANGE}Remember to import the account's key store file into you metmask for staking.${NC}"
# echo -e "\n${GREEN}**********************************************************************"



#########################################################################

#+-----------------------------------------------------------------------------------------------+
#|                                                                                                                             |
#|                                                                                                                             |
#|                                                      FUNCTIONS                                                |
#|                                                                                                                             |
#|                                                                                                                             |
#+-----------------------------------------------------------------------------------------------+

welcome(){
  # display welcome message
  echo -e "\n\n\t${ORANGE}Total RPC installed: $totalRpc"
  echo -e "\t${ORANGE}Total Validators installed: $totalValidator"
  echo -e "\t${ORANGE}Total nodes installed: $totalNodes"
  echo -e "${GREEN}
  \t+------------------------------------------------+
  \t+   DPos node Execution Utility
  \t+   Target OS: Ubuntu 20.04 LTS (Focal Fossa)
  \t+   Your OS: $(. /etc/os-release && printf '%s\n' "${PRETTY_NAME}") 
  \t+   example usage: ./node-start.sh --help
  \t+------------------------------------------------+
  ${NC}\n"

  echo -e "${ORANGE}
  \t+------------------------------------------------+
  \t+------------------------------------------------+
  ${NC}"
}

countNodes(){
  local i=1
  $totalNodes=$(ls -l | grep -c ^d)
  while [[ $i -le $totalNodes ]]; do
    
    if [ -f "./chaindata/$rpcFlag" ]; then  
      totalRpc+=1 
    else  
        if [ -f "./chaindata/$validatorFlag" ]; then
        totalValidator+=1
        fi
    fi  
    
    ((i += 1))
  done 
}

startRpc(){
  i=$((totalValidator + 1))
  while [[ $i -le $totalNodes ]]; do
    

    if tmux has-session -t node$i > /dev/null 2>&1; then
        :
    else
        tmux new-session -d -s node$i
        tmux send-keys -t node$i " ./node_src/build/bin/geth --datadir ./chaindata/node$i --networkid $CHAINID --ws --ws.addr 0.0.0.0 --ws.origins '*' --ws.port 8545 --http --http.port 80 --rpc.txfeecap 0  --http.corsdomain '*' --nat 'any' --http.api db,eth,net,web3,personal,txpool,miner,debug --http.addr 0.0.0.0 --http.vhosts=$VHOST --vmdebug --pprof --pprof.port 6060 --pprof.addr 0.0.0.0 --syncmode full --gcmode=archive  --ipcpath './chaindata/node$i/geth.ipc' console" Enter
       
    fi


    ((i += 1))
  done 
}

startValidator(){
  i=1
  j=68
  while [[ $i -le $totalValidator ]]; do
  
    if tmux has-session -t node$i > /dev/null 2>&1; then
        :
    else
        tmux new-session -d -s node$i
        tmux send-keys -t 0 "./node_src/build/bin/geth --datadir ./chaindata/node$i --networkid $CHAINID --bootnodes $BOOTNODE --mine --port 326$j --unlock 0 --password ./chaindata/node$i/pass.txt --syncmode=full console" Enter
    fi

    ((i += 1))
    ((j += 1))
  done 
}


finalize(){
  welcome
  countNodes
  if [ "$isRPC" = true ]; then
    echo -e "\n${GREEN}+------------------- Starting RPC -------------------+"
    startRpc
  fi

  if [ "$isValidator" = true ]; then
    echo -e "\n${GREEN}+------------------- Starting Validator -------------------+"
    startValidator
  fi

  echo -e "\n${GREEN}+------------------ Active Nodes -------------------+"
  tmux ls
  echo -e "\n${GREEN}+------------------ Active Nodes -------------------+${NC}"
}


# Default variable values
verbose_mode=false
output_file=""

# Function to display script usage
usage() {
  echo -e "\nUsage: $0 [OPTIONS]"
  echo "Options:"
  echo -e "\t\t -h, --help      Display this help message"
  echo -e " \t\t -v, --verbose   Enable verbose mode"
  echo -e "\t\t --rpc       Start all the RPC nodes installed"
  echo -e "\t\t --validator       Start all the Validator nodes installed"
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
    --rpc)
        isRPC=true
      ;;

    # take validator count
    --validator)
        isValidator=true
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