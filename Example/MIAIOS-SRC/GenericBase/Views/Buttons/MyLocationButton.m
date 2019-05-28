//
//  MyLocationButton.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 14/11/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MyLocationButton.h"
#import "UIColor+AppColor.h"
#import "LocalizedStrings.h"


@implementation MyLocationButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setTitleColor:[UIColor appPrimaryTextColor] forState:UIControlStateNormal];

        self.trackingButtonState = TrackingButtonState_Enabled;

        [self sizeToFit];
        
        self.contentEdgeInsets = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0;
        self.layer.shadowRadius = 8;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.25;

        self.isAccessibilityElement = YES;
    }
    
    return self;
}

- (void) setTrackingButtonState:(TrackingButtonState)trackingButtonState {

    if ( _trackingButtonState != trackingButtonState ) {

        _trackingButtonState = trackingButtonState;

        NSString*   imgName;

        switch ( _trackingButtonState ) {
            case TrackingButtonState_Disabled:                              imgName = @"MyLocationDisabled";  break;
            case TrackingButtonState_Enabled:                               imgName = @"MyLocationEnabled";   break;
            case TrackingButtonState_TrackingLocation:                      imgName = @"MyLocationTracking";  break;
            case TrackingButtonState_TrackingLocationAndHeading:            imgName = @"MyLocationTrackingHeading";   break;
            case TrackingButtonState_TrackingLocationAndHeadingSuspended:   imgName = @"MyLocationTrackingHeadingSuspended";  break;
        }

        if ( imgName ) {
            UIImage*    img = [UIImage imageNamed:imgName];
            [self setImage:img forState:UIControlStateNormal];
        }

        [self setNeedsLayout];
        [self setAccessibilityLabelForCurrentControlState];
    }
}

- (void) setAccessibilityLabelForCurrentControlState {

    NSString*   s;
    
    switch ( self.trackingButtonState ) {
        case TrackingButtonState_Disabled:
            s = kLangTrackingDisabled;
            break;
        case TrackingButtonState_Enabled:
        case TrackingButtonState_TrackingLocationAndHeadingSuspended:
            s = kLangTrackingOff;
            break;
        case TrackingButtonState_TrackingLocation:
            s = kLangTrackingOn;
            break;
        case TrackingButtonState_TrackingLocationAndHeading:
            s = kLangTrackingOnWithHeading;
            break;
    }
    
    if ( s ) {
        self.accessibilityLabel = s;
        self.accessibilityHint = kLangChangeTrackingState;
    }
}

@end
