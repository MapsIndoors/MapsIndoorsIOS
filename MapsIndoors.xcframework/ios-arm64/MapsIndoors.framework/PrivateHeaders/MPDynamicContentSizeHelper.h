//
//  MPDynamicContentSizeHelper.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 28/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM( NSUInteger, MPDynamicTextSize) {
    MPDynamicTextSize_Unknown,

    // "Normal" dynamic size range:
    MPDynamicTextSize_XS,
    MPDynamicTextSize_S,
    MPDynamicTextSize_M,
    MPDynamicTextSize_L,
    MPDynamicTextSize_XL,
    MPDynamicTextSize_XXL,
    MPDynamicTextSize_XXXL,

    // Extra large accessibility sizes:
    MPDynamicTextSize_Accessibility_M,
    MPDynamicTextSize_Accessibility_L,
    MPDynamicTextSize_Accessibility_XL,
    MPDynamicTextSize_Accessibility_XXL,
    MPDynamicTextSize_Accessibility_XXXL
};

typedef void (^MPDynamicTextSizeWillUpdateBlock)( MPDynamicTextSize dynamicTextSize );


@interface MPDynamicContentSizeHelper : NSObject

+ (instancetype) sharedInstance;
+ (NSString*) nameForTextSize:(MPDynamicTextSize)textSize;

@property (nonatomic, readonly) MPDynamicTextSize               dynamicTextSize;
@property (nonatomic, copy) MPDynamicTextSizeWillUpdateBlock    updateBlock;

@end


NS_ASSUME_NONNULL_END
