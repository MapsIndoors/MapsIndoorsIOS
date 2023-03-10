//
//  MPLogUploadOperation.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/01/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPLogUploadOperation : NSOperation

@property(nonatomic, strong, readonly) NSString* logFilePath;

- (instancetype)initWithLogFilePath: (NSString*) logFilePath apiKey:(NSString*)apiKey;

@property(readonly, getter=isAsynchronous) BOOL asynchronous;
@property(readonly, getter=isExecuting) BOOL executing;
@property(readonly, getter=isFinished) BOOL finished;

@property(readonly) NSInteger responseStatusCode;

@end

NS_ASSUME_NONNULL_END


