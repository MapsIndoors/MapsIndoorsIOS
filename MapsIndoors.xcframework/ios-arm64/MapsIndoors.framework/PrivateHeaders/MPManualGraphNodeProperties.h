//
//  MPManualGraphNodeProperties.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 12/12/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPGraphNodePropertyProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPManualGraphNodeProperties : NSObject <MPGraphNodePropertyProtocol>

+ (instancetype) newGraphNodePropertiesWithBoundary:(NSUInteger)boundary barrier:(NSString*)barrier floorname:(NSString*)floorname waittime:(NSTimeInterval)waittime;
+ (instancetype) newGraphNodePropertiesWithFloorname:(NSString*)floorname;
- (instancetype) init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
