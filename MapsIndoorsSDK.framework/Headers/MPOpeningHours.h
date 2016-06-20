//
//  MPOpeningHours.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 12/4/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JSONModel;

/**
 * Opening hours item data model.
 */
@interface MPOpeningHours : JSONModel
/**
 * Day of week integer. 0-6 compares to Monday-Sunday
 */
@property int dayOfWeek;
/**
 * Opening time of day - as free string representation.
 */
@property NSString* opens;
/**
 * Closing time of day - as free string representation.
 */
@property NSString* close;
/**
 * Start date for this opening hours item.
 */
@property NSDate* validFrom;
/**
 * End date for this opening hours item.
 */
@property NSDate* validThrough;

@end
