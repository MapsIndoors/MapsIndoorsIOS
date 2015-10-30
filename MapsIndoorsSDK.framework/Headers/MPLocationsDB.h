#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMDatabaseQueue.h"
#import "MPTileDB.h"
#import "MPMapExtend.h"
#import "MPLocationDataset.h"

/**
 * Locations database class. Used to download and serve offline MapsPeople tiles.
 */
@interface MPLocationsDB : NSObject

/**
 * The database path.
 */
@property NSString *sqLiteDb;
/**
 * The database queue.
 */
@property FMDatabaseQueue* dbQueue;
/**
 * Delegate object that holds an event method that fires when database is ready.
 */
@property (weak) id <MPDBDelegate> delegate;

- (NSString *)getLocationsAsJSONByFloor:(int)floor andZoomLevel:(float)zoomLevel andMapExtend:(MPMapExtend*)mapExtend;

- (void) saveLocations:(MPLocationDataset*) dataSet displayRules:(MPLocationDisplayRuleset*)rules;

/**
 * 
 */
- (void)loadDatabase:(NSString*) name language: (NSString*) language;
/**
 * Parse date from string.
 */
- (NSDate*)parseDate:(NSString*)inStrDate format:(NSString*)inFormat;

@end