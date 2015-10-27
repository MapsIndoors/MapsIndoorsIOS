// IndoorAtlas iOS SDK
// IndoorAtlasTypes.h

/**
 * Represents degree value
 */
typedef double IndoorAtlasDegrees;

/**
 * Direction is measured in degrees relative to top of image
 */
typedef IndoorAtlasDegrees IndoorAtlasDirection;

/**
 * Struct representing geographic coordinate
 */
typedef struct IndoorAtlasCoordinate {
    IndoorAtlasDegrees latitude, longitude;
} IndoorAtlasCoordinate;

/**
 * Struct representing arbitary 2D point
 */
typedef struct IndoorAtlasPoint {
    double x, y;
} IndoorAtlasPoint;

/**
 * Struct representing pixel point in 2D image
 */
typedef struct IndoorAtlasPixel {
    int x, y;
} IndoorAtlasPixel;

/* vim: set ts=8 sw=4 tw=0 ft=objc :*/
