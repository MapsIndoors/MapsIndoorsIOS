//
//  MyLocationButton.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 14/11/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM( NSUInteger, TrackingButtonState ) {
    TrackingButtonState_Disabled,
    TrackingButtonState_Enabled,
    TrackingButtonState_TrackingLocation,
    TrackingButtonState_TrackingLocationAndHeading,
    TrackingButtonState_TrackingLocationAndHeadingSuspended,
};

@interface MyLocationButton : UIButton

@property (nonatomic, assign) TrackingButtonState   trackingButtonState;

@end
