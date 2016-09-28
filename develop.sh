#!/bin/bash

#sudo apt-get update &&
#    apt-get install -y software-properties-common
#    apt-apt-repository -y ppp:etherum/ethereum ;

#add-apt-repository -y ppa:ethereum/ethereum-dev
#sudo apt-get update;

#apt-get install -y ethereum solc

#Get first bloc content
bloc=$(cat ./bloc.json);

#works on Debian 8
#cd /etc/apt/source.d/
#Error catching @n1c0

#todo
sudo geth --datadir ./noeud1 --networkid "3" --unlock 0 --password init bloc.json | grep "Listening, enode:"
 sudo geth --datadir ./noeud1 --networkid="3" --unlock 0 --password iaccount new | grep "Listening, enode:"
 sudo geth --datadir ./noeud2 --networkid "3" --unlock 0 --password iinit bloc.json | grep "Listening, enode:"
 sudo geth --datadir ./noeud2 --networkid="3" --unlock 0 --password iaccount new | grep "Listening, enode:"
 sudo geth --datadir ./noeud3 --networkid "3" --unlock 0 --password init bloc.json | grep "Listening, enode:"
 sudo geth --datadir ./noeud3 --networkid "3" --unlock 0 --password init bloc.json | grep "Listening, enode:"
 sudo geth --datadir ./noeud4 --networkid="3" --unlock 0 --password account new | grep "Listening, enode:"
 sudo geth --datadir ./noeud4 --networkid="3" --unlock 0 --password account new | grep "Listening, enode:"
#-->todo

 sudo geth --datadir ./noeud1 --networkid="3" --port="1234" console &
 sudo geth --datadir ./noeud2 --networkid="3" --port="1234" console &
 sudo geth --datadir ./noeud3 --networkid="3" --port="1234" console &
 sudo geth --datadir ./noeud4 --networkid="3" --port="1234" console &

#geth --unlock <YOUR_ACCOUNT_ADDRESS> --password <YOUR_PASSWORD>

wait
echo "All complete"
wait
echo "Type 'geth console'"



