#!/bin/bash

function _setupDeb() {
    sudo apt-get install software-properties-common
    sudo add-apt-repository -y ppa:ethereum/ethereum
    sudo add-apt-repository -y ppa:ethereum/ethereum-dev
    sudo apt-get update
    sudo apt-get install ethereum
}

function _createAcc() {
    geth account new
}

function _createGen() {

    genfile="genesis.json"

    while [[ -z "$nounce" ]] ; do
        read -e -p "Specifify the nounce [0]: " nounce
        nounce=${nounce:-0}
    done
    while [[ -z $difficulty ]] ; do
        read -e -p "Specifify the difficulty[0x20000]: " difficulty
        difficulty=${difficulty:-0x20000}
    done
    while [[ -z $mixhash ]] ; do
        read -e -p "Specifify the mixhash[0x00000000000000000000000000000000000000647572616c65787365646c6578]: " mixhash
        mixhash=${mixhash:-0x00000000000000000000000000000000000000647572616c65787365646c6578}
    done
    while [[ -z $coinbase ]] ; do
        read -e -p "Specifify the coinbase[0x0000000000000000000000000000000000000000]: " coinbase 
        coinbase=${coinbase:-0x0000000000000000000000000000000000000000}
    done
    while [[ -z $timestamp ]] ; do
        read -e -p "Specifify the timestamp[0x00]: " timestamp
        timestamp=${timestamp:-0x00}
    done
    while [[ -z $parentHash ]] ; do
        read -e -p "Specifify the parentHash[0x0000000000000000000000000000000000000000000000000000000000000000]: " parentHash
        parentHash=${parentHash:-0x0000000000000000000000000000000000000000000000000000000000000000}
    done
    while [[ -z $extraData ]] ; do
        read -e -p "Specifify the extraData[0x]: " extraData
        extraData=${extraData:-0x}
    done
    while [[ -z $gasLimit ]] ; do
        read -e -p "Specifify the gasLimit[0x2FEFD8]: " gasLimit
        gasLimit=${gasLimit:-0x2FEFD8}
    done

    touch $genfile

    echo '{
    "nounce": "'$nounce'",
    "difficulty": "'$difficulty'",
    "mixhash": "'$mixhash'",
    "coinbase": "'$coinbase'",
    "timestamp": "'$timestamp'",
    "parentHash": "'$parentHash'",
    "extraData": "'$extraData'",
    "gasLimit": "'$gasLimit'"
    }' > $genfile

    unset nounce
    unset difficulty
    unset mixhash
    unset timestamp
    unset parentHash
    unset extraData
    unset gasLimit
    unset genfile
}

function _createChain() {

    while [[ ! -f $genesis ]] ; do
        read -e -p "Specifify the genesis.json location: " genesis
    done

    read -p "Specifiy a name for the folder that will contain your chain: " chain
    [[ -d $chain ]] && echo "Folder exists" || (sudo mkdir $chain && echo "Folder $chain has been created")

    sudo geth --datadir $chain init $genesis

    unset genesis
    unset chain

}

function _exportBk() {
    
            while [[ -z $bkfile ]] ; do
                read -e -p "Specifify a file name: " bkfile
            done
            sudo geth export $bkfile
            unset bkfile
}

function _attachCons() {
    while [[ -z $protocol ]] ; do
        read -e -p "Specifify the protocol to use [ipc|http|ws default:ipc]: " protocol
        protocol=${protocol:-ipc}

            case "$protocol" in
                ipc)
                    while [[ -z $host ]] ; do
                        read -e -p "Specifify the host: " host
                    done
                    sudo geth attach $protocol://$(realpath $host)/geth.ipc
                    ;;
                http)
                    while [[ -z $host ]] ; do
                        read -e -p "Specifify the host: " host
                    done
                    while [[ -z $port ]] ; do
                        read -p "Specifify the port: " port
                    done
                    sudo geth attach $protocol://$host:$port
                    ;;
                ws)
                    while [[ -z $host ]] ; do
                        read -e -p "Specifify the host: " host
                    done
                    while [[ -z $port ]] ; do
                        read -p "Specifify the port: " port
                    done
                    sudo geth attach $protocol://$host:$port
                    ;;
                *)
                    echo $"Usage: $0 {ipc|http|ws}"
                    ;;

                esac
    done

    unset protocol
    unset host
    unset port
}

function _createNode() {

    while [[ -z $(echo $node | grep "^-\?[0-9]*$") ]] ; do
        read -e -p "How many node(s) do you wish to start[4]? " node
        node=${node:-4}
    done

    while [[ -z $(echo $port | grep "^-\?[0-9]*$") ]] ; do
        read -e -p "At what port should be located the first node [30301]?  " port
        port=${port:-30301}
    done

    while [[ -z $(echo $rpcport | grep "^-\?[0-9]*$") ]] ; do
        read -e -p "At what RPC port should be located the first node [8101]?  " rpcport
        rpcport=${rpcport:-8101}
    done

    for ((i=1; i<=$node; i++))
    do
        sudo geth --networkid 100 --nodiscover --maxpeers 0 --rpc --rpcapi "db,eth,net,web3" --rpcport $rpcport --rpccorsdomain "*" --datadir="./node$i" -verbosity 6 --port $port --nat "none" --identity "node$i"  2>> /tmp/node$i.log&
        echo "Node $i created"
        echo "Node $i is listening at $port"
        echo "Logfile location : '/tmp/node$i.log'"
        echo "You can attach a console to : './node$i' (over IPC)"
        echo "############"
        ((port++))
        ((rpcport++))
    done

    unset node
    unset port
    unset rpcport


}

function mainMenu() {
PS3='Please enter your choice: '
options=(
"Setup for Debian" 
"Create nodes" 
"Attach a console to node" 
"Create a genesis file" 
"Create account" 
"Create a chain" 
"Export blockchain" 
"Quit")
#deactivate

select opt in "${options[@]}"
do
    case $opt in
        "Setup for Debian")
            _setupDeb
            ;;
        "Create nodes")
            _createNode
            ;;
        "Create account")
            _createAcc
            ;;
        "Create a genesis file")
            _createGen
            ;;
        "Create a chain")
            _createChain
            ;;
        "Attach a console to node")
            _attachCons
            ;;
        "Export blockchain")
            _exportBk
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
}

mainMenu;
