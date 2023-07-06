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



displayStatus(){
  # start the node
  echo -e "\n${GREEN}All the existing node installation and corresponding data has been deleted "
}

task1(){
  # update and upgrade the server TASK 1
  echo -e "\n\n${ORANGE}TASK: ${RED}[FORMATTING INSTALLATION]${NC}\n"
  echo -e "Are you sure want to continue and completly format & delte all the existing node installations? (Y/N)"
  read input
  
  if [ [$input == 'y'] ]; then
        echo "${RED} Format in progress..."
        cd ./chaindata
        rm -rf ./*
        cd ../tmp
        rm -rf ./*
        cd ../
        displayStatus
  fi
  echo -e "\n${GREEN}[TASK PASSED]${NC}\n"
}

displayWelcome(){
  # display welcome message
  echo -e "\n\n\t${ORANGE}Total RPC to be created: $totalRpc"
  echo -e "\t${ORANGE}Total Validators to be created: $totalValidator"
  echo -e "\t${ORANGE}Total nodes to be created: $totalNodes"
  echo -e "\n\n${RED}
  \t+------------------------------------------------+
  \t|   PAY ATTENTION !
  \t|   Running this tool will delete all exixting node installation and corresponding data
  \t|   Remember to backup any data that you need before running this
  \t+------------------------------------------------+
  ${NC}\n"

  echo -e "${ORANGE}
  \t+------------------------------------------------+
  \t+------------------------------------------------+
  ${NC}"
}


#########################################################################

#+-----------------------------------------------------------------------------------------------+
#|                                                                                                                             |
#|                                                                                                                             |
#|                                                      MAIN                                                            |
#|                                                                                                                             |
#|                                                                                                                             |
#+-----------------------------------------------------------------------------------------------+

displayWelcome
task1