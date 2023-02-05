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

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 App data provider delegate.
 */
@protocol MPAppDataProviderDelegate <NSObject>
/**
 App data ready callback method.
 @param appData object.
 */
@required
- (void) onAppDataReady: (MPAppData*)appData;

@end

/// > Warning: [INTERNAL - DO NOT USE]
/**
 The app data provider acts as a service for the metadata (MPAppData) of a MapsIndoors app solution.
 */
@interface MPAppDataProvider : NSObject


/**
 Callback block for getting app data or handling error in doing so.

 @param appData App metadata object. Will be nil if an error occurred
 @param error Error object. Will be nil if fetching was complete
 */
typedef void(^mpAppDataHandlerBlockType)(MPAppData* _Nullable appData, NSError* _Nullable error);


/**
 Delegate object. This is another way of handling data fetching. Using completionHandler block instead is recommended.
 */
@property (nonatomic, weak, nullable) id <MPAppDataProviderDelegate> delegate;

/**
 Get app metadata and handle the data with a callback block
 @param handler Data fetch and error callback handler block
 */
- (void)getAppDataWithCompletion:(nullable mpAppDataHandlerBlockType)handler;
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

NS_ASSUME_NONNULL_END
