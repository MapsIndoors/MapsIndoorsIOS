//
//  MPRouteNetworkValueMapper.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 23/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationCoordinate3D.h"


NS_ASSUME_NONNULL_BEGIN


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteNetworkValueMapper : NSObject

+ (nullable instancetype) newMapperWithPropertyNames:(NSArray<NSString*>*)propertynames
                                      propertyValues:(NSArray<NSArray<NSString*>*>*)propertyValues
                                          flagValues:(NSArray<NSString*>*)flagValues;
+ (nullable instancetype) newWithDict:(NSDictionary*)propertyDict flagValues:(NSArray<NSString*>*)flagValues;

- (nullable instancetype) initWithPropertyNames:(NSArray<NSString*>*)propertynames
                                 propertyValues:(NSArray<NSArray<NSString*>*>*)propertyValues
                                     flagValues:(NSArray<NSString*>*)flagValues
                          NS_DESIGNATED_INITIALIZER;
- (nullable instancetype) initWithDict:(NSDictionary*)propertyDict flagValues:(NSArray<NSString*>*)flagValues;
- (nullable instancetype)init NS_UNAVAILABLE;

- (nullable NSArray<NSString*>*) objectForKeyedSubscript:(NSString*)key;

- (nullable NSString*) stringValueForProperty:(NSString*)propertyName withIndex:(NSInteger)ix;
- (nullable NSNumber*) numberValueForProperty:(NSString*)propertyName withIndex:(NSInteger)ix;
- (NSUInteger) indexForProperty:(NSString*)propertyName;
- (BOOL) boolValueForProperty:(NSString*)propertyName usingValue:(NSUInteger)value;

@end


NS_ASSUME_NONNULL_END
