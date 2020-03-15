#!/bin/bash
SV="0.4.0"
WV="0.2.7"

# Move into smoke directory
cd ~/.wls || exit

# Make sure the witness is disabled
echo "Did you remember to disable your witness via wallet.sh? (y|n)"
read -r disabled
if [ "$disabled" != "y" ]; then
    echo "Exiting without upgrade."
    exit
fi

# download smoked and wallet
wget https://gitlab.com/beyondbitcoin/whaleshares-chain/uploads/36dcb4e8dd1ce5d354769e86103c1a5b/whaled_lm-0.4.0-x86_64-linux.tar.gz
wget https://gitlab.com/beyondbitcoin/whaleshares-chain/uploads/8e60071a182075da23683c1247d2f153/cli_wallet-0.2.7-x86_64-linux.tar.gz
	
# extract smoked and wallet
tar -xzf whaled_lm-${SV}-x86_64-linux.tar.gz
tar -xzf cli_wallet-${WV}-x86_64-linux.tar.gz

# remove tar files
rm *.gz

# wait two seconds
sleep 2

# Tell user update is complete
echo "Whaled and CLI Wallet are now up to date"

# Move back to home directory
cd || exit

exit
