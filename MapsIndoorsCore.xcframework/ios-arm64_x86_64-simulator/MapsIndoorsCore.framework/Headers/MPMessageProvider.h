//
//  MPMessagesProvider.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"
#import "MPMessageDataset.h"


typedef void(^mpMessageDetailsHandlerBlockType)(MPMessage* _Nullable message, NSError* _Nullable error);
typedef void(^mpMessageListHandlerBlockType)(NSArray<MPMessage>* _Nullable messages, NSError* _Nullable error);

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Messages provider delegate.
 */
@protocol MPMessageProviderDelegate <NSObject>
/**
 Messages data ready event method.
 @param messages The Messages data collection.
 */
@required
- (void) onMessagesReady: (nonnull NSArray<MPMessage>*)messages;

@required
- (void) onMessageDetailsReady: (nonnull MPMessage*)message;
@end

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Messages provider protocol.
 */
@protocol MPMessagesProvider <NSObject>

@property (nonatomic, weak, nullable) id <MPMessageProviderDelegate> delegate;

/**
 Method to initiate fetching of all Messages from the provider.
 @param  handler The handler callback block. Contains the MPMessage object (can be nil) and an NSError object (can be nil).
 */
- (void)getMessagesWithCompletion: (nullable mpMessageListHandlerBlockType) handler;
/**
 Method to query a unique Message from the provider based on an id.
 @param  messageId The MapsIndoors Message ID.
 @param  handler The handler callback block. Contains the MPMessage object (can be nil) and an NSError object (can be nil).
 */
- (void)getMessageWithId:(nonnull NSString*)messageId completionHandler: (nullable mpMessageDetailsHandlerBlockType) handler;
@end


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Messages provider that defines a delegate and a method to initiate fetching of Messages from the provider.
 */
@interface MPMessagesProvider : NSObject<MPMessagesProvider>

@end
