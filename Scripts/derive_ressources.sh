SID=$1
OUTPUTPATH="${SRCROOT}/res"
rm -rf ${OUTPUTPATH}
mkdir -p ${OUTPUTPATH}

BASEURL="https://api.mapsindoors.com"

echo "{ \"solutionId\" : \"$SID\" }" > "${OUTPUTPATH}/mi_sync_solutionid.json"

DATATIMESTAMP=$(date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s")
echo "{ \"timestamp\" : $DATATIMESTAMP }" > ${OUTPUTPATH}/mi_sync_timestamp.json

for relUrl in "/sync/venues" "/sync/buildings" "/sync/appconfig" "/sync/solutions" "/sync/locations" "/sync/categories" "/sync/graph" "/sync/tiles"; do
    url="$BASEURL$relUrl?solutionId=$SID"
    path="mi$(echo ${relUrl//\//_})"
    path="${OUTPUTPATH}/$path.json"
    echo "Downloading asset from $url to path $path"
    curl $url -o $path
done

# "${OUTPUTPATH}/mi_sync_locations.json" 
for fileName in "${OUTPUTPATH}/mi_sync_solutions.json" "${OUTPUTPATH}/mi_sync_tiles.json" "${OUTPUTPATH}/mi_sync_appconfig.json"; do
    grep -oE '\b(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' $fileName | while read url
    do
        path="$(echo $url | cut -d '/' -f4-)"
        path="mi_$(echo ${path//\//_})"
        path="${OUTPUTPATH}/$path"
        if [ ! -f $path ]; then
            echo "Downloading asset from $url to path $path"
            curl $url -o $path
        fi
    done
done

unzip ${OUTPUTPATH}/mi_tiles*.zip -d ${OUTPUTPATH}
rm ${OUTPUTPATH}/mi_tiles*.zip

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/res"

find -L ${OUTPUTPATH} \
-type f -not -name ".*" \
-not -name "`basename ${INFOPLIST_FILE}`" \
| xargs -t -I {} \
cp {} "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/res"

# Uncomment to inspect collected data when done:
# open "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/res"
