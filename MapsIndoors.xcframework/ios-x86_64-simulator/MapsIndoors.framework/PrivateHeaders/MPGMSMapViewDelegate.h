//
//  MPGMSMapViewDelegate.h
//  MapsIndoors
//
//  Created by Christian Wolf Johannsen on 07/12/2022.
//  Copyright © 2022 MapsPeople A/S. All rights reserved.
//

#ifndef MPGMSMapViewDelegate_h
#define MPGMSMapViewDelegate_h

#import <GoogleMaps/GoogleMaps.h>

@class MPMapControl;

@interface MPGMSMapViewDelegate : NSObject <GMSMapViewDelegate>

- (instancetype)initWithMapControl:(MPMapControl*)mapControl;

@end

#endif /* MPGMSMapViewDelegate_h */
