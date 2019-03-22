//
//  BuildingInfoCache.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 21/09/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import "BuildingInfoCache.h"
#import <MapsIndoors/MapsIndoors.h>


#define CHK_MAIN_THREAD     NSAssert( [NSThread currentThread].isMainThread, @"BuildingInfoCache is main thread only" );


@interface BuildingInfoCache ()

@property (nonatomic, strong, readonly) NSString*               solutionId;
@property (nonatomic, strong, readonly) NSString*               language;
@property (nonatomic, strong) MPVenueProvider*                  venueProvider;
@property (nonatomic, strong, readwrite) NSArray<MPBuilding*>*  buildings;

@end


@implementation BuildingInfoCache

+ (instancetype) sharedInstance {

    CHK_MAIN_THREAD
    
    static BuildingInfoCache* _sharedBuildingInfoCache = nil;
    
    if ( _sharedBuildingInfoCache == nil ) {
        _sharedBuildingInfoCache = [BuildingInfoCache new];
    }
    
    return _sharedBuildingInfoCache;
}

- (instancetype)init {
    
    CHK_MAIN_THREAD

    NSString*   solutionId = [MapsIndoors getMapsIndoorsAPIKey];
    if ( solutionId.length ) {
        
        self = [super init];
        if ( self ) {
            [self fetchBuildings];
        }
    }
    
    return self;
}

- (MPVenueProvider *)venueProvider {
    
    if ( _venueProvider == nil ) {
        _venueProvider = [MPVenueProvider new];
    }
    return _venueProvider;
}

- (NSString*) solutionId {
    
    return [MapsIndoors getMapsIndoorsAPIKey];
}

- (NSString*) language {
    
    return [MapsIndoors getLanguage];
}

- (void) fetchBuildings {
    
    if ( self.buildings == nil ) {
        
        self.buildings = @[];       // Placeholder until getBuildingsAsync returns.
        
        [self.venueProvider getBuildingsWithCompletion:^(NSArray<MPBuilding *> * _Nullable buildings, NSError * _Nullable error) {
            if (error == nil) {
                self.buildings = buildings;
            }
        }];
    }
}

- (MPBuilding*) buildingFromAdministrativeId:(NSString*)administrativeId {

    NSPredicate*            bPredicate = [NSPredicate predicateWithFormat:@"administrativeId LIKE[c] %@", administrativeId];
    NSArray<MPBuilding*>*   match = [self.buildings filteredArrayUsingPredicate:bPredicate];
    
    return [match firstObject];
}

@end
