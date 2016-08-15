//
//  MPAppConfigProvider.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 08/08/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPAppData.h"

/**
 * Locations provider delegate.
 */
@protocol MPAppDataProviderDelegate <NSObject>
/**
 * App data ready event method.
 * @param AppData object.
 */
@required
- (void) onAppDataReady: (MPAppData*)appData;

@end


@interface MPAppDataProvider : NSObject

typedef void(^mpAppDataHandlerBlockType)(MPAppData* appData, NSError* error);


@property (weak) id <MPAppDataProviderDelegate> delegate;

- (void)getAppDataAsync:(NSString *)solutionId language: (NSString*) language completionHandler:(mpAppDataHandlerBlockType)handler;
- (void)getAppDataAsync:(NSString *)solutionId language: (NSString*) language;


@end
