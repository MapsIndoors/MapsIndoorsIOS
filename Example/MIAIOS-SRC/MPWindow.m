//
//  MPWindow.m - used to detect any activity, in order to remove location tracking from application if user touches UI
//  MIAIOS
//
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPWindow.h"

NSString * const MPWindowIdleNotification   = @"MPWindowIdleNotification";
NSString * const MPWindowActiveNotification = @"MPWindowActiveNotification";

@interface MPWindow (PrivateMethods)
- (void)windowIdleNotification;
- (void)windowActiveNotification;


@end


@implementation MPWindow
@synthesize idleTimer, idleTimeInterval;

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.idleTimeInterval = 0.6f;
	}
	return self;
}
#pragma mark activity timer

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
	
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {

		// To reduce timer resets only reset the timer on a Began or Ended touch.
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
		if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded) {
			if (!idleTimer) {
				[self windowActiveNotification];
			} else {
				[idleTimer invalidate];
			}
			if (idleTimeInterval != 0) {
				self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:idleTimeInterval 
																  target:self 
																selector:@selector(windowIdleNotification) 
																userInfo:nil repeats:NO];
			}
		}
	}
}


- (void)windowIdleNotification {
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc postNotificationName:MPWindowIdleNotification
					   object:self
					 userInfo:nil];
	self.idleTimer = nil;
}

- (void)windowActiveNotification {
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc postNotificationName:MPWindowActiveNotification
					   object:self
					 userInfo:nil];
}

- (void)dealloc {
	if (self.idleTimer) {
		[self.idleTimer invalidate];
		self.idleTimer = nil;
	}
}


@end
