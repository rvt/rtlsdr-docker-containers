

tagDate=$(date '+%Y%m%d%H%M')
image=${PWD##*/}

fullNameWithTag="rvantwisk/${image}:${tagDate}"

docker build --no-cache --pull -t "${fullNameWithTag}" . && docker push ${fullNameWithTag} 

echo "###########################################"
echo "Tagged as ${fullNameWithTag}"
echo "Latest version ${fullNameWithTag}" > latest.tag
echo "###########################################"
