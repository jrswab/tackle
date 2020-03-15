#!/bin/bash

if [ $# -eq 0 ]; then
	nano .wls/witness_node_data_dir/config.ini
else
	$1 .wls/witness_node_data_dir/config.ini
fi

