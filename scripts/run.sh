#!/bin/sh

if [ ! -d ./wls ]; then
	mkdir ./wls
fi

if [ ! "$(docker ps -a | tail -c 10)" = "tackle" ]; then
	# check for user defined ports
	if [ $# -eq 0 ]; then
		portA=20001
		portB=28090
	elif [ $# -eq 1 ]; then
		portA=$1
	elif [ $# -eq 2 ]; then
		portA=$1
		portB=$2
	fi

	# run docker
	loc="$(readlink -f wls)"
	docker container run -itd \
		-v "${loc}":/home/witness/.wls/ \
		-p "$portA":2001 -p "$portB":8090 \
		--name tackle \
		jrswab/tackle:latest
fi

# open docker container and set detach keys
docker attach --detach-keys="ctrl-h" tackle
