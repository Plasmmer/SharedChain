#!/bin/bash -e

echo "Validating..."
echo "[1/4] Fresh URL vs. latest block's URL:"
filename=$(jq -r '.fileprefix' 0.json)$lastblocktag$(jq -r '.filesufix' 0.json)
freshurl="https://github.com/"$gitrepo"/releases/download/"$lastblocktag"/"$filename
echo "$lastblocktag"
if [ "$(jq -r '.url' $lastblock.json)" = "$freshurl" ]; then
   echo "Done! There's a match!"
   echo "Validation 1/4 passed."
   echo "[2/4] latest block's URL vs. IPFS CID:"
   echo "Downloading release file from Fresh URL..."
   wget $freshurl
   echo "Checking for package integrity..."
#   if [ "$(ipfs add -q --only-hash ./$filename | ipfs cid base32)" = "$(jq -r '.ipfs' $lastblock.json)" ]
   if [ "$(ipfs add -q --only-hash ./$filename)" = "$(jq -r '.ipfs' $lastblock.json)" ]
      then
         echo "CID/Hash is the same from requested and the downloaded file, so the download is ok."
         #tar -xzf $filename
         echo "Done! There's a match!"
         echo "Validation 2/4 passed."
         echo "The latest block seems valid! But, next step..."
         echo "[3/4] Validating first block with genesis block:"
         if [ "$(ipfs add -q --only-hash ./1.json)" = "$(jq -r '.firstblock' 0.json)" ]
            then
               echo "Done! There's a match!"
               echo "Validation 3/4 passed."
               echo "[4/4] Previous block's hash:"
               if [ "$lastblock" -ge "2" ]
                  then
                     if [ "$(ipfs add -q --only-hash ./$prevblock.json)" = "$(jq -r '.prevblock' $lastblock.json)" ]
                        then
                           echo "Done! There's a match!"
                           echo "Validation 4/4 passed. Traversing into all previous blocks will be implemented futurely."
                        else
                           echo "Requested CID/Hash $(jq -r '.prevblock' $lastblock.json) is different from the result: $(ipfs add -q --only-hash ./$prevblock.json)."
                           echo "Validation 4/4 failed. This commonchain is corrupted in the last, previous or more blocks. Please search a way to fix."
fi
                  else
                     echo "Validation 4/4 passed. Can't verify previous block because this commonchain is still at block 1. Wait until it reach block 2 or more."
fi
            else
               echo "Requested CID/Hash $(jq -r '.firstblock' 0.json) is different from the result: $(ipfs add -q --only-hash ./1.json)."
               echo "Validation 3/4 failed. This commonchain is corrupted. Please search a way to fix."
fi
      else
         echo "Requested CID/Hash $(jq -r '.ipfs' $lastblock.json) is different from the result: $(ipfs add -q --only-hash ./$filename). Your download is corrupt. Please try again."
         echo "Validation 2/4 failed."
fi
rm $filename
fi
