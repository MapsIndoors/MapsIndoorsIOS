//
//  MyLocationButton.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 14/11/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    MPMyLocationStateDisabled = 0,
    MPMyLocationStateEnabled = 1 << 0,
    MPMyLocationStateTrackingLocation = 1 << 1,
    MPMyLocationStateTrackingLocationAndHeading = 1 << 2,
};

@interface MyLocationButton : UIButton

@property (nonatomic,assign) NSInteger controlState;

- (UIControlState) toggleState;

@end
