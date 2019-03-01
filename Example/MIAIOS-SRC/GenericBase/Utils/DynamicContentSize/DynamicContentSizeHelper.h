//
//  DynamicContentSizeHelper.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 28/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM( NSUInteger, DynamicTextSize) {
    DynamicTextSize_Unknown,

    // "Normal" dynamic size range:
    DynamicTextSize_XS,
    DynamicTextSize_S,
    DynamicTextSize_M,
    DynamicTextSize_L,
    DynamicTextSize_XL,
    DynamicTextSize_XXL,
    DynamicTextSize_XXXL,

    // Extra large accessibility sizes:
    DynamicTextSize_Accessibility_M,
    DynamicTextSize_Accessibility_L,
    DynamicTextSize_Accessibility_XL,
    DynamicTextSize_Accessibility_XXL,
    DynamicTextSize_Accessibility_XXXL
};

typedef void (^DynamicTextSizeWillUpdateBlock)( DynamicTextSize dynamicTextSize );


@interface DynamicContentSizeHelper : NSObject

+ (instancetype) sharedInstance;
+ (NSString*) nameForTextSize:(DynamicTextSize)textSize;

@property (nonatomic, readonly) DynamicTextSize               dynamicTextSize;
@property (nonatomic, copy) DynamicTextSizeWillUpdateBlock    updateBlock;

@end


NS_ASSUME_NONNULL_END
