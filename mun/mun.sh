#!/bin/bash
echo -e "\033[0;35m"
echo " ________      _________                  _________       _________";
echo " ____  _/____________  /________________________  /____   ______  /_";
echo "  __  / __  __ \  __  /_  __ \_  __ \  __ \  __  /_  _ \  _  __  /_  _ \_ | / /";
echo " __/ /  _  / / / /_/ / / /_/ /  / / / /_/ / /_/ / /  __/__/ /_/ / /  __/_ |/ /";
echo " /___/  /_/ /_/\__,_/  \____//_/ /_/\____/\__,_/  \___/_(_)__,_/  \___/_____/ ";
echo "______________________________________________________________________________";
echo " ==============================================================================";
echo -e '\e[36mWebsite:\e[39m' https://indonode.dev/
echo -e '\e[36mGithub:\e[39m'  https://github.com/elangrr
echo -e "\e[0m"

sleep 2

# set vars
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export MUN_CHAIN_ID=testmun" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$MUN_CHAIN_ID\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

# install go
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

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/munblockchain/mun
cd mun
sudo rm -rf ~/.mun
go mod tidy
make install
sleep 10
mkdir -p ~/.mun/upgrade_manager/upgrades
mkdir -p ~/.mun/upgrade_manager/genesis/bin
cp $(which mund) ~/.mun/upgrade_manager/genesis/bin
sudo cp $(which mund-manager) /usr/bin

# config
mund config chain-id $MUN_CHAIN_ID
mund config keyring-backend test

# init
mund init $NODENAME --chain-id $MUN_CHAIN_ID

# download genesis and addrbook
curl --tlsv1 https://node1.mun.money/genesis? | jq ".result.genesis" > ~/.mun/config/genesis.json

# set peers and seeds
SEEDS="b4eeaf7ca17e5186b181885714cedc6a78d20c9b@167.99.6.48:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mun/config/config.toml
sed -i 's/stake/utmun/g' ~/.mun/config/genesis.json

# reset data
mund tendermint unsafe-reset-all --home $HOME/.mun


echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/mund.service > /dev/null <<EOF
[Unit]
Description=mund
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mund) start --home $HOME/.mun
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable lambdavm
sudo systemctl restart lambdavm

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u mund -f -o cat\e[0m'
