#!/bin/bash -e

nm="CommonChain"
vs="r1"
commonchainversion="""
        \e[1;42m $nm \e[0m\e[100m version $vs \e[0m
        \e[100m Created in 10-21-2021 by Daniella Mesquita \e[0m
"""

lastblock=$(find -maxdepth 1 -name '*.json' | sort -t_ -nk2,2 | tail -n1)
prevblock="This feature isn't available yet."
gitrepo="$(jq -r '.gitrepo' 0.json)"
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
      echo "Latest block is:"
      echo "$lastblock"
fi
   if [ "$2" = "validate" ]; then
      echo "This feature isn't available yet. Or is?"
      echo "Validating..."
      echo "[1/2] Fresh URL vs. latest block's URL:"
      filename=$(jq -r '.fileprefix' 0.json)$releasetag$(jq -r '.filesufix' 0.json)
      freshurl="https://github.com/"$gitrepo"/releases/download/"$releasetag"/"$filename
      if [ "$(jq -r '.url' $lastblock)" = "$freshurl" ]; then
         echo "Done! There's a match!"
         echo "Validation 1/2 passed."
         echo "[2/2] latest block's URL vs. IPFS CID:"
         echo "Downloading release file from Fresh URL..."
         wget $freshurl
         echo "Checking for package integrity..."
#         if [ "$(ipfs add -q --only-hash ./$filename | ipfs cid base32)" = "$(jq -r '.ipfs' $lastblock)" ]
         if [ "$(ipfs add -q --only-hash ./$filename)" = "$(jq -r '.ipfs' $lastblock)" ]
            then
               echo "CID/Hash is the same from requested and the downloaded file, so the download is ok."
               #tar -xzf $filename
               echo "Done! There's a match!"
               echo "Validation 2/2 passed."
               echo "The latest block seems valid! More checks will be added later."
            else
               echo "Requested CID/Hash $(jq -r '.ipfs' $lastblock) is different from the result: $(ipfs add -q --only-hash ./$filename). Your download is corrupt. Please try again."
               echo "Validation 2/2 failed."
fi
         rm $filename
fi
fi
fi

if [ "$1" = "previous" ]; then
   echo "Previous block is:"
   echo "$prevblock"
fi
