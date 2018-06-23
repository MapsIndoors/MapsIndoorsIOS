//
//  MPCiscoPositionProvider.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 07/04/14.
//  Copyright (c) 2014-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPSPositionProvider.h"

@interface MPCiscoPositionProvider : GPSPositionProvider

- (instancetype)initWithServiceUrl: (NSString*) url useBitShiftedIp: (BOOL) useBitShiftedIp;

@property float interval;

@end
