//
//  MPLiveDataInfo.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 14/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Live Data information model. Holds the currently active domain types for a dataset.
@interface MPLiveDataInfo : NSObject

/// Get the currently active domain types for a dataset.
@property (nonatomic, strong, readonly) NSArray<NSString*>* activeDomainTypes;

@end

NS_ASSUME_NONNULL_END
