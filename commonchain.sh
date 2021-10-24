#!/bin/bash -e

#nm="CommonChain"
#vs="r1"
commonchainversion="""
        \e[1;42m $nm \e[0m\e[100m version $vs \e[0m
        \e[100m Created in 10-21-2021 by Daniella Mesquita \e[0m
"""

lastblock=$(find -maxdepth 1 -name '*.json' | sort -t_ -nk2,2 | tail -n1)
prevblock="This feature isn't available yet."
#gitrepo=$(jq -r '.gitrepo' 0.json)
gitrepo="$(jq -r '.gitrepo' 0.json)"
#releasetag=$(curl --silent ""https://api.github.com/repos/\"$gitrepo\""/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
#releasetagnov=$(curl --silent ""https://api.github.com/repos/\"$gitrepo\""/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c 2-)

#releasetag="$(curl --silent "https://api.github.com/repos/\"$gitrepo\"/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
releasetag="$(
  curl --silent "https://api.github.com/repos/$gitrepo/releases/latest" \
  | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
)"
releasetagnov="$(
  curl --silent "https://api.github.com/repos/$gitrepo/releases/latest" \
  | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' \
  | cut -c 2-
)"

if [ "$1" = "" ]; then
   echo "$commonchainversion"
   echo "Type 'commonchain --help' (without quotes) to see a list of available commands."
   echo "--------------------"
   echo "gitrepo: $gitrepo" #test
   echo "releasetag: $releasetag" #test
   echo "releasetagnov: $releasetagnov" #test
fi

if [ "$1" = "latest" ]; then
   if [ "$2" = "" ]; then
      #echo "Latest block is:"
      echo "$lastblock"
fi
   if [ "$2" = "validate" ]; then
      echo "This feature isn't available yet."
fi
fi

if [ "$1" = "previous" ]; then
   echo "Previous block is:"
   echo "$prevblock"
fi
