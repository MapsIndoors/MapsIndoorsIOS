//
//  MPImageProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 04/02/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import "MPImageProvider.h"

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 The image provider acts as a service for fetching images either online or cached offline. Only intended for png images.
 */
@interface MPPngImageProvider : NSObject<MPImageProviderProtocol>

@end
