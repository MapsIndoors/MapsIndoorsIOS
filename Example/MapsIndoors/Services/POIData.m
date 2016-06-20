//
//  POIData.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "POIData.h"
#import "Global.h"

@implementation POIData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        _locationQuery = [[MPLocationQuery alloc] init];
        _locationQuery.solutionId = Global.solutionId;
    }
    return self;
}

- (void)getLocationsUsingQueryAsync:(MPLocationQuery *)locationQuery language:(NSString *)language {
    _locationQuery = locationQuery;
    if (locationQuery) {
        [super getLocationsUsingQueryAsync:locationQuery language:language];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsRequestStarted" object: nil];
    }
}

- (void)getLocationDetailsAsync:(NSString *)solutionId withId:(NSString *)locationId language:(NSString *)language {
    [super getLocationDetailsAsync:solutionId withId:locationId language:language];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsRequestStarted" object: nil];
}

- (void)onLocationDetailsReady:(MPLocation *)location {
    _latestLocation = location;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationDetailsReady" object: location];
}

- (void)onLocationsReady:(MPLocationDataset *)locationData {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsDataReady" object: locationData.list];
}

@end
