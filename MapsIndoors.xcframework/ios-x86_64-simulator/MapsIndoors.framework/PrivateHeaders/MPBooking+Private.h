//
//  MPBooking.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPBooking.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPBooking ()

@property (nonatomic, strong, readwrite, nullable) NSString*    bookingId;
@property (nonatomic, strong, readwrite, nullable) NSString*    locationId;
@property (nonatomic,         readwrite          ) BOOL         isManaged;

+ (instancetype) newWithDictionary:(NSDictionary*)dict;
- (instancetype) initWithDictionary:(NSDictionary*)dict;
- (void) updateFromDictionary:(NSDictionary*)dict;

- (NSDictionary*) asDictionary;

@end

NS_ASSUME_NONNULL_END
