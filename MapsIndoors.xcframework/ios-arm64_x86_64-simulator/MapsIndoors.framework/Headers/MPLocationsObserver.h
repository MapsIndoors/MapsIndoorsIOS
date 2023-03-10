//
//  MPLocationsObserver.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationSourceStatus.h"

NS_ASSUME_NONNULL_BEGIN

@class MPLocation;
@protocol MPLocationSource;

/**
 Location observer protocol.
 */
@protocol MPLocationsObserver<NSObject>


/**
 Location update event method.

 @param locationUpdates Array of updated locations.
 @param source The source of the updated locations.
 */
- (void)onLocationsUpdate:(NSArray<MPLocation *> *)locationUpdates source:(id<MPLocationSource>)source;

/**
 Location delete event method.
 
 @param locations Array of deleted location ids.
 @param source The source of the deleted locations.
 */
- (void)onLocationsDelete:(NSArray<NSString *> *)locations source:(id<MPLocationSource>)source;

/**
 Status change event method.

 @param status The new status of the location source.
 @param source The location source changing status.
 */
- (void)onStatusChange:(MPLocationSourceStatus)status source:(id<MPLocationSource>)source;

@end

NS_ASSUME_NONNULL_END
