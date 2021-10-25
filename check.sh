#!/bin/bash -e

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
