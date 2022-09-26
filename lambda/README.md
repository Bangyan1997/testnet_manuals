</p>
<p style="font-size:14px" align="right">
<a href="https://discord.gg/T5ndpGtXw8" target="_blank">Join Lambda Network Discord<img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
</p>

<p style="font-size:14px" align="right">
<a href="https://github.com/elangrr/testnet_manuals" target="_blank">More Guide Tutorials<img src="https://avatars.githubusercontent.com/u/34649601?v=4" width="30"/></a>
</p>

<p style="font-size:14px" align="right">
<a href="https://indonode.dev/" target="_blank">Visit my website <img src="https://avatars.githubusercontent.com/u/34649601?v=4" width="30"/></a>
</p>

<p align="center">
  <img height="150" height="auto" src="https://docs.lambda.im/lambda-logo.png">
</p>

# Lambda Network Testnet

## [Official Guide](https://docs.lambda.im/validators/overview.html)
## [Visit Lambda](https://www.lambda.im/)


## Minimum Requirements
 - 4 or more physical CPU cores
 - At least 500GB of SSD disk storage
 - At least 32GB of memory (RAM)
 - At least 100mbps network bandwidth

## Setting up vars
Here you have to put name of your moniker (validator) that will be visible in explorer
```
NODENAME=<YOUR_MONIKER>
```
Change : `<YOUR_MONIKER>` To your node moniker whatever u like


Save and import variables into system
```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export LAMBDA_CHAIN_ID=lambdatest_92001-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Update packages
```
sudo apt update && sudo apt upgrade -y
```

## Install dependencies
```
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```

## Install go
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```

## Download and build binaries
```
git clone https://github.com/LambdaIM/lambdavm.git
cd lambdavm
make build
cd build
sudo cp $HOME/lambdavm/build/lambdavm /usr/local/bin
```

## Config app
```
lambdavm config chain-id $LAMBDA_CHAIN_ID
lambdavm config keyring-backend file
```

## Init app
```
lambdavm init $NODENAME --chain-id $LAMBDA_CHAIN_ID
```

## Download genesis
```
wget https://raw.githubusercontent.com/LambdaIM/testnets/main/lambdatest_92001-1/genesis.json
mv genesis.json ~/.lambdavm/config/
```

## Set seeds and peers
```
SEEDS="6cf8b733252f6d9590010abe6f1dfbb9620f60f0@18.143.13.243:26656"
PEERS="6cf8b733252f6d9590010abe6f1dfbb9620f60f0@18.143.13.243:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.lambdavm/config/config.toml
```

## Set minimum gas price and timeout commit
```
sed -i -e "s/^timeout_commit *=.*/timeout_commit = \"2s\"/" $HOME/.lambdavm/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0001ulamb\"/" $HOME/.lambdavm/config/app.toml
```

## Create Service
```
sudo tee /etc/systemd/system/lambdavm.service > /dev/null <<EOF
[Unit]
Description=lambdavm
After=network-online.target

[Service]
User=$USER
ExecStart=$(which lambdavm) start --home $HOME/.lambdavm
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Register and start service
```
sudo systemctl daemon-reload
sudo systemctl enable lambdavm
sudo systemctl restart lambdavm && sudo journalctl -u lambdavm -f -o cat
```

## After install please Load Variable! (Post Installation)
```
source $HOME/.bash_profile
```

### Check info Sync
Note : You have to synced to the lastest block , check the sync status with this command
```
lambdavm status 2>&1 | jq .SyncInfo
```

## Create Wallet
Create validator wallet using this command, Dont forget to save the Mnemonic! 

`NOTE : it is recommended to use wallet you fill in the form`
```
lambdavm keys add $WALLET
```
(OPTIONAL) To recover using your previous saved wallet
```
lambdavm keys add $WALLET --recover
```
To get current list of wallet
```
lambdavm keys list --keyring-backend file
```
To get private key of validator wallet (SAVE IT SOMEWHERE SAFE!)
```
lambdavm keys unsafe-export-eth-key wallet
```
## Safe wallet Info
```
LAMBDA_WALLET_ADDRESS=$(lambdavm keys show $WALLET -a)
LAMBDA_VALOPER_ADDRESS=$(lambdavm keys show $WALLET --bech val -a)
echo 'export LAMBDA_WALLET_ADDRESS='${LAMBDA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export LAMBDA_VALOPER_ADDRESS='${LAMBDA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Create Validator
Before creating validator please make sure you have the funds already in your wallet
To check wallet balance :
```
lambdavm query bank balances $LAMBDA_WALLET_ADDRESS
```
To create a validator with 1 LAMB delegation use this command below :

```
lambdavm tx staking create-validator \
  --amount=1000000000000000000ulamb \
  --pubkey=$(lamdavm tendermint show-validator) \
  --moniker=$NODENAME \
  --chain-id=$LAMBDA_CHAIN_ID \
  --commission-rate="0.05" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --gas="300000" \
  --gas-prices="0.025ulamb" \
  --from=$WALLET \
  --broadcast-mode block
```

## ETC
To unjail your validator use this command
```
lambdavm tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$LAMBDA_CHAIN_ID \
  --fees=5000ulamb \
  --gas=500000
```
## Monitoring your validator

Check TX HASH ( Which <txhash> is your txhash from the transaction
```
lambdavm query tx <txhash>
```
If the transaction was correct you should instantly become part of the validators set. Check your pubkey first:
```
lambdavm tendermint show-validator
```
You will see a key there, you can identify your node among other validators using that key:
```
lambdavm query tendermint-validator-set
```

## Useful Commands
Check Logs
```
journalctl -fu lambdavm -o cat
```
Start Service
```
sudo systemctl start lambdavm
```
Stop Service
```
sudo systemctl stop lambdavm
```
Restart Service
```
sudo systemctl restart lambdavm
```
## Node Info
Synchronization info
```
lambdavm status 2>&1 | jq .SyncInfo
```
Validator Info
```
lambdavm status 2>&1 | jq .ValidatorInfo
```
Node Info
```
lambdavm status 2>&1 | jq .NodeInfo
```
  


## Delete Node Permanently (Backup your Private key first if you wanna migrate !!)
```
sudo systemctl stop lambdavm
sudo systemctl disable lambdavm
sudo rm /etc/systemd/system/lambdavm* -rf
sudo rm $(which lambdavm) -rf
sudo rm $HOME/.lambdavm -rf
sudo rm $HOME/lambdavm -rf
sed -i '/lambdavm_/d' ~/.bash_profile
```





