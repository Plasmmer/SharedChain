#!/bin/bash -e

nm="CommonChain"
vs="r1"
commonchainversion="""
        \e[1;42m $nm \e[0m\e[100m version $vs \e[0m
        \e[100m Created in 10-21-2021 by Daniella Mesquita \e[0m
"""

lastblock=$(find -maxdepth 1 -name '*.json' | sort -t_ -nk2,2 | tail -n1)
prevblock="This feature isn't available yet."

if [ "$1" = "" ]; then
   echo "$commonchainversion"
   echo "Type 'commonchain --help' (without quotes) to see a list of available commands."
fi

if [ "$1" = "latest" ]; then
   echo "Latest block is:"
   echo "$lastblock"
   if [ "$2" = "validate" ]; then
      echo "This feature isn't available yet."
fi
fi

if [ "$1" = "previous" ]; then
   echo "Previous block is:"
   echo "$prevblock"
fi