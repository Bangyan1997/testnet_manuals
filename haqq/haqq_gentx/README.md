</p>
<p style="font-size:14px" align="right">
<a href="https://discord.gg/n5exFdFPkK" target="_blank">Join Islamic Coin Discord<img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
</p>

<p style="font-size:14px" align="right">
<a href="https://github.com/elangrr/testnet_manuals" target="_blank">More Guide Tutorials<img src="https://avatars.githubusercontent.com/u/34649601?v=4" width="30"/></a>
</p>

<p style="font-size:14px" align="right">
<a href="https://indonode.dev/" target="_blank">Visit my website <img src="https://avatars.githubusercontent.com/u/34649601?v=4" width="30"/></a>
</p>

</p>
<p style="font-size:14px" align="right">
<a href="https://discord.gg/gru6MuGPgP" target="_blank">Join NodeX Capital Network Discord<img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
</p>

![haqq](https://user-images.githubusercontent.com/104348282/188024190-b43f56d0-2dc6-4e4a-be0e-a7e9f615f751.png)

## Preparation for Haqq Incentivized Testnet
### PLEASE USE NEW MACHINE SINCE THE CHAIN ID IS DIFFERENT IF YOU WISH TO USE SAME MACHINE ITS UP TO YOU!!
### RECOMMENDED USING DIFFERENT WALLET THAN THE VALIDATOR WALLET!!

### Update Package and Install depencies
```
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### Install Go 1.18.3 ( One Command )
```
ver="1.18.3"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
  ```
### Install Binary (One Command)
```
cd $HOME && git clone https://github.com/haqq-network/haqq && \
cd haqq && \
make install && \
haqqd version
```

### Init Moniker and Chain Id
```
haqqd init <YOURMONIKER> --chain-id haqq_54211-2 && \
haqqd config chain-id haqq_54211-2
```
Change `<YOURMONIKER>` To moniker you desire

### Create wallet
```
haqqd keys add wallet
```

### Add Genesis Account
```
haqqd add-genesis-account wallet 10000000000000000000aISLM
```

### Create Gentx (One Command)
```
haqqd gentx YOURWALLETNAME 10000000000000000000aISLM \
--chain-id=haqq_54211-2 \
--moniker="<YOURMONIKER>" \
--commission-max-change-rate 0.05 \
--commission-max-rate 0.20 \
--commission-rate 0.05 \
--website="" \
--security-contact="" \
--identity="" \
--details=""
```

After Submit command you will have Gentx on `/.haqqd/config/gentx/gentx-xxx.json`

# Submit PR 
1. Copy the Content on `/.haqqd/config/gentx/gentx-xxx.json`
2. Go to [Validator-Contest Github](https://github.com/haqq-network/validators-contest) and Fork the Repository
3. After fork Create new file under `gentx` folder on forked repo with name `gentx-<moniker>.json` and paste the Copied test into the file
4. Create a Pull Request to the main branch of the repository

# Register to Crew3
1. Go to [Crew3 Haqq](https://haqq-val-contest.crew3.xyz/)
2. Login with Discord Account
3. Submit Gentx PR Link in the quest

## DONT FORGET TO BACKUP MNEMONICS!!
## Wait for Further Instructions
