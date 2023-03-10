//
//  MPDynamicFont.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 03/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPDynamicFont : NSObject

+ (UIFont*) dynamicFontBasedOnMapLabelFont;
+ (UIFont*) dynamicFontBasedOnFont:(UIFont*)font;
+ (CGFloat) dynamicFontScaleFactor;

@end

NS_ASSUME_NONNULL_END
