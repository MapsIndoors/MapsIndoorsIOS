//
//  MPCachedLocationsProvider.h
//  MapsIndoorSDK
//
//  Created by Daniel Nielsen on 05/08/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPLocationsProvider.h"

@interface MPCachedLocationsProvider : NSObject<MPLocationsProvider, MPLocationsProviderDelegate>

- (id)initWithSiteName:(NSString*)siteName displayRules:(MPLocationDisplayRuleset*)rules language: (NSString*)language;

@end
