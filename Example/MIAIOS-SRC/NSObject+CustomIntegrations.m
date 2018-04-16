//
//  NSObject+CustomIntegrations.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 12/07/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import "NSObject+CustomIntegrations.h"
#import <MapsIndoors/MapsIndoors.h>
#import "BeaconPositionProvider.h"

@implementation NSObject (CustomIntegrations)


- (BOOL) applyCustomIntegrations {
    //MapsIndoors.positionProvider = [[BeaconPositionProvider alloc] initWithUUID:@"11E44F09-4EC4-407E-9203-CF57A50FBCE0"]; //MP
    return YES;
}

@end
