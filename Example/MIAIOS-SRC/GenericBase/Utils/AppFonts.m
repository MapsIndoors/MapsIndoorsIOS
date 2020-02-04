//
//  AppFonts.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 28/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "AppFonts.h"
#import "NSObject+ContentSizeChange.h"


@interface AppFonts ()

@property (nonatomic) CGFloat                       scaleFactor;
@property (nonatomic, strong, readwrite) UIFont*    headerTitleFont;
@property (nonatomic, strong, readwrite) UIFont*    listItemFont;
@property (nonatomic, strong, readwrite) UIFont*    listItemSubTextFont;
@property (nonatomic, strong, readwrite) UIFont*    launscreenWelcomeMessageFont;
@property (nonatomic, strong, readwrite) UIFont*    launscreenLoadingMessageFont;
@property (nonatomic, strong, readwrite) UIFont*    emptyStateMessageFont;
@property (nonatomic, strong, readwrite) UIFont*    buttonFont;
@property (nonatomic, strong, readwrite) UIFont*    directionsFont;
@property (nonatomic, strong, readwrite) UIFont*    directionsFontSmall;
@property (nonatomic, strong, readwrite) UIFont*    infoWindowFont;
@property (nonatomic, strong, readwrite) UIFont*    infoMessageFont;

@end


@implementation AppFonts

+ (instancetype) sharedInstance {

    static AppFonts*        _sharedInstance = nil;
    static dispatch_once_t  onceToken;

    dispatch_once(&onceToken, ^{
        _sharedInstance = [AppFonts new];
        _sharedInstance.minimumFontSize = 9;
        //_sharedInstance.enableExtraLargeSizes = YES;

        __weak AppFonts* weak_sharedInstance = _sharedInstance;
        DynamicContentSizeHelper.sharedInstance.updateBlock = ^(DynamicTextSize dynamicTextSize) {
            weak_sharedInstance.configuredTextSize = dynamicTextSize;
        };
    });

    return _sharedInstance;
}

- (instancetype) init {

    self = [super init];
    if (self) {
        self.configuredTextSize = DynamicContentSizeHelper.sharedInstance.dynamicTextSize;
    }
    return self;
}

- (CGFloat) fontSizeScaleFactor {

    return self.scaleFactor;
}

- (CGFloat) scaledFontSizeForFontSize:(CGFloat)fontSize {

    return MAX( fontSize * self.scaleFactor, self.minimumFontSize);
}

- (UIFont*) scaledFontForSize:(CGFloat)fontSize {

    return [UIFont systemFontOfSize: [self scaledFontSizeForFontSize:fontSize] ];
}

- (UIFont*) scaledBoldFontForSize:(CGFloat)fontSize {

    return [UIFont boldSystemFontOfSize: [self scaledFontSizeForFontSize:fontSize] ];
}

- (UIFont*) scaledFontBasedOnFont:(UIFont*)font {

    return [UIFont fontWithDescriptor:font.fontDescriptor size: font.pointSize * self.scaleFactor];
}


- (void) setConfiguredTextSize:(DynamicTextSize)configuredTextSize {

    // Check if we're allowed to use extra large sizes:
    if ( !self.enableExtraLargeSizes && (configuredTextSize > DynamicTextSize_XXXL) ) {
        configuredTextSize = DynamicTextSize_XXXL;
    }

    if ( _configuredTextSize != configuredTextSize ) {

        _configuredTextSize = configuredTextSize;

        CGFloat     scaleFactor = self.scaleFactor;

        switch ( _configuredTextSize ) {
            case DynamicTextSize_Unknown:
                break;

            case DynamicTextSize_XS:                      scaleFactor = 0.66;     break;
            case DynamicTextSize_S:                       scaleFactor = 0.77;     break;
            case DynamicTextSize_M:                       scaleFactor = 0.88;     break;
            case DynamicTextSize_L:                       scaleFactor = 1;        break;
            case DynamicTextSize_XL:                      scaleFactor = 1.33;     break;
            case DynamicTextSize_XXL:                     scaleFactor = 1.66;     break;
            case DynamicTextSize_XXXL:                    scaleFactor = 2;        break;

            case DynamicTextSize_Accessibility_M:         scaleFactor = 2.33;     break;
            case DynamicTextSize_Accessibility_L:         scaleFactor = 2.66;     break;
            case DynamicTextSize_Accessibility_XL:        scaleFactor = 3;        break;
            case DynamicTextSize_Accessibility_XXL:       scaleFactor = 3.5;      break;
            case DynamicTextSize_Accessibility_XXXL:      scaleFactor = 4;        break;
        }

        if ( scaleFactor != self.scaleFactor ) {

            self.scaleFactor = scaleFactor;

            self.headerTitleFont              = [self scaledBoldFontForSize:18.0];
            self.listItemFont                 = [self scaledFontForSize:15.0];
            self.listItemSubTextFont          = [self scaledFontForSize:12.0];
            self.launscreenWelcomeMessageFont = [self scaledFontForSize:24.0];
            self.launscreenLoadingMessageFont = [self scaledFontForSize:16.0];
            self.emptyStateMessageFont        = self.headerTitleFont;
            self.buttonFont                   = [self scaledFontForSize:12.0];
            self.directionsFont               = [self scaledFontForSize:15.0];
            self.directionsFontSmall          = [self scaledFontForSize:12.0];
            self.infoWindowFont               = [self scaledFontForSize:17.0];
            self.infoMessageFont              = [self scaledFontForSize:15.0];
        }
    }
}

@end
