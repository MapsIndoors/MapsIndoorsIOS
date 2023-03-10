//
//  MPUrlResourceCollection.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPUrlResourceGroup.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPUrlResourceCollection : NSObject

- (instancetype)initWithJsonDictionary:(NSDictionary*)dictionary;
- (nullable instancetype)initWithJsonValue:(nullable id<NSObject>)jsonValue;

@property (nonatomic, strong, readonly) NSDictionary<MPUrlResourceGroupType,MPUrlResourceGroup*>*   resources;
@property (nonatomic, assign, readonly) NSInteger totalEstimatedSize;
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSString* datasetId;

@end

NS_ASSUME_NONNULL_END
