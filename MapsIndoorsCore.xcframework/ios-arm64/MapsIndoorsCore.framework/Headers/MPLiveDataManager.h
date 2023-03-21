//
//  MPLiveService.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 16/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Enumeration of MPLiveDataManager states.
typedef NS_ENUM(NSInteger, MPLiveDataManagerState) {
    /// The Closed state is the initial state before any subscriptions has been made in the Live Data Manager. It is also the state for when the Live Data Manager lost the connection or intentionally disconnected the Live Update remote services.
    MPLiveDataManagerStateClosed,
    /// The Connecting state reflects the process of creating a valid connection with the Live Update remote services.
    MPLiveDataManagerStateConnecting,
    /// The Connected state relfects the state of being connected to the Live Update remote services.
    MPLiveDataManagerStateConnected,
    /// The Disconnecting state reflects the process of disconnecting the Live Update remote services.
    MPLiveDataManagerStateDisconnecting
};

@class MPLiveUpdateInternal;
@class MPLiveTopicCriteria;
@class MPLiveDataInfo;

#pragma mark - [INTERNAL - DO NOT USE]

/// Live Data Manager Delegate protocol. Conforming to this protocol makes it possible to get Live Updates, state changes, errors and other calls from MPLiveDataManager.
/// > Warning: [INTERNAL - DO NOT USE]
@protocol MPLiveDataManagerDelegate <NSObject>

@optional
/// Called when a Live Update was recieved.
/// - Parameter liveUpdate: The Live Update.
- (void) didReceiveLiveUpdate:(MPLiveUpdateInternal*)liveUpdate;

@optional
/// Called when the state of the Live Data Manager changes.
/// - Parameter state: The new state of the Live Data Manager.
- (void) didUpdateState:(MPLiveDataManagerState)state;

@optional
/// Called when a Topic Criteria has successfully been subscribed for Live Updates.
/// - Parameter topic: The Topic Criteria that was subscribed.
- (void) didSubscribe:(MPLiveTopicCriteria*)topic;

@optional
/// Called when a Topic Criteria has successfully ended subscription for Live Updates.
/// - Parameter topic: The Topic Criteria that was unsubscribed.
- (void) didUnsubscribe:(MPLiveTopicCriteria*)topic;

@optional
/// Called when a subscription fails. The subscription will be not automatically be retried.
/// - Parameter error: The subscription error.
/// - Parameter topic: The Topic Criteria that failed its subscription.
- (void) onSubscriptionError:(NSError*)error topic:(MPLiveTopicCriteria*)topic;

@optional
/// Called when a unsubscription fails. The unsubscription will be not automatically be retried.
/// - Parameter error: The unsubscription error.
/// - Parameter topic: The Topic Criteria that failed its unsubscription.
- (void) onUnsubscriptionError:(NSError*)error topic:(MPLiveTopicCriteria*)topic;

@optional
/// Called when an error occurs. If the error is due to lack of network connectivity, the Live Data Manager will automatically do reconnection attempts.
/// - Parameter error: The unsubscription error.
- (void) onError:(NSError*)error;

@optional
/// Called when information about Liva Data for for a dataset is determined. The information will contain the currently active domain types.
/// - Parameter info: The information about Liva Data for for a dataset.
- (void) didReceiveLiveDataInfo:(MPLiveDataInfo*)info;

@end

/// The Live Data Manager class is the central class for managing Live Update subscriptions.
/// /// > Warning: [INTERNAL - DO NOT USE]
@interface MPLiveDataManager : NSObject
/// Set or get the Live Data Manager Delegate. The delegate recieves all Live Updates, state changes, errors and other calls from the Live Data Manager.
@property (nonatomic, weak) id<MPLiveDataManagerDelegate> delegate;
/// Get the state of the Live Data Manager.
@property (nonatomic, readonly) MPLiveDataManagerState state;
/// Get the currently active and successful subscriptions.
@property (nonatomic, strong, readonly) NSArray<MPLiveTopicCriteria*>* subscriptions;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
/// Get (or create and get) the shared instance of the Live Data Manager.
+ (MPLiveDataManager*) sharedInstance;
/// Subscribe to Live Updates with a given Topic Criteria. If no previous subscriptions have been made, the Live Data Manager will first connect to the Live Update remote services.
/// - Parameter topic: The Topic Criteria.
- (void) subscribe:(MPLiveTopicCriteria*)topic;
/// Unsubscribe to Live Updates with a given Topic Criteria. When the last Topic Criteria is successfully unsubscribed the Live Data Manager will disconnect from the Live Update remote services.
/// - Parameter topic: The Topic Criteria.
- (void) unsubscribe:(MPLiveTopicCriteria*)topic;
/// Unsubscribe all Live Updates. When the last Topic Criteria is successfully unsubscribed the Live Data Manager will disconnect from the Live Update remote services.
- (void) unsubscribeAll;
/// Update Live Data information, including list of active Domain Types for the current dataset.
- (void) updateLiveDataInfo;

@property (nonatomic, strong, readonly, nullable) NSArray<NSString*>* domainTypesForCurrentDataset;

@end

NS_ASSUME_NONNULL_END
