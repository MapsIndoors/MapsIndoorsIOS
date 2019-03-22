//
//  DynamicContentSizeHelper.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 28/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "DynamicContentSizeHelper.h"
#import <UIKit/UIKit.h>


@interface DynamicContentSizeHelper ()

@property (nonatomic, readwrite) DynamicTextSize      dynamicTextSize;

@end


@implementation DynamicContentSizeHelper

+ (instancetype) sharedInstance {
    
    static DynamicContentSizeHelper*  _sharedDynamicContentSizeHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDynamicContentSizeHelper = [DynamicContentSizeHelper new];
    });

    return _sharedDynamicContentSizeHelper;
}

- (instancetype) init {

    self = [super init];
    if (self) {
        [self updateContentSize];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContentSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }

    return self;
}

- (void) setDynamicTextSize:(DynamicTextSize)dynamicTextSize {

    if ( _dynamicTextSize != dynamicTextSize ) {
        NSLog( @"DynamicContentSizeHelper: %@ => %@", [self.class nameForTextSize:_dynamicTextSize], [self.class nameForTextSize:dynamicTextSize] );
        _dynamicTextSize = dynamicTextSize;
    }
}

- (void) updateContentSize {

    DynamicTextSize         textSize = self.dynamicTextSize;
    UIContentSizeCategory   cat = [UIApplication sharedApplication].preferredContentSizeCategory;

    #define _X(from,to)      if ( [cat isEqualToString:from] )     textSize = to;

    _X( UIContentSizeCategoryExtraSmall                       , DynamicTextSize_XS   );
    _X( UIContentSizeCategorySmall                            , DynamicTextSize_S    );
    _X( UIContentSizeCategoryMedium                           , DynamicTextSize_M    );
    _X( UIContentSizeCategoryLarge                            , DynamicTextSize_L    );
    _X( UIContentSizeCategoryExtraLarge                       , DynamicTextSize_XL   );
    _X( UIContentSizeCategoryExtraExtraLarge                  , DynamicTextSize_XXL  );
    _X( UIContentSizeCategoryExtraExtraExtraLarge             , DynamicTextSize_XXXL );

    _X( UIContentSizeCategoryAccessibilityMedium              , DynamicTextSize_Accessibility_M    );
    _X( UIContentSizeCategoryAccessibilityLarge               , DynamicTextSize_Accessibility_L    );
    _X( UIContentSizeCategoryAccessibilityExtraLarge          , DynamicTextSize_Accessibility_XL   );
    _X( UIContentSizeCategoryAccessibilityExtraExtraLarge     , DynamicTextSize_Accessibility_XXL  );
    _X( UIContentSizeCategoryAccessibilityExtraExtraExtraLarge, DynamicTextSize_Accessibility_XXXL );

    #undef _X

    if ( self.updateBlock ) {
        self.updateBlock( textSize );
    }
    
    self.dynamicTextSize = textSize;
}

+ (NSString*) nameForTextSize:(DynamicTextSize)textSize {

    #define _X(eNUM)        case eNUM:  return @"" #eNUM;
    switch ( textSize ) {
        _X(DynamicTextSize_Unknown)
        _X(DynamicTextSize_XS)
        _X(DynamicTextSize_S)
        _X(DynamicTextSize_M)
        _X(DynamicTextSize_L)
        _X(DynamicTextSize_XL)
        _X(DynamicTextSize_XXL)
        _X(DynamicTextSize_XXXL)
        _X(DynamicTextSize_Accessibility_M)
        _X(DynamicTextSize_Accessibility_L)
        _X(DynamicTextSize_Accessibility_XL)
        _X(DynamicTextSize_Accessibility_XXL)
        _X(DynamicTextSize_Accessibility_XXXL)
    }
    #undef _X

    return [NSString stringWithFormat:@"DynamicTextSize=%@", @(textSize)];
}

@end
