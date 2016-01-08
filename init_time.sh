#!/bin/bash

# $1: topology $2: mac

if [ $2 = "bird" ]; then
if [ $1 = 2 ]; then
  echo 23046040
elif [ $1 = 3 ]; then
  echo 31618672
elif [ $1 = 5 ]; then
  echo 51009160
elif [ $1 = 8 ]; then
  echo 86930952
elif [ $1 = 10 ]; then
  echo 115595520
else
  echo "wrong topology"
fi
fi

if [ $2 = "LPP" ] || [ $2 = "CX" ]; then
if [ $1 = 2 ]; then
  echo 4200000
elif [ $1 = 3 ]; then
  echo 5250000
elif [ $1 = 5 ]; then
  echo 7350000
elif [ $1 = 8 ]; then
  echo 10500000
elif [ $1 = 10 ]; then
  echo 12600000
else
  echo "wrong topology"
fi
fi
