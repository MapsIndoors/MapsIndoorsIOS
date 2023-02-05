//
//  MPLogger.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/01/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLogEntry.h"
#import "MPLoggingConfig.h"
#import "MPLogEvent.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLogger : NSObject

@property (nonatomic, strong, readwrite) NSString* apiKey;
@property (nonatomic, readwrite) BOOL uploadingEnabled;
@property (nonatomic, strong, readwrite) MPLoggingConfig* configuration;

+ (MPLogger*) sharedInstance;
- (void) log:(MPLogEntry*) logEntry;
+ (void) log:(MPLogEntry*) logEntry;
+ (void) eventWithName: (MPLogEvent) name domain:(MPLogDomain) domain;
+ (void) eventWithName: (MPLogEvent) name domain:(MPLogDomain) domain parameters:(nullable NSDictionary<NSString*, NSString*>*) params;
- (void) uploadLog;

@end

NS_ASSUME_NONNULL_END
