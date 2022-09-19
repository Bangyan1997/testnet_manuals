</p>
<p style="font-size:14px" align="right">
<a href="https://discord.gg/V5pq8AMRHS" target="_blank">Join Aleo Discord<img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
</p>

<p style="font-size:14px" align="right">
<a href="https://github.com/elangrr/testnet_manuals" target="_blank">More Guide Tutorials<img src="https://avatars.githubusercontent.com/u/34649601?v=4" width="30"/></a>
</p>

<p style="font-size:14px" align="right">
<a href="https://indonode.dev/" target="_blank">Visit my website <img src="https://avatars.githubusercontent.com/u/34649601?v=4" width="30"/></a>
</p>

<p align="center">
  <img height="300" height="auto" src="https://camo.githubusercontent.com/973307a6c53e7088805c6fabbde538c8242f5ce8bbd4b0937b176b4e6df87b69/68747470733a2f2f63646e2e616c656f2e6f72672f736e61726b6f732f62616e6e65722e706e67">
</p>

# Aleo SnarkOS Client Node Setup Guide ( Prover Soon after released )
## Overview
snarkOS is a decentralized operating system for private applications. It forms the backbone of Aleo and enables applications to verify and store state in a publicly verifiable manner.

## [Official Guide](https://github.com/AleoHQ/snarkOS#3a-run-an-aleo-client-node)

## Minimum Requirements
The following are minimum requirements to run an Aleo node:

- CPU: 16-cores (32-cores preferred)
- RAM: 16GB of memory (32GB preferred)
- Storage: 128GB of disk space
- Network: 50 Mbps of upload and download bandwidth

Please note to run an Aleo proving node that is competitive, the machine will require more than these requirements.

## Pre-Installation
Grant yourself a super user access and open port
```
sudo su
sudo ufw enable -y 
sudo ufw allow 4130
sudo ufw allow 4180
```
`NOTE : Azure User use Azure panel to open the firewall not inside the vps!!`

## Installation
Use command below to install SnarkOS Client Node in a minutes
```
wget -q -O aleo_snarkos3.sh https://raw.githubusercontent.com/elangrr/testnet_manuals/main/aleo/aleo_snarkos3.sh && chmod +x aleo_snarkos3.sh && sudo /bin/bash aleo_snarkos3.sh
```
## Post Installation
Load the variable into the profile
```
source $HOME/.bash_profile
```
## Useful Commands
Check Logs
```
journalctl -u aleod -f -o cat 
```
Restart Client Node
```
systemctl restart aleod
```
Stop Client Node
```
systemctl stop aleod
````

## Remove Client Node
MAKE SURE YOU RUN THIS AS `root` !!
```
wget -q -O aleo_remove_snarkos2.sh https://raw.githubusercontent.com/elangrr/testnet_manuals/main/aleo/aleo_remove_snarkos2.sh && chmod +x aleo_remove_snarkos2.sh && sudo /bin/bash aleo_remove_snarkos2.sh
```

## Final words
Then you are already set for Aleo Client Node.

For Prover node it will be released soon and after that I will make guide on how to run Aleo Prover, For now stay active in the Aleo Discord and wait for next announcement.

