//
//  MPRouteNetworkService.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPRouteNetworkData;


@interface MPRouteNetworkService : NSObject

/**
 Fetch the current solutions routing graph and associated data, and once completed call completion handler.
 -[MapsIndoors provideSolutionId] must be valid for this method to succeed.
 
 if a valid completion handler is given, it is also called in the case of an invalid solutionId.

 @param completion Completion handler block.  Required.  Always called on the main queue.
 @return YES if all parameters are valid and the request continues processing, NO if any parameter is invalid.
 */
+ (BOOL) getRouteNetworkForCurrentSolutionWithCompletion:(nonnull void(^)(MPRouteNetworkData* _Nullable,NSError* _Nullable))completion;

/**
 Fetch the current solutions routing graph and associated data, and once completed call completion handler.
 
 if a valid completion handler is given, it is also called in the case of an invalid solutionId.

 @param solutionId Id of the solution to fetch data for. Required.
 @param completion Completion handler block.  Required.  Always called on the main queue.
 @return YES if all parameters are valid and the request continues processing, NO if any parameter is invalid.
 */
+ (BOOL) getRouteNetworkForSolution:(nonnull NSString*)solutionId completion:(nonnull void(^)(MPRouteNetworkData* _Nullable,NSError* _Nullable))completion;

/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 @param solutionId  SolutionId to check for offline data availability.
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isCachedDataAvailableForSolutionId:(nonnull NSString*)solutionId;

@end
