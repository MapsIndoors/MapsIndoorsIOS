//
//  POIData.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "POIData.h"
#import "Global.h"
#import "LocalizedStrings.h"
@import MaterialControls;

@implementation POIData {
    MDSnackbar* _bar;
}

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
        [super getLocationsUsingQueryAsync:locationQuery language:language completionHandler:^(MPLocationDataset *locationData, NSError *error) {
            if (error && !_bar.isShowing) {
                _bar = [[MDSnackbar alloc] initWithText:kLangCouldNotFindLocations actionTitle:@"" duration:4.0];
                [_bar show];
            }
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsRequestStarted" object: nil];
    }
}

- (void)getLocationDetailsAsync:(NSString *)solutionId withId:(NSString *)locationId language:(NSString *)language {
    [super getLocationDetailsAsync:solutionId withId:locationId language:language completionHandler:^(MPLocation *location, NSError *error) {
        if (error && !_bar.isShowing) {
            _bar = [[MDSnackbar alloc] initWithText:kLangCouldNotFindLocationDetails actionTitle:@"" duration:4.0];
            [_bar show];
        }
    }];
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
