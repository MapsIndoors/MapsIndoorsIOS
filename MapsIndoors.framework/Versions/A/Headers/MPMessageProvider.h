//
//  MPMessagesProvider.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMessageDataset.h"

typedef void(^mpMessageDetailsHandlerBlockType)(MPMessage* message, NSError* error);
typedef void(^mpMessageListHandlerBlockType)(NSArray<MPMessage>* messages, NSError* error);

/**
 Messages provider delegate.
 */
@protocol MPMessageProviderDelegate <NSObject>
/**
 Messages data ready event method.
 @param  MessagesCollection The Messages data collection.
 */
@required
- (void) onMessagesReady: (NSArray<MPMessage>*)messages;

@required
- (void) onMessageDetailsReady: (MPMessage*)message;
@end
/**
 Messages provider protocol.
 */
@protocol MPMessagesProvider <NSObject>

@property (weak) id <MPMessageProviderDelegate> delegate;

/**
 Method to initiate fetching of all Messages from the provider in a specific translation.
 @param  solutionId The MapsIndoors solution ID.
 @param  language The language code. Must be one of the MapsIndoors solutions supported content languages.
 @param  handler The handler callback block. Contains the MPMessage object (can be nil) and an NSError object (can be nil).
 */
@required
- (void)getMessagesAsync: (NSString*) solutionId language: (NSString*) language completionHandler: (mpMessageListHandlerBlockType) handler;
/**
 Method to query a unique Message from the provider based on an id.
 @param  solutionId The MapsIndoors solution ID.
 @param  MessageId The MapsIndoors Message ID.
 @param  language The language code. Must be one of the MapsIndoors solutions supported content languages.
 @param  handler The handler callback block. Contains the MPMessage object (can be nil) and an NSError object (can be nil).
 */
@required
- (void)getMessageDetailsAsync: (NSString*) solutionId withId:(NSString*)messageId language: (NSString*) language completionHandler: (mpMessageDetailsHandlerBlockType) handler;
@end


/**
 Messages provider that defines a delegate and a method to initiate fetching of Messages from the provider.
 */
@interface MPMessagesProvider : NSObject<MPMessagesProvider>
/**
 Messages provider delegate.
 */
@property (weak) id <MPMessageProviderDelegate> delegate;

- (id)init;

/**
 Method to initiate fetching of all Messages from the provider in a specific translation.
 @param  solutionId The MapsIndoors solution ID.
 @param  language The language code. Must be one of the MapsIndoors solutions supported content languages.
 */
- (void)getMessagesAsync: (NSString*) solutionId language: (NSString*) language completionHandler: (mpMessageListHandlerBlockType) handler;
/**
 Method to query a unique Message from the provider based on an id.
 @param  solutionId The MapsIndoors solution ID.
 @param  MessageId The MapsIndoors Message ID.
 @param  language The language code. Must be one of the MapsIndoors solutions supported content languages.
 @param  handler The handler callback block. Contains the MPMessage object (can be nil) and an NSError object (can be nil).
 */
- (void)getMessageDetailsAsync: (NSString*) solutionId withId:(NSString*)messageId language: (NSString*) language completionHandler: (mpMessageDetailsHandlerBlockType) handler;


@end
