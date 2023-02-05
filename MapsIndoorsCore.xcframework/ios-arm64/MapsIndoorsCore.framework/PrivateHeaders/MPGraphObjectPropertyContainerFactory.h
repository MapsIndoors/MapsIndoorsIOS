//
//  MPGraphObjectPropertyContainerFactory.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 29/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@class MPGraphObjectPropertyContainer;
@class MPRouteNetworkValueMapper;


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPGraphObjectPropertyContainerFactory : NSObject

+ (nullable instancetype) newWithValueMapper:(MPRouteNetworkValueMapper*)valueMapper sharePropertyContainers:(BOOL)sharePropertyContainers;
- (nullable instancetype) initWithValueMapper:(MPRouteNetworkValueMapper*)valueMapper sharePropertyContainers:(BOOL)sharePropertyContainers NS_DESIGNATED_INITIALIZER;
- (nullable instancetype) init NS_UNAVAILABLE;

- (nullable MPGraphObjectPropertyContainer*) propertyContainerForProperties:(NSArray<NSNumber*>*)properties;

@property (nonatomic, readonly) NSUInteger      cacheCount;

@end


NS_ASSUME_NONNULL_END
