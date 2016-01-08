#!/bin/bash

if [ $(echo "$1 >= 1" | bc) -eq 1 ]; then
  echo 'asdf'"$2"'asdf'
elif [ $(echo "$1 < 1" | bc) -eq 1 ]; then
  echo "nonono"
fi
