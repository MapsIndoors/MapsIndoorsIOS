//
//  MPWindow.h - used to detect any activity, in order to remove location tracking from application if user touches UI
//  MIAIOS
//
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//


#import <UIKit/UIKit.h>

extern NSString * const MPWindowIdleNotification;
extern NSString * const MPWindowActiveNotification;

@interface MPWindow : UIWindow {
	NSTimer *idleTimer;
	NSTimeInterval idleTimeInterval;
}

@property (assign) NSTimeInterval idleTimeInterval;

@property (nonatomic, retain) NSTimer *idleTimer;

@end
