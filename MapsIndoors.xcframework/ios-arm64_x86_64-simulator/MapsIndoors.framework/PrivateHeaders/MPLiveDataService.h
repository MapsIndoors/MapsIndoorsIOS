//
//  MPLiveDataService.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 11/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPLiveDataInfo;

NS_ASSUME_NONNULL_BEGIN

typedef void(^mpLiveDataInfoHandlerBlockType)(MPLiveDataInfo* _Nullable info, NSError* _Nullable error);

@interface MPLiveDataService : NSObject

+ (MPLiveDataService*) sharedInstance;
- (void) getLiveDataInfo:(nullable mpLiveDataInfoHandlerBlockType) completion;

@end

NS_ASSUME_NONNULL_END
