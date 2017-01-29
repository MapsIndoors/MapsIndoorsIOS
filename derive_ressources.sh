SID=$1
rm -rf res
mkdir -p res

BASEURL="https://api.mapsindoors.com"

for relUrl in "/sync/venues" "/sync/buildings" "/sync/appconfig" "/sync/solutions" "/sync/locations" "/$SID/api/categories" "/$SID/api/graphs" "/sync/tiles"; do
    url="$BASEURL$relUrl?solutionId=$SID"
    path="mi$(echo ${relUrl//\//_})"
    echo "Downloading asset from $url to path $path"
    curl $url -o "res/$path.json"
done

#curl http://api.mapsindoors.com/sync/venues?solutionId=$SID -o "res/mi_venues.json"
#curl http://api.mapsindoors.com/sync/buildings?solutionId=$SID -o "res/mi_buildings.json"
#curl http://api.mapsindoors.com/sync/appconfig?solutionId=$SID -o "res/mi_appconfig.json"
#curl http://api.mapsindoors.com/sync/solutions?solutionId=$SID -o "res/mi_solutions.json"
#curl http://api.mapsindoors.com/sync/locations?solutionId=$SID -o "res/mi_locations.json"
#curl http://api.mapsindoors.com/$SID/api/categories -o "res/mi_categories.json"
#curl http://api.mapsindoors.com/$SID/api/graphs -o "res/mi_graphs.json"
#curl http://api.mapsindoors.com/sync/tiles?solutionId=$SID -o "res/mi_tiles.json"

for fileName in "res/mi_sync_solutions.json" "res/mi_sync_tiles.json" "res/mi_sync_locations.json" "res/mi_sync_appconfig.json"; do
    grep -oE '\b(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' $fileName | while read url
    do
        path="$(echo $url | cut -d '/' -f4-)"
        path="mi_$(echo ${path//\//_})"
        echo "Downloading asset from $url to path $path"
        curl $url -o "res/$path"
    done
done

find -L ${SRCROOT}/res \
-type f -not -name ".*" \
-not -name "`basename ${INFOPLIST_FILE}`" \
| xargs -t -I {} \
cp {} "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/"
