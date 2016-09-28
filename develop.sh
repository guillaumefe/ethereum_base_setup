#!/bin/bash

#variables

num="$1"
port="$2"
net="$3"

if [ -z "$1" ]; then
   num=4;
fi

if [ -z "$2" ]; then
   port=1234;
fi

if [ -z "$3" ]; then
   net=0;
fi

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

for ((i=$num; i>=0; i--))
do
    sudo geth --datadir ./noeud$i --networkid "$net" --unlock 0 --password init bloc.json
    sudo geth --datadir ./noeud$i --networkid="$net" --unlock 0 --password iaccount new
    sudo geth --datadir ./noeud$i --networkid="$net" --port=$((port+i)) console &
    echo "Lauching geth console on "$((port+i))
done


#geth --unlock <YOUR_ACCOUNT_ADDRESS> --password <YOUR_PASSWORD>

wait
echo "All complete"
wait
echo "Type 'geth console'"



