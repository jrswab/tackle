#!/bin/sh
SV="0.4.0"
WV="0.2.7"

# see if whaled exists
if [ ! -f "$HOME"/.wls/whaled ]; then 
	cd "$HOME"/.wls || exit 1

	printf "What do you wish to run?\n"
	printf "Please enter witness, rpc, or seed. (no capital letters)\n"
	read -r nodeType

	while true
	do
		case "$nodeType" in
			"rpc") printf "Installing RPC node... \n"
				wget https://gitlab.com/beyondbitcoin/whaleshares-chain/uploads/64e4471f93e270adb7b6c7a082802297/whaled-0.4.0-x86_64-linux.tar.gz 
				tar -xzf whaled-${SV}-x86_64-linux.tar.gz
				rm whaled-${SV}-x86_64-linux.tar.gz
				break;;

			"seed") printf "Installing Seed node... \n"
				wget https://gitlab.com/beyondbitcoin/whaleshares-chain/uploads/36dcb4e8dd1ce5d354769e86103c1a5b/whaled_lm-0.4.0-x86_64-linux.tar.gz
				tar -xzf whaled_lm-${SV}-x86_64-linux.tar.gz
				rm whaled_lm-${SV}-x86_64-linux.tar.gz
				break;;

			"witness") printf "Installing Witness... \n"
				wget https://gitlab.com/beyondbitcoin/whaleshares-chain/uploads/36dcb4e8dd1ce5d354769e86103c1a5b/whaled_lm-0.4.0-x86_64-linux.tar.gz
				tar -xzf whaled_lm-${SV}-x86_64-linux.tar.gz
				rm whaled_lm-${SV}-x86_64-linux.tar.gz
				break;;

			* ) printf "Please enter witness, rpc, or seed. (no capital letters)\n"
				read -r nodeType
		esac
	done

	# download and extract wallet
	wget https://gitlab.com/beyondbitcoin/whaleshares-chain/uploads/8e60071a182075da23683c1247d2f153/cli_wallet-0.2.7-x86_64-linux.tar.gz
	tar -xzf cli_wallet-${WV}-x86_64-linux.tar.gz
	rm cli_wallet-${WV}-x86_64-linux.tar.gz

	# Get and Export cert:
	wget https://curl.haxx.se/ca/cacert.pem
	export SSL_CERT_FILE="$HOME"/.wls/cacert.pem
	
	# wait two seconds
	printf "Starting Whaled to build directories...\n"
	sleep 2

	# Launch script in background
	"$HOME"/.wls/whaled &
	# Get its PID
	whaledPID=$!
	# Wait for 2 seconds
	sleep 2
	# Kill it
	kill -INT $whaledPID
	sleep 4

	# move preset configs
	cp "$HOME"/.config/config.ini witness_node_data_dir/config.ini

	# move to home dir
	cd || exit 1
fi

# run tmux with multiple window created.
session="Tackle | ctrl+h to leave | ctrl+b then a number to swich windows"

# set up tmux
tmux start-server

# create a new tmux session, starting vim from a saved session in the new window
tmux new-session -d -s "$session"

# create a new window called scratch
tmux new-window -t "$session":1 -n wallet

# return to main vim window
tmux select-window -t "$session":0

# Finished setup, attach to the tmux session!
tmux attach-session -t "$session"

exit
