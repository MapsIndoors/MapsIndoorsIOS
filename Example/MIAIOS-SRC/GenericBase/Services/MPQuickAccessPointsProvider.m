//
//  MPQuickAccessPointsProvider.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 18/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPQuickAccessPointsProvider.h"
#import <MapsIndoors/MapsIndoors.h>


@interface MPQuickAccessPointsProvider ()

@property (nonatomic, strong) NSMutableDictionary<NSString*,MPLocationDataset*>*    quickAccessPointsForVenueCache;
@property (nonatomic, strong) MPLocationsProvider*                                  locationsProvider;

@end


@implementation MPQuickAccessPointsProvider

+ (instancetype) sharedInstance {
    
    static MPQuickAccessPointsProvider* _sharedQuickAccessPointsProvider = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedQuickAccessPointsProvider = [MPQuickAccessPointsProvider new];
    });
    
    return _sharedQuickAccessPointsProvider;
}

- (instancetype) init {
    
    self = [super init];
    if (self) {
        _quickAccessPointsForVenueCache = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (MPLocationsProvider*) locationsProvider {
    
    if ( _locationsProvider == nil ) {
        _locationsProvider = [MPLocationsProvider new];
    }
    return _locationsProvider;
}

- (void) getQuickAccessPointsForVenue:(NSString*)venueKey completion:(QuickAccessPointsHandlerBlock)handler {

    if ( handler ) {
        
        NSString*           cacheKey = venueKey ?: @"-all-venues-";
        MPLocationDataset*  cachedResult = self.quickAccessPointsForVenueCache[cacheKey];
        BOOL                callbackExecuted = NO;
        
        // Provide cached result ASAP:
        if ( cachedResult ) {
            handler( cachedResult, nil );
            callbackExecuted = YES;
        }
        
        // Fetch or refresh the cache:
        MPLocationQuery*    q = [MPLocationQuery new];
        if ( venueKey ) {
            q.venue = venueKey;
        }
        q.categories = @[ @"startpoint" ];      // "startpoint": magic category indicating a MPLocation is a quick access point
        
        [self.locationsProvider getLocationsUsingQuery:q completionHandler:^(MPLocationDataset *locationData, NSError *error) {
            
            if ( !error && locationData ) {
                self.quickAccessPointsForVenueCache[ cacheKey ] = locationData;
            }
            
            if ( callbackExecuted == NO ) {
                handler( locationData, error );
            }
        }];
    }
}

@end
