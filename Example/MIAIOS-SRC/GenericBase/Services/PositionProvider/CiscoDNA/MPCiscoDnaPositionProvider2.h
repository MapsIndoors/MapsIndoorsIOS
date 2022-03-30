//
//  MPCiscoDnaPositionProvider2.h
//
//  Created by Michael Bech Hansen on 11/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>
#import "GPSPositionProvider.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPCiscoDnaPositionProvider2 : GPSPositionProvider

@property (nonatomic, strong) NSString*         tenantId;
@property (nonatomic)         NSTimeInterval    refreshInterval;
@property (nonatomic)         NSTimeInterval    ciscoPositionMaxAge;

@end

NS_ASSUME_NONNULL_END
