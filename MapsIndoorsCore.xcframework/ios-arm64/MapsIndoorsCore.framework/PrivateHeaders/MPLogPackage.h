//
//  MPLogPackage.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/01/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPLogEntry;
@class MPLogSessionData;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLogPackage : NSObject

- (instancetype)initWithApiKey:apiKey sessionId:(NSString*)sessId sessionStartDate:(NSDate*)startDate logEntries:(NSArray<MPLogEntry*>*)entries component: (NSString*) comp componentVersion:(NSString*) version;
- (NSData*) asData;
+ (NSString *)apiKeyFromFilename:(NSString*)filename;

@property (nonatomic, strong, readonly) NSString* filename;
@property (nonatomic, strong, readonly) NSString* packageId;
@property (nonatomic, strong, readonly) NSString* apiKey;
@property (nonatomic, strong, readonly) MPLogSessionData* sessionData;
@property (nonatomic, strong, readonly) NSArray<MPLogEntry*>* entries;

@end

NS_ASSUME_NONNULL_END
