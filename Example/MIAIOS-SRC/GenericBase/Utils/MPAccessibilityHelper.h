//
//  MPAccessibilityHelper.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 30/07/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^mpAccessibilityAnnouncementComplationBlock)(void);


@interface MPAccessibilityHelper : NSObject

+ (instancetype) sharedInstance;

@property (nonatomic, readonly) BOOL        voiceOverEnabled;

- (void) announceWithCompletion:(NSString*)announcement completion:(mpAccessibilityAnnouncementComplationBlock)completion;
- (void) setAccessibilityFocus:(UIView*)view;
- (void) layoutChanged;

@end
