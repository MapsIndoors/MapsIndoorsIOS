//
//  MPAppDataProvider.h
//  Indoor
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPAppData.h"

@protocol MPAppDataProviderDelegate <NSObject>
/**
 * AppData data ready event method.
 * @param appData The AppData object.
 */
@required
- (void) onAppDataReady: (MPAppData*)appData;
@end

@interface MPAppDataProvider : NSObject

@property (weak) id <MPAppDataProviderDelegate> delegate;

- (void)getAppDataAsync: (NSString*) arg;

@end