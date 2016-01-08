#!/bin/bash

source var_config.cfg

if [ $(echo "$check_rate < 1" | bc) -eq 1 ]; then
	./set_checkrate_$mac.sh "*"
elif [ $(echo "$check_rate >= 1" | bc) -eq 1 ]; then
	./set_checkrate_$mac.sh "/"
else
	echo "setting checkrate error"
fi
