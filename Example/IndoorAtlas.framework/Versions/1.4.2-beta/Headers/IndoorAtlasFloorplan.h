// IndoorAtlas iOS SDK
// IndoorAtlasPositioner.h

#import <Foundation/Foundation.h>
#import <IndoorAtlas/IndoorAtlasTypes.h>

/**
 * IndoorAtlasFloorplan represents floor plan data received from server.
 */
@interface IndoorAtlasFloorplan : NSObject

/**
 * @name Floor plan information
 */

/**
 * Identifier of the floor plan.
 */
@property (nonatomic, readonly) NSString *floorplanId;

/**
 * Name of the floor plan.
 */
@property (nonatomic, readonly) NSString *name;

/**
 * Width of the image.
 */
@property (nonatomic, readonly) NSUInteger width;

/**
 * Height of the image.
 */
@property (nonatomic, readonly) NSUInteger height;

/**
 * Conversion multiplier for pixels to meters.
 */
@property (nonatomic, readonly) float pixelToMeterConversion;

/**
 * Conversion multipliers for meters to pixels.
 */
@property (nonatomic, readonly) float meterToPixelConversion;

/**
 * WGS84 coordinate for center of the floor plan.
 */
@property (nonatomic, readonly) IndoorAtlasCoordinate coordinate;

@end

/* vim: set ts=8 sw=4 tw=0 ft=objc :*/
