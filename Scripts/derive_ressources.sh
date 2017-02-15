SID=$1
rm -rf ${SRCROOT}/res
mkdir -p ${SRCROOT}/res

BASEURL="https://api.mapsindoors.com"

DATATIMESTAMP=$(date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s")
echo "{ \"timestamp\" : $DATATIMESTAMP }" > ${SRCROOT}/res/mi_sync_timestamp.json

for relUrl in "/sync/venues" "/sync/buildings" "/sync/appconfig" "/sync/solutions" "/sync/locations" "/sync/categories" "/sync/graph" "/sync/tiles"; do
    url="$BASEURL$relUrl?solutionId=$SID"
    path="mi$(echo ${relUrl//\//_})"
    path="${SRCROOT}/res/$path.json"
    echo "Downloading asset from $url to path $path"
    curl $url -o $path
done


for fileName in "${SRCROOT}/res/mi_sync_solutions.json" "${SRCROOT}/res/mi_sync_tiles.json" "${SRCROOT}/res/mi_sync_locations.json" "${SRCROOT}/res/mi_sync_appconfig.json"; do
    grep -oE '\b(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' $fileName | while read url
    do
        path="$(echo $url | cut -d '/' -f4-)"
        path="mi_$(echo ${path//\//_})"
        path="${SRCROOT}/res/$path"
        if [ ! -f $path ]; then
            echo "Downloading asset from $url to path $path"
            curl $url -o $path
        fi
    done
done

find -L ${SRCROOT}/res \
-type f -not -name ".*" \
-not -name "`basename ${INFOPLIST_FILE}`" \
| xargs -t -I {} \
cp {} "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/"
