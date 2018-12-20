//
//  MPLocationBuilder.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 29/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"
#import "MPLocationField.h"
#import "MPLocationSource.h"

@class MPLocationDisplayRule;

NS_ASSUME_NONNULL_BEGIN

@interface MPLocationUpdate : NSObject

+ (MPLocationUpdate*) updateWithLocation:(MPLocation*) location;
+ (MPLocationUpdate*) updateWithId:(NSInteger)locationId fromSource:(id<MPLocationSource>) locationSource;
- (void) setType: (NSString*) type;
- (void) addPropertyValue: (NSString*) value forKey:(NSString*) key;
- (void) setFloor: (NSInteger) floorIndex;
- (void) setPosition: (CLLocationCoordinate2D) position;
- (void) addCategory: (NSString*) categoryKey;
- (void) setDisplayRule:(MPLocationDisplayRule*)displayRule;
- (void) setMarkerImage:(UIImage*)markerImage;
- (void) setMarkerImageUrl:(NSURL*)markerImageUrl;

- (MPLocation*) location;
- (nullable MPLocation*) prototypeLocation;

@end

NS_ASSUME_NONNULL_END
