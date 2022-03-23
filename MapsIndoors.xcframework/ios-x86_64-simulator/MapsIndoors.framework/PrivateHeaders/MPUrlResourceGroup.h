//
//  MPUrlResourceGroup.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString*   MPUrlResourceGroupType NS_TYPED_ENUM;
extern const MPUrlResourceGroupType _Nonnull MPUrlResourceGroupType_JSON;
extern const MPUrlResourceGroupType _Nonnull MPUrlResourceGroupType_Images;
extern const MPUrlResourceGroupType _Nonnull MPUrlResourceGroupType_ExternalImages;
extern const MPUrlResourceGroupType _Nonnull MPUrlResourceGroupType_MapTiles;


NS_ASSUME_NONNULL_BEGIN

@interface MPUrlResourceGroup : NSObject

- (nullable instancetype) initWithJsonDictionary:(NSDictionary*)dictionary;
- (nullable instancetype) initWithJsonValue:(nullable id<NSObject>)jsonValue;
- (nullable instancetype) initWithType:(MPUrlResourceGroupType)t urls:(NSArray<NSString*>*)urls estimatedSize:(NSInteger)estimatedSize;

@property (nonatomic, strong, readonly, nullable) NSArray<NSString*>*   urls;
@property (nonatomic, assign, readonly) NSInteger                       estimatedSize;
@property (nonatomic, readonly) MPUrlResourceGroupType                  type;

@end

NS_ASSUME_NONNULL_END
