//
//  MPGraphObjectBase.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 24/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPGraphNodePropertyProtocol.h"
#import "MPGraphEdgePropertyProtocol.h"


NS_ASSUME_NONNULL_BEGIN


@class MPRouteNetworkValueMapper;


@interface MPGraphObjectPropertyContainer : NSObject <MPGraphNodePropertyProtocol, MPGraphEdgePropertyProtocol>

@property (nonatomic, readonly, strong, nullable) NSArray<NSNumber*>*         properties;
@property (nonatomic, readonly, strong, nullable) MPRouteNetworkValueMapper*  valueMapper;

+ (nullable instancetype) newWithProperties:(nullable NSArray<NSNumber*>*)properties valueMapper:(nullable MPRouteNetworkValueMapper*)valueMapper;
- (nullable instancetype) initWithProperties:(nullable NSArray<NSNumber*>*)properties valueMapper:(nullable MPRouteNetworkValueMapper*)valueMapper;
- (nullable instancetype) init NS_UNAVAILABLE;

- (BOOL) isEqualToGraphObjectPropertyContainer:(MPGraphObjectPropertyContainer*)otherObject;

- (nullable NSString*) stringValueForProperty:(NSString*)propertyName;
- (nullable NSNumber*) numberValueForProperty:(NSString*)propertyName;
- (BOOL) boolValueForProperty:(NSString*)propertyName;

@end


NS_ASSUME_NONNULL_END
