//
//  NSObject+ContentSizeChange.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 28/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "NSObject+ContentSizeChange.h"
#import <KVOController/KVOController.h>


@implementation NSObject (ContentSizeChange)

- (void) mp_onContentSizeChange:(DynamicTextSizeChangeBlock)block {

    [self mp_stopMonitoringContentSizeChanges];

    if ( block ) {
        [self.KVOController observe:DynamicContentSizeHelper.sharedInstance
                            keyPath:@"dynamicTextSize"
                            options:NSKeyValueObservingOptionNew
                              block:^(id _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                                  block( DynamicContentSizeHelper.sharedInstance.dynamicTextSize );
                              }];
    }
}

- (void) mp_stopMonitoringContentSizeChanges {

    [self.KVOController unobserve:DynamicContentSizeHelper.sharedInstance keyPath:@"dynamicTextSize"];
}

- (DynamicTextSize) mp_currentContentSize {

    return DynamicContentSizeHelper.sharedInstance.dynamicTextSize;
}

@end
