SID=
KEY=
LANG=

ENVIRONMENT="dev"
DB_PATH="/data/db"

function usage()
{
    echo "This script downloads and bundles all needed ressources for MapsIndoors to work offline"
    echo ""
    echo "\t-h --help"
    echo "\t--content-key=[required]  \tThe key for the MapsIndoors content (also known as solution id)"
    echo "\t--api-key=[optional]      \tThe api key for the MapsIndoors api (needed in some implementations)"
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
        --solution-id)
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

echo "content-key is $SID";
echo "api-key is $KEY";
echo "language is $LANG";


OUTPUTPATH="${SRCROOT}/res"
rm -rf ${OUTPUTPATH}
mkdir -p ${OUTPUTPATH}

BASEURL="https://api.mapsindoors.com"

echo "{ \"solutionId\" : \"$SID\" }" > "${OUTPUTPATH}/mi_sync_solutionid.json"

DATATIMESTAMP=$(date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s")
echo "{ \"timestamp\" : $DATATIMESTAMP }" > ${OUTPUTPATH}/mi_sync_timestamp.json

for relUrl in "/sync/venues" "/sync/buildings" "/sync/appconfig" "/sync/solutions" "/sync/locations" "/sync/categories" "/sync/graph" "/sync/tiles"; do
    url="$BASEURL$relUrl?solutionId=$SID&key=$KEY&lr=$LANG"
    path="mi$(echo ${relUrl//\//_})"
    path="${OUTPUTPATH}/$path.json"
    echo "Downloading asset from $url to path $path"
    status_code=$(curl $url -o $path --write-out %{http_code})
    if [[ $status_code > 204 ]] ; then
        echo "Exiting because of http error"
        exit;
    fi
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

if ls ${OUTPUTPATH}/mi_tiles*.zip 1> /dev/null 2>&1; then
    unzip ${OUTPUTPATH}/mi_tiles*.zip -d ${OUTPUTPATH}
    rm ${OUTPUTPATH}/mi_tiles*.zip
fi

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/res"

find -L ${OUTPUTPATH} \
-type f -not -name ".*" \
-not -name "`basename ${INFOPLIST_FILE}`" \
| xargs -t -I {} \
cp {} "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/res"

# Uncomment to inspect collected data when done:
# open "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/res"
