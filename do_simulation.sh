#!/bin/bash

source var_config.cfg

./param_$mac.sh
./script.sh
./set_checkrate.sh

java -mx512m -jar ../$mac/tools/cooja/dist/cooja.jar -nogui="simulation.csc" -contiki="../$mac"
