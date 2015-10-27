// IndoorAtlas iOS SDK
// IndoorAtlas.h

#import <Foundation/Foundation.h>
#import <IndoorAtlas/IndoorAtlasErrors.h>
#import <IndoorAtlas/IndoorAtlasFloorplan.h>
#import <IndoorAtlas/IndoorAtlasCalibrator.h>
#import <IndoorAtlas/IndoorAtlasPositioner.h>

/**
 * IndoorAtlasFetch protocol for controlling fetch requests.
 */
@protocol IndoorAtlasFetch <NSObject>

/**
 * Cancel fetch.
 *
 * Running fetch is completed with cancel error.
 */
- (void)cancel;

@end

/**
 * IndoorAtlas class is a singleton representing the API interface.
 * Use the singleton for obtaining SDK version information, authenticating the session, fetching floor plans and instantiating <IndoorAtlasCalibrator> and <IndoorAtlasPositioner> objects.
 */
@interface IndoorAtlas : NSObject

/**
 * @name SDK version
 */

/**
 * Returns SDK version string.
 *
 * The version string returned is in format "major.minor.patch". (see: [Semantic Versioning](http://semver.org/))
 */
+ (NSString*)versionString;

/**
 * @name Authenticate your session
 */

/**
 * Set IndoorAtlas API key and secret for authentication.
 *
 * This method must be called before further requests with server requiring authentication.
 *
 * @param key API key used for authentication.
 * @param secret API secret used for authentication.
 */
+ (void)setApiKey:(NSString*)key andSecret:(NSString*)secret;

/**
 * @name Fetch floor plans
 */

/**
 * Fetch floor plan object from server using ID.
 *
 * @param floorplanId Identifier of floor plan to fetch from server.
 * @param completionBlock A block to be called when floor plan fetch is completed.
 *
 *     - *floorplan*: A object representing fetched floor plan. If an error occured, this parameter is nil.
 *     - *error*: If an error occured, this object describes the error. If the operation completed successfully, this value is nil.
 *
 * @return IndoorAtlasFetch instance for the request.
 */
+ (id<IndoorAtlasFetch>)fetchFloorplanWithId:(NSString*)floorplanId
                                  completion:(void (^)(IndoorAtlasFloorplan *floorplan, NSError *error))completionBlock;

/**
 * Fetch image file data for floor plan object.
 *
 * @param floorplan A floor plan to fetch image file data for.
 * @param completionBlock A block to be called when image download is completed.
 *
 *     - *data*: Image file data. If an error occured, this parameter is nil.
 *     - *error*: If an error occured, this object describes the error. If the operation completed successfully, this value is nil.
 *
 * @return IndoorAtlasFetch instance for the request.
 */
+ (id<IndoorAtlasFetch>)fetchFloorplanImage:(IndoorAtlasFloorplan*)floorplan
                                 completion:(void(^)(NSData *data, NSError *error))completionBlock;

/**
 * Fetch image file data for floor plan object with progress indicator block.
 *
 * @param floorplan A floor plan to fetch image file data for.
 * @param completionBlock A block to be called when image download is completed.
 *
 *     - *data*: Image file data. If an error occured, this parameter is nil.
 *     - *error*: If an error occured, this object describes the error. If the operation completed successfully, this value is nil.
 *
 * @param progressBlock A block to be called whenever request progresses.
 *
 *     - *progress*: Progress of request (0..1)
 *
 * @return IndoorAtlasFetch instance for the request.
 */
+ (id<IndoorAtlasFetch>)fetchFloorplanImage:(IndoorAtlasFloorplan*)floorplan
                                 completion:(void(^)(NSData *data, NSError *error))completionBlock
                                   progress:(void(^)(float progress))progressBlock;

/**
 * @name Create positioner objects
 */

/**
 * Creates positioner object initialized with floor plan object.
 *
 * @param floorplan A floor plan object for initializing positioner.
 * @return <IndoorAtlasPositioner> instance.
 */
+ (IndoorAtlasPositioner*)positionerForFloorplan:(IndoorAtlasFloorplan*)floorplan;

@end

// vim: set ts=8 sw=4 tw=0 ft=objc :
