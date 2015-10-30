//
//  POIData.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoorsSDK/MapsIndoorsSDK.h>

@interface POIData : MPLocationsProvider<MPLocationsProviderDelegate>

@property (readonly) MPLocationQuery* locationQuery;
@property (readonly) MPLocation* latestLocation;

@end
