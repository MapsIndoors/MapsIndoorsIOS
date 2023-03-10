//
//  MPLogEntry.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/01/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPLogEntry : NSObject

+ (MPLogEntry*) eventWithName: (NSString*) name domain:(NSString*) domain parameters:(nullable NSDictionary<NSString*, NSString*>*) params;
- (NSDictionary*) asDictionary;

@property (nonatomic, strong, readonly) NSString* logType;
@property (nonatomic, strong, readonly) NSDictionary<NSString*, NSString*>* parameters;
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSString* domain;
@property (nonatomic, strong, readonly) NSDate* date;

@end

NS_ASSUME_NONNULL_END
