//
//  MyLocationButton.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 14/11/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MyLocationButton.h"
#import "UIColor+AppColor.h"

static void *kMPStateObservingContext = &kMPStateObservingContext;


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
        toggleStates = @[@(MPMyLocationStateTrackingLocation), @(MPMyLocationStateTrackingLocationAndHeading)];
        toggleStateIndex = -1;
    }
    
    return self;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [super setTitleColor:color forState:state];
    [colorsForControlState setObject:color forKey:@(state)];
}

- (void)didMoveToSuperview {
    
    [self addObserver:self forKeyPath:@"controlState" options:NSKeyValueObservingOptionOld context:kMPStateObservingContext];
}

- (UIControlState)state {
    NSInteger returnState = [super state];
    return ( returnState | self.controlState );
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"controlState"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( context == kMPStateObservingContext ) {
        NSInteger oldState = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        if ( oldState != self.controlState ) {
            [self layoutSubviews];
//            toggleStateIndex = [toggleStates indexOfObject:@(self.controlState)];
//            if (toggleStateIndex == NSNotFound) {
//                toggleStateIndex = -1;
//            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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


@end
