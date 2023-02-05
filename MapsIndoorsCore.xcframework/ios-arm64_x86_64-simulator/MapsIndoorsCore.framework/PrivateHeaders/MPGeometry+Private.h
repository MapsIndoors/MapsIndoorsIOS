//
//  MPGeometry+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 03/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPGeometry.h"
#import "MIGeometry.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPGeometry (Private)

@property (nonatomic, strong, readonly) MIGeometry* miGeometry;

@end

NS_ASSUME_NONNULL_END
