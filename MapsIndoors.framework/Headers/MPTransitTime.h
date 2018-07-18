//
//  MPTransitTime.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "MPJSONModel.h"

@interface MPTransitTime : MPJSONModel
//the time specified as a string. The time is displayed in the time zone of the transit stop.
@property (nonatomic, strong, nullable) NSString<Optional>* text;
//value the time specified as Unix time, or seconds since midnight, January 1, 1970 UTC.
@property (nonatomic, strong, nullable) NSNumber<Optional>* value;
//The time_zone contains the time zone of this stop/station. The value is the name of the time zone as defined in the IANA Time Zone Database, e.g. "America/New_York".
@property (nonatomic, strong, nullable) NSString<Optional>* time_zone;

@end
