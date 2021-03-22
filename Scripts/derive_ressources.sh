SID=
KEY=
LANG=

function usage()
{
    echo "This script downloads and bundles all needed ressources for MapsIndoors to work offline"
    echo ""
    echo "\t-h --help"
    echo "\t--api-key=[optional]      \tThe api key for the MapsIndoors api (previously known as solution id)"
    echo "\t--language=[optional]     \tThe ISO 639-1 language key for the MapsIndoors content (currently only one offline language is supported)"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
        ;;
        --content-key)
            SID=$VALUE
        ;;
        --api-key)
            KEY=$VALUE
        ;;
        --language)
            LANG=$VALUE
        ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
        ;;
        esac
    shift
done

echo "api-key is $KEY";
echo "language is $LANG";

if [ -z ${TEMP_ROOT+x} ]; then
    echo "Exiting! TEMP_ROOT is not set."
    exit 1;
fi

OUTPUTPATH="${TEMP_ROOT}/res"

if [ -d "${OUTPUTPATH}" ]; then
    rm -rf "${OUTPUTPATH}"
fi

mkdir -p "${OUTPUTPATH}"

BASEURL="https://api.mapsindoors.com"

echo "{ \"solutionId\" : \"$KEY\" }" > "${OUTPUTPATH}/mi_sync_solutionid.json"

DATATIMESTAMP=$(date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s")
echo "{ \"timestamp\" : $DATATIMESTAMP }" > "${OUTPUTPATH}/mi_sync_timestamp.json"

for relUrl in "/sync/solutions" "/sync/venues" "/sync/buildings" "/sync/appconfig" "/sync/locations" "/sync/categories" "/sync/appuserroles"; do
    url="$BASEURL$relUrl?solutionId=$KEY&lr=$LANG&v=5"
    path="mi$(echo ${relUrl//\//_})_$LANG"
    path="${OUTPUTPATH}/$path.json"
    echo "Downloading asset from $url to path $path"
    status_code=$(curl $url -o "$path" --write-out %{http_code})
    if [[ $status_code > 204 ]] ; then
        echo "Exiting because of http error"
        exit 1;
    fi
done

for relUrl in "/sync/graph" "/sync/tiles"; do
    url="$BASEURL$relUrl?solutionId=$KEY&lr=$LANG&v=5"
    path="mi$(echo ${relUrl//\//_})"
    path="${OUTPUTPATH}/$path.json"
    echo "Downloading asset from $url to path $path"
    status_code=$(curl $url -o "$path" --write-out %{http_code})
    if [[ $status_code > 204 ]] ; then
        echo "Exiting because of http error"
        exit 1;
    fi
done

# "${OUTPUTPATH}/mi_sync_locations.json" 
for fileName in "${OUTPUTPATH}/mi_sync_solutions.json" "${OUTPUTPATH}/mi_sync_tiles.json" "${OUTPUTPATH}/mi_sync_appconfig_$LANG.json" "${OUTPUTPATH}/mi_sync_locations_$LANG.json"; do
    # regex:   http(s) ://  host path extension (optional query params) BUT stop at first encountered " character
    grep -oE '\bhttp[s]?://([a-zA-Z0-9./?=_-]|%2F)*(.png|.jpg|.jpeg|.pdf|.zip)(\?[^\"]*)?' "$fileName" | while read url
    do
        path="$(echo $url | cut -d '/' -f4-)"
        path=`echo $path | sed -e "s/%2F/\//g"`
        path="mi_$(echo ${path//\//_})"
        path="${path/\?*/}"
        path="${OUTPUTPATH}/$path"
        scaleParam="scale=3"
        if [[ $url = *"api.mapsindoors.com"* ]]; then
            if [[ $url = *"?"* ]]; then
                url="$url&$scaleParam"
            else
                url="$url?$scaleParam"
            fi
        fi
        if [ ! -f "$path" ]; then
            echo "Downloading asset from $url to path $path"
            curl $url -o "$path"
        fi
    done
done

unzip "${OUTPUTPATH}/mi_tiles*.zip" -d "${OUTPUTPATH}"

find "${OUTPUTPATH}/" -name '*.zip' -exec rm {} \;

destinationFolder="${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/res"

mkdir -p "${destinationFolder}"

#readarray FILES_TO_COPY < <(find -L "${OUTPUTPATH}" -type f -not -name ".*" -not -name "`basename ${INFOPLIST_FILE}`" -print0)

echo "Copying assets from ${OUTPUTPATH} to ${destinationFolder}"
find -L "${OUTPUTPATH}" -type f -not -name ".*" -not -name "`basename ${INFOPLIST_FILE}`" -exec cp {} "${destinationFolder}" \;

#FILES_TO_COPY=$(find -L "${OUTPUTPATH}" \
#                -type f -not -name ".*" \
#                -not -name "`basename ${INFOPLIST_FILE}`" -print0)

#for FILE_TO_COPY in $a; do
#   echo "Copying asset from $FILE_TO_COPY to path $destinationFolder"

#cp "${FILE_TO_COPY/ /\\ }" "${destinationFolder}"
#done

# Uncomment to inspect collected data when done:
# open "${destinationFolder}"

exit 0;
