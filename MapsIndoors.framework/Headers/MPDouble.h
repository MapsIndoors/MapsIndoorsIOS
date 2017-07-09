//
//  MPDouble.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Basic point geometry class.
 */
@interface MPDouble : NSObject

@property double doubleValue;

/**
 double initialization.
 */
- (MPDouble*)init:(double)value;

@end
