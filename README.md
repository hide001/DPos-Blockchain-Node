# DPos-Blockchain-Node based on geth
A DPos blockchain node based on geth and inherited from heco-chain's geth implementation. The full blockchain infrastructure consists of physical nodes and system smart contracts. 
A node is used to validate transactions and produce new blocks. And the smart contracts are used to register block finality and create consensus among all the nodes. These system contracts are also responsible for rewarding nodes for their work, activating & deactivating a given node..etc. The consensus followed is determined by the logic dictated in the system contract. 

The idea behind this project is to encourage the use of blockchain infrastructure in the organizational structure of various institutions. Apart from that, this project is propelled by curiosity and a learning temper. The final goal of this project would be to create a plethora of tools with which one can build a full-fledged blockchain infrastructure with various sorts of applications.

Currently, the installation and setup process requires a lot of manual interaction. My first goal is to eliminate machine-doable manual tasks and streamline the whole experience. 




This directory contains node source code, node setup and startup script. 

In order to become a validator in DPos Mainnet you first need to setup and start node:

--------------------- NODE SETUP -------------------------------------------------------
1. Open terminal where DPos_mainnet_package.tar.gz is located
2. Enter tar xzf ./DPos_mainnet_package.tar.gz
3. rm -rf ./DPos_mainnet_package && cd ./DPos_mainnet_package
4. Enter chmod a+x ./node-setup.sh
5. ./node-setup.sh
6. Now follow along the program, read instruction there care fully
7. Once node is setup you can start node
------------------------------------------------------------------------------------------


---------------------- NODE START -------------------------------------------------------
1.  ./node-start.sh

To attach running tmux session: tmux attach -t 0 
To dettach running tmux session: press CTRL + b , then release both keys and press d
To exit node once inside tmux session: type "exit" and enter

----------------------------------------------------------------------------------------

Once you have setup the node and started it, you need to import your wallet from node server(as instructed in setup/startup scripts), fund it with appropriate required funds then go to <staking url> and click "Become a validator" by following instructions there.

Please note: Note setup is only required for first time. i.e, when you have a new server with no prior running DPos nodes. Once the setup.sh is done on a given server then no need to interact with ./node-setup.sh file. You can safely interact with ./node-start.sh script even after 1st time.