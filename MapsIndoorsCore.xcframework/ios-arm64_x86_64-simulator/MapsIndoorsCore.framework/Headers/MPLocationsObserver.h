//
//  MPLocationsObserver.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"
#import "MPLocationSourceStatus.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@protocol MPLocationSource;


/**
 Location observer protocol.
 */
@protocol MPLocationsObserver<NSObject>


/**
 Location update event method.

 - Parameter locationUpdates: Array of updated locations.
 - Parameter source: The source of the updated locations.
 */
- (void)onLocationsUpdate:(NSArray<MPLocation *> *)locationUpdates source:(id<MPLocationSource>)source;

/**
 Location delete event method.
 
 - Parameter locations: Array of deleted location ids.
 - Parameter source: The source of the deleted locations.
 */
- (void)onLocationsDelete:(NSArray<NSString *> *)locations source:(id<MPLocationSource>)source;

/**
 Status change event method.

 - Parameter status: The new status of the location source.
 - Parameter source: The location source changing status.
 */
- (void)onStatusChange:(MPLocationSourceStatus)status source:(id<MPLocationSource>)source;

@end

NS_ASSUME_NONNULL_END
