//
//  MPOpeningHoursModule.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 12/4/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModelArray.h>
#import "MPOpeningHours.h"

/**
 * Protocol specification
 */
@protocol MPOpeningHours
@end
/**
 * Opening hours module array data model.
 */
@interface MPOpeningHoursModule : JSONModelArray<MPOpeningHours>

@end
