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


@implementation MyLocationButton {
    NSArray* toggleStates;
    NSUInteger toggleStateIndex;
    NSMutableDictionary* colorsForControlState;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        colorsForControlState = [NSMutableDictionary dictionary];
        [self setTitleColor:[UIColor appPrimaryTextColor] forState:MPMyLocationStateDisabled];
        [self setTitleColor:[UIColor appPrimaryTextColor] forState:MPMyLocationStateEnabled];
        [self setTitleColor:[UIColor appPrimaryTextColor] forState:MPMyLocationStateTrackingLocation];
        [self setTitleColor:[UIColor appPrimaryTextColor] forState:MPMyLocationStateTrackingLocationAndHeading];
        
        [self setImage:[UIImage imageNamed:@"MyLocationDisabled"] forState:MPMyLocationStateDisabled];
        [self setImage:[UIImage imageNamed:@"MyLocationEnabled"] forState:MPMyLocationStateEnabled];
        [self setImage:[UIImage imageNamed:@"MyLocationTracking"] forState:MPMyLocationStateTrackingLocation];
        [self setImage:[UIImage imageNamed:@"MyLocationTrackingHeading"] forState:MPMyLocationStateTrackingLocationAndHeading];
        
        [self sizeToFit];
        
        self.contentEdgeInsets = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0;
        self.layer.shadowRadius = 8;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.25;
        
        self.controlState = MPMyLocationStateEnabled;
        toggleStates = @[ @(MPMyLocationStateTrackingLocation), @(MPMyLocationStateTrackingLocationAndHeading), @(MPMyLocationStateEnabled) ];
        toggleStateIndex = -1;
        
        self.isAccessibilityElement = YES;
    }
    
    return self;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [super setTitleColor:color forState:state];
    [colorsForControlState setObject:color forKey:@(state)];
}

- (UIControlState)state {
    NSInteger returnState = [super state];
    return ( returnState | self.controlState );
}

- (void) setControlState:(NSInteger)controlState {

    if ( _controlState != controlState ) {
        _controlState = controlState;
        [self setNeedsLayout];
        [self setAccessibilityLabelForCurrentControlState];
    }
}

- (UIControlState) toggleState {
    if (++toggleStateIndex >= toggleStates.count) {
        toggleStateIndex = 0;
    }
    NSNumber* newState = [toggleStates objectAtIndex:toggleStateIndex];
    self.controlState = newState.unsignedIntegerValue;
    
    return self.controlState;
}

- (void) setAccessibilityLabelForCurrentControlState {

    NSString*   s;
    
    switch ( self.controlState ) {
        case MPMyLocationStateDisabled:
            s = kLangTrackingDisabled;
            break;
        case MPMyLocationStateEnabled:
            s = kLangTrackingOff;
            break;
        case MPMyLocationStateTrackingLocation:
            s = kLangTrackingOn;
            break;
        case MPMyLocationStateTrackingLocationAndHeading:
            s = kLangTrackingOnWithHeading;
            break;

        default:
            break;
    }
    
    if ( s ) {
        self.accessibilityLabel = s;
        self.accessibilityHint = kLangChangeTrackingState;
    }
}

@end
