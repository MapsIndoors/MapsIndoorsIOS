#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMDatabaseQueue.h"

/**
 * Delegate protocol specification that specify an event method that fires when tile database is ready.
 */
@protocol MPDBDelegate <NSObject>
/**
 * Event method that fires when tile database is ready.
 */
@required
- (void) dbCreated;
@end

/**
 * Tile database class. Used to download and serve offline MapsPeople tiles.
 */
@interface MPTileDB : NSObject

/**
 * The database path.
 */
@property NSString *sqLiteDb;
/**
 * The database queue.
 */
@property FMDatabaseQueue* dbQueue;
/**
 * Delegate object that holds an event method that fires when tile database is ready.
 */
@property (weak) id <MPDBDelegate> delegate;

/**
 * Retrieve a tile from the database.
 * @param x The x coordinate in pixel space.
 * @param y The y coordinate in pixel space.
 * @param z The zoom level.
 */
- (UIImage *)getTileX:(int)x y:(int)y z:(int)z;

/**
 * Get the newest local database. If newest is online, the database will be downloaded. When local database is ready for use, dbCreated: will fire on delegate.
 */
- (void)loadDatabase:(NSString*) name;
/**
 * Parse date from string.
 */
- (NSDate*)parseDate:(NSString*)inStrDate format:(NSString*)inFormat;

@end