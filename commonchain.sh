#!/bin/bash -e

nm="CommonChain"
vs="r1"
commonchainversion="""
        \e[1;42m $nm \e[0m\e[100m version $vs \e[0m
        \e[100m Created in 10-21-2021 by Daniella Mesquita \e[0m
"""

lastblockpath=$(find -maxdepth 1 -name '*.json' | sort -t_ -nk2,2 | tail -n1)
tmp="${lastblockpath##*/}" # gives 2.json
lastblock="${tmp%.*}"      # gives 2
if [ "$lastblock" -ge "2" ]
   then
      prevblock="$(($lastblock - 1))"
   else
      prevblock="Can't verify previous block because this commonchain is still at block 1. Wait until it reach block 2 or more."
fi
gitrepo="$(jq -r '.gitrepo' 0.json)"
lastblocktag="$(jq -r '.tag' $lastblock.json)"
releasetag="$(
  curl --silent "https://api.github.com/repos/$gitrepo/releases/latest" \
  | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
)"
releasetagnov="$(
  curl --silent "https://api.github.com/repos/$gitrepo/releases/latest" \
  | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' \
  | cut -c 2-
)"
export nm && export vs && export commonchainversion && export lastblockpath && export lastblock && export prevblock && export gitrepo && export releasetag && export releasetag && export lastblocktag

if [ "$1" = "" ]; then
   if [ "$lastblocktag" != "$releasetag" ]; then
      tmp="$(($lastblock + 1))"
      #echo -n >$tmp.json
      cat > $tmp.json << ENDOFFILE
{
        "prevblock": "",
	"tag": "",
	"url": "",
	"ipfs": ""
}
ENDOFFILE
      tmp2="$(ipfs add -q --only-hash ./$lastblock.json)"
      contents="$(jq ".prevblock = \"$tmp2\"" $tmp.json)" && \
      echo "${contents}" > $tmp.json
      tmp2=""
      contents="$(jq ".tag = \"$releasetag\"" $tmp.json)" && \
      echo "${contents}" > $tmp.json
      filename=$(jq -r '.fileprefix' 0.json)$releasetag$(jq -r '.filesufix' 0.json)
      freshurl="https://github.com/"$gitrepo"/releases/download/"$releasetag"/"$filename
      contents="$(jq ".url = \"$freshurl\"" $tmp.json)" && \
      echo "${contents}" > $tmp.json
      wget -q $freshurl
      tmp2="$(ipfs add -q --only-hash ./$filename)"
      contents="$(jq ".ipfs = \"$tmp2\"" $tmp.json)" && \
      echo "${contents}" > $tmp.json
      rm $filename
      tmp2="" && filename="" && freshurl="" && tmp=""
      echo -n >justupdated.now
      ./commonchain.sh && exit
fi
   if [ -f justupdated.now ]; then
      rm justupdated.now
      echo "This commonchain has been updated just now; from block $prevblock to $lastblock!"
      echo "Its advisable to run 'commonchain latest validate' in order to verify this update is legit."
      echo "--------------------"
fi
   echo "$commonchainversion"
   echo "Type 'commonchain --help' (without quotes) to see a list of available commands."
   echo "--------------------"
   echo "gitrepo: $gitrepo" #test
   echo "Latest registered release: $lastblocktag"
   echo "Latest release:  $releasetag"
fi

if [ "$1" = "latest" ]; then
   if [ "$2" = "" ]; then
      echo "Latest block is: $lastblock"
fi
   if [ "$2" = "--plain" ]; then
      echo "$lastblock"
fi
   if [ "$2" = "validate" ]; then
      ./validate.sh
fi
fi

if [ "$1" = "previous" ]; then
   if [ "$2" = "" ]; then
      echo "Previous block is: $prevblock"
fi
   if [ "$2" = "--plain" ]; then
      echo "$prevblock"
fi
fi
