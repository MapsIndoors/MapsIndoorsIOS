//
//  AppFonts.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 28/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicContentSizeHelper.h"


NS_ASSUME_NONNULL_BEGIN

@interface AppFonts : NSObject

+ (instancetype) sharedInstance;

#pragma mark - Configuration
@property (nonatomic) DynamicTextSize               configuredTextSize;
@property (nonatomic) BOOL                          enableExtraLargeSizes;
@property (nonatomic) CGFloat                       minimumFontSize;

#pragma mark - Utility methods
- (CGFloat) scaledFontSizeForFontSize:(CGFloat)fontSize;    // Will never return size < minimumFontSize
- (CGFloat) fontSizeScaleFactor;                            // Caller is responsible for enforcing minimumFontSize
- (UIFont*) scaledFontForSize:(CGFloat)fontSize;
- (UIFont*) scaledBoldFontForSize:(CGFloat)fontSize;

#pragma mark - Ready to use font getters
@property (nonatomic, strong, readonly) UIFont*     headerTitleFont;
@property (nonatomic, strong, readonly) UIFont*     listItemFont;
@property (nonatomic, strong, readonly) UIFont*     listItemSubTextFont;

@property (nonatomic, strong, readonly) UIFont*     emptyStateMessageFont;

@property (nonatomic, strong, readonly) UIFont*     buttonFont;

@property (nonatomic, strong, readonly) UIFont*     directionsFont;
@property (nonatomic, strong, readonly) UIFont*     directionsFontSmall;

@property (nonatomic, strong, readonly) UIFont*     launscreenWelcomeMessageFont;
@property (nonatomic, strong, readonly) UIFont*     launscreenLoadingMessageFont;

@property (nonatomic, strong, readonly) UIFont*     infoWindowFont;

@property (nonatomic, strong, readonly) UIFont*     infoMessageFont;

@end

NS_ASSUME_NONNULL_END
