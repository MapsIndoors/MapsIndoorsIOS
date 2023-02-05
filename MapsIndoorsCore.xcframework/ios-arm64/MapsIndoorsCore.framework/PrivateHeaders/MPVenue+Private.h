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

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPVenue (MapStyleOverride)

@property (nonatomic, strong, nullable, readwrite) MPMapStyle<Optional>*   mapStyleOverride;

@end

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPVenue (Private)

- (MPMutableLocation*) getLocation;

@end


@interface MPVenue ()

@property (nonatomic, strong, nullable) NSNumber<Optional>*     graphSetup;

@end

NS_ASSUME_NONNULL_END
