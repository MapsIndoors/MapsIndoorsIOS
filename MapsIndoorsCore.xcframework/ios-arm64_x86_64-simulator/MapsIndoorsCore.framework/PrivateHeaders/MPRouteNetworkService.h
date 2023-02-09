//
//  MPRouteNetworkService.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPRouteNetworkData;


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteNetworkService : NSObject

/**
 Fetch the current solutions routing graph and associated data, and once completed call completion handler.
 -[MapsIndoors provideSolutionId] must be valid for this method to succeed.
 
 if a valid completion handler is given, it is also called in the case of an invalid solutionId.

 - Parameter completion: Completion handler block.  Required.  Always called on the main queue.
 - Returns: YES if all parameters are valid and the request continues processing, NO if any parameter is invalid.
 */
+ (BOOL) getRouteNetworkForCurrentSolutionWithCompletion:(nonnull void(^)(MPRouteNetworkData* _Nullable,NSError* _Nullable))completion;

/**
 Fetch the current solutions routing graph and associated data, and once completed call completion handler.
 
 if a valid completion handler is given, it is also called in the case of an invalid solutionId.

 - Parameter solutionId: Id of the solution to fetch data for. Required.
 - Parameter completion: Completion handler block.  Required.  Always called on the main queue.
 - Returns: YES if all parameters are valid and the request continues processing, NO if any parameter is invalid.
 */
+ (BOOL) getRouteNetworkForSolution:(nonnull NSString*)solutionId completion:(nonnull void(^)(MPRouteNetworkData* _Nullable,NSError* _Nullable))completion;

/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 - Parameter solutionId:  SolutionId to check for offline data availability.
 - Returns: YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isCachedDataAvailableForSolutionId:(nonnull NSString*)solutionId;

@end
