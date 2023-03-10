//
//  MPDataSetCacheTask.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 05/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPDataSetCacheItem;
@class MPDataSetCacheWorkScheduler;


typedef NS_ENUM( NSUInteger, MPDataSetCacheTaskStatus ) {
    MPDataSetCacheTaskStatus_Pending,
    MPDataSetCacheTaskStatus_Ready,
    MPDataSetCacheTaskStatus_Executing,
    MPDataSetCacheTaskStatus_Cancelled,
    MPDataSetCacheTaskStatus_Finished,
    MPDataSetCacheTaskStatus_Failed
};

typedef NS_ENUM(NSUInteger, MPDataSetCacheTaskPriority ) {
    MPDataSetCacheTaskPriority_Background,
    MPDataSetCacheTaskPriority_Low,
    MPDataSetCacheTaskPriority_Normal,
    MPDataSetCacheTaskPriority_High
};


NS_ASSUME_NONNULL_BEGIN

@protocol  MPDataSetCacheTaskDelegate;


@interface MPDataSetCacheTask : NSOperation

@property (nonatomic, weak, readonly)   id                              owner;
@property (nonatomic, weak)             MPDataSetCacheWorkScheduler*    scheduler;
@property (nonatomic, weak)             id<MPDataSetCacheTaskDelegate>  delegate;
@property (nonatomic)                   MPDataSetCacheTaskStatus        status;
@property (nonatomic)                   MPDataSetCacheTaskPriority      priority;
@property (nonatomic)                   BOOL                            isCurrentDataSet;
@property (nonatomic, strong, nullable) NSError*                        error;
@property (nonatomic, readonly)         NSTimeInterval                  duration;       // Duration of task execution
@property (nonatomic, readonly)         NSTimeInterval                  waitingTime;    // Duration of waiting time before execution started

#pragma mark - Initialization
- (instancetype) initWithOwner:(id)owner;

#pragma mark - Override points and helpers for subclasses
- (void) executeWork;
- (void) cancelWork;

#pragma mark - Utils
- (NSArray<NSError*>*) accumulateErrors;
- (void) debugLog:(NSString*)msg;

@end


@protocol MPDataSetCacheTaskDelegate <NSObject>

@required
- (void) workItemStarted:(MPDataSetCacheTask*)item;

@required
- (void) workItem:(MPDataSetCacheTask*)item finishedWithWithStatus:(MPDataSetCacheTaskStatus)status;

@end

NS_ASSUME_NONNULL_END
