#!/bin/bash
echo -e "\033[0;35m"
echo " :::::::::    :::               :::::       ::::::       :::: ::::::::::::";
echo " :+:          :+:              ::   ::       :+:+:       :+:  :+:      :+:";
echo " +:+          +:+             :+      +:     +:+  ::     +:+  +:+      +:+";
echo " :#++:::++    ++#            ++###++++###    ##+   +#    +#+  #+#         ";
echo " +#+          +#+           +#           #+  +#+    #+   #+#  +#+  #+#+#++#";
echo " #+#          #+#          #+             +# #+#      +# +#+  #+#      #+#";
echo " #########    ##########  ##               #####       #####  ############";
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
echo "export HAQQ_CHAIN_ID=haqq_54211-2" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$POINT_CHAIN_ID\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# install go
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.3"
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
git clone https://github.com/haqq-network/haqq && cd haqq-network
make install

# init
haqqd init $NODENAME --chain-id $HAQQ_CHAIN_ID

#config
haqqd config chain-id $HAQQ_CHAIN_ID


echo '=============== SETUP FINISHED ==================='
