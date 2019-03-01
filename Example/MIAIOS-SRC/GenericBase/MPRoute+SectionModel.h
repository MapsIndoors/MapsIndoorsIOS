//
//  MPRoute+SectionModel.h
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 27/06/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>
#import "NSString+TRAVEL_MODE.h"

@class SectionModel;


@interface MPRoute (SectionModel)

- (NSArray<SectionModel*>*) sectionModelsForRequestTravelMode:(TRAVEL_MODE)requestTravelMode;

@end
