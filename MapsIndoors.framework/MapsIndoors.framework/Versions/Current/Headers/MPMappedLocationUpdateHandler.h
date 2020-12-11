//
//  MPMappedLocationUpdateHandler.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 17/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MPLocation;

@protocol MPMappedLocationUpdateHandler <NSObject>

/**
 Called when MPMapControl will invoke a location update on the map.

 @param locations The locations that will be updated.
 */
@required
- (void) willUpdateLocationsOnMap:(nonnull NSArray<MPLocation*>*)locations NS_SWIFT_NAME(willUpdateLocationsOnMap(locations:));;

@end


NS_ASSUME_NONNULL_END


