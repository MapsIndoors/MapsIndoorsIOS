//
//  MPPositionProvider.h
//  MapsIndoorSDK
//
//  Created by Daniel Nielsen on 10/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPositionResult.h"

enum MPPositionProviderType {
    GPS_POSITION_PROVIDER = 0,
    MOBILE_NETWORK_POSITION_PROVIDER = 1,
    COMBINED_POSITION_PROVIDER = 2,
    WIFI_POSITION_PROVIDER = 3,
    SENSOR_BASED_POSITION_PROVIDER = 4
};

@protocol MPPositionProviderDelegate <NSObject>

@required
- (void)onPositionUpdate:(MPPositionResult*)positionResult;
- (void)onPositionFailed:(id)provider;
@end

@protocol MPPositionProvider <NSObject>

- (void)startPositioning:(NSString*)arg;
- (void)stopPositioning:(NSString*)arg;
- (void)startPositioningAfter:(int)millis arg:(NSString*)arg;
- (BOOL)isRunning;
@property (weak) id<MPPositionProviderDelegate> delegate;
@property MPPositionResult* latestPositionResult;
@property int providerType;

@end

