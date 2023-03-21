//
//  MPTransitAgencyInternal.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Transit agency information.
 */
@interface MPTransitAgencyInternal : JSONModel <MPTransitAgency>
/**
 Name contains the name of the transit agency.
 */
@property (nonatomic, copy, nullable) NSString* name;
/**
 Url contains the URL for the transit agency.
 */
@property (nonatomic, copy, nullable) NSString* url;
/**
 Phone contains the phone number of the transit agency.
 */
@property (nonatomic, copy, nullable) NSString* phone;

@end
