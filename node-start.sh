#!/bin/bash
#set -x

set -e


GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color
CHAINID=3637
BOOTNODE="enr:-KO4QB2chuMADByTEEza_hjCLaYylB_enmn9EXrFpJaRMWu2Y-6W-6SH0Q4O9ZJ6H5Pf0LDEQki7yVvS9E5z3MLCCEKGAYkDYLIhg2V0aMfGhGVdgGKAgmlkgnY0gmlwhAOQXQiJc2VjcDI1NmsxoQNv_zUrRF6Gje1ULychIMLKBbrst9-CTzXYf8AlBH6_6IRzbmFwwIN0Y3CCf5yDdWRwgn-c"

echo -e "${GREEN}**********************************************************************"
echo -e "Starting node"


    if tmux has-session -t 0 > /dev/null 2>&1; then
        :
    else
        tmux new-session -d -s 0
        tmux send-keys -t 0 "./node_src/build/bin/geth --datadir ./chaindata/node1 --networkid $CHAINID --bootnodes $BOOTNODE --mine --unlock 0 --password ./chaindata/node1/pass.txt --syncmode=full console" Enter
    fi

echo -e "${ORANGE}Node started\nEnter ${GREEN}tmux attach -t 0 ${ORANGE}to see node in action${NC}"
echo -e "\n${ORANGE}Now give your tmux-geth instance sometime to sync till the recent block. Once it's done you can go to staking page and activate your validator by staking"
echo -e "\n${ORANGE}Remember to import the account's key store file into you metmask for staking.${NC}"
echo -e "\n${GREEN}**********************************************************************"