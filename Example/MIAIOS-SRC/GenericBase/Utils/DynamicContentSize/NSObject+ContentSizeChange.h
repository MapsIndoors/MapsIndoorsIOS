//
//  NSObject+ContentSizeChange.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 28/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicContentSizeHelper.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^DynamicTextSizeChangeBlock)( DynamicTextSize dynamicTextSize );


@interface NSObject (ContentSizeChange)

@property (nonatomic, readonly) DynamicTextSize   mp_currentContentSize;

- (void) mp_onContentSizeChange:(nullable DynamicTextSizeChangeBlock)block;
- (void) mp_stopMonitoringContentSizeChanges;

@end

NS_ASSUME_NONNULL_END
