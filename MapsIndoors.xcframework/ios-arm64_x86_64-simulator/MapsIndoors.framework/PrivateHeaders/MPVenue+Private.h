//
//  MPVenue+Private.h
//  MapsIndoors App
//
//  Created by Daniel Nielsen on 21/03/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import "MPMutableLocation.h"
#import "MPVenue.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPVenue (MapStyleOverride)

@property (nonatomic, strong, nullable) MPMapStyle<Optional>*   mapStyleOverride;

@end


@interface MPVenue (Private)

- (MPMutableLocation*) getLocation;

@end


@interface MPVenue ()

@property (nonatomic, strong, nullable) NSNumber<Optional>*     graphSetup;

@end

NS_ASSUME_NONNULL_END
