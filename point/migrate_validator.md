<p style="font-size:14px" align="right">
<a href="https://discord.gg/xWhjMdJu" target="_blank">Join our discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
<a href="https://indonode.dev/" target="_blank">Visit my website <img src="https://avatars.githubusercontent.com/u/34649601?v=4" width="30"/></a>
  <a href="https://discord.gg/WRfwvPrG" target="_blank">Join Point discord <img src="https://user-images.githubusercontent.com/50621007/176236430-53b0f4de-41ff-41f7-92a1-4233890a90c8.png" width="30"/></a>
</p>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/38981255/185550018-bf5220fa-7858-4353-905c-9bbd5b256c30.jpg">
</p>

# Migrate your validator to another machine

### 1. Run a new full node on a new machine
To setup full node you can follow my guide [point node setup for testnet](https://github.com/elangrr/testnet_manuals/edit/main/point/README.md)

### 2. Confirm that you have the recovery seed phrase information for the active key running on the old machine

#### To backup your key
```
evmosd keys export mykey
```
> _This prints the private key that you can then paste into the file `mykey.backup`_

#### To get list of keys
```
evmosd keys list
```

### 3. Recover the active key of the old machine on the new machine

#### This can be done with the mnemonics
```
evmosd keys add mykey --recover
```

#### Or with the backup file `mykey.backup` from the previous step
```
evmosd keys import mykey mykey.backup
```

### 4. Wait for the new full node on the new machine to finish catching-up

#### To check synchronization status
```
evmosd status 2>&1 | jq .SyncInfo
```
> _`catching_up` should be equal to `false`_

### 5. After the new node has caught-up, stop the validator node

> _To prevent double signing, you should stop the validator node before stopping the new full node to ensure the new node is at a greater block height than the validator node_
> _If the new node is behind the old validator node, then you may double-sign blocks_

#### Stop and disable service on OLD MACHINE
```
sudo systemctl stop evmosd
sudo systemctl disable evmosd
```
> _The validator should start missing blocks at this point_

### 6. Stop service on NEW MACHINE
```
sudo systemctl stop evmosd
```

### 7. Move the validator's private key from the OLD MACHINE to the NEW MACHINE
#### Private key is located in: `~/.evmosd/config/priv_validator_key.json`

> _After being copied, the key `priv_validator_key.json` should then be removed from the old node's config directory to prevent double-signing if the node were to start back up_
```
sudo mv ~/.evmosd/config/priv_validator_key.json ~/.evmosd/bak_priv_validator_key.json
```

### 8. Start service on a new validator node
```
sudo systemctl start evmosd
```
> _The new node should start signing blocks once caught-up_

### 9. Make sure your validator is not jailed
#### To unjail your validator
```
evmosd tx slashing unjail --chain-id $POINT_CHAIN_ID --from mykey --gas=auto -y
```

### 10. After you ensure your validator is producing blocks and is healthy you can shut down old validator server

# Note : your wallet name will change to mykey on new machine
