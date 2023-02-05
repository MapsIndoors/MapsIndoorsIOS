//
//  MPLogSessionData.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/01/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLogSessionData : NSObject

- (instancetype)initWithSessionId:(NSString*)sessId startDate:(NSDate*) date component: (NSString*) component componentVersion:(NSString*) componentVersion;
- (NSDictionary*) asDictionary;

@property (nonatomic, strong, readonly) NSString* sessionId;
@property (nonatomic, strong, readonly) NSDate* sessionStartDate;
@property (nonatomic, strong, readonly) NSString* deviceBrand;
@property (nonatomic, strong, readonly) NSString* deviceModel;
@property (nonatomic, strong, readonly) NSString* deviceType;
@property (nonatomic, strong, readonly) NSString* deviceUserAgent;
@property (nonatomic, strong, readonly) NSString* deviceOS;
@property (nonatomic, strong, readonly) NSString* deviceOSVersion;
@property (nonatomic, strong, readonly) NSString* component;
@property (nonatomic, strong, readonly) NSString* componentVersion;
@property (nonatomic, strong, readonly) NSString* hostApplicationName;

@end

NS_ASSUME_NONNULL_END
