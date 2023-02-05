//
//  MPTransitTime.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Transit time information.
 */
@interface MPTransitTime : JSONModel

/**
 The time specified as a string. The time is displayed in the time zone of the transit stop.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* text;

/**
 The time specified as Unix time, or seconds since midnight, January 1, 1970 UTC.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber<Optional>* value;

/**
 Time zone of this stop/station. The value is the name of the time zone as defined in the IANA Time Zone Database, e.g. "America/New_York".
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* time_zone;

@end
