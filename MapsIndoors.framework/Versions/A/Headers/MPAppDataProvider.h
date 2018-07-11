//
//  MPAppConfigProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 08/08/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"
#import "MPAppData.h"


/**
 App data provider delegate.
 */
@protocol MPAppDataProviderDelegate <NSObject>
/**
 App data ready callback method.
 @param  AppData object.
 */
@required
- (void) onAppDataReady: (MPAppData*)appData;

@end


/**
 The app data provider acts as a service for the metadata (MPAppData) of a MapsIndoors app solution.
 */
@interface MPAppDataProvider : NSObject


/**
 Callback block for getting app data or handling error in doing so.

 @param appData App metadata object. Will be nil if an error occurred
 @param error Error object. Will be nil if fetching was complete
 */
typedef void(^mpAppDataHandlerBlockType)(MPAppData* appData, NSError* error);


/**
 Delegate object. This is another way of handling data fetching. Using completionHandler block instead is recommended.
 */
@property (weak) id <MPAppDataProviderDelegate> delegate;

    
/**
 Get app metadata and handle the data with a callback block
 @param solutionId The solution to get app metadata for
 @param language Specifies which language to fetch. Only supports the available languages in the specified solution.
 @param handler Data fetch and error callback handler block
 */
- (void)getAppDataAsync:(NSString *)solutionId language: (NSString*) language completionHandler:(mpAppDataHandlerBlockType)handler MP_DEPRECATED_MSG_ATTRIBUTE("Use getAppDataWithCompletion: instead");
/**
 Get app metadata. Assign a delegate object to this instance in order to handle the data fetch.

 @param solutionId The solution to get app metadata for
 @param language Specifies which language to fetch content for. Uses 2 character ISO 639-1 representation. Only supports the available languages in the specified solution.
 */
- (void)getAppDataAsync:(NSString *)solutionId language: (NSString*) language MP_DEPRECATED_MSG_ATTRIBUTE("Use getAppData instead");
/**
 Get app metadata and handle the data with a callback block
 @param handler Data fetch and error callback handler block
 */
- (void)getAppDataWithCompletion:(mpAppDataHandlerBlockType)handler;
/**
 Get app metadata. Assign a delegate object to this instance in order to handle the data fetch.
 */
- (void)getAppData;

/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 @param solutionId SolutionId to check for offline data availability.
 @param language Language to check for offline data availability.
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(NSString*)solutionId language:(NSString*)language;

@end
