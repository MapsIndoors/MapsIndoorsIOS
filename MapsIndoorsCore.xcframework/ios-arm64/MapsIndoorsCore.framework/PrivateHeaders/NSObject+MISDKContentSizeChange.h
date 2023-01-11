//
//  NSObject+ContentSizeChange.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 28/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDynamicContentSizeHelper.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^MPDynamicTextSizeChangeBlock)( MPDynamicTextSize dynamicTextSize );


@interface NSObject (ContentSizeChange)

@property (nonatomic, readonly) MPDynamicTextSize mp_currentContentSize;
@property (nullable) MPDynamicTextSizeChangeBlock mp_currentContentSizeChangeBlock;

- (void) mpsdk_onContentSizeChange:(nullable MPDynamicTextSizeChangeBlock)block;
- (void) mpsdk_stopMonitoringContentSizeChanges;

@end

NS_ASSUME_NONNULL_END
