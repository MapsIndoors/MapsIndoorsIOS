//
//  MPTransitLineInternal.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"
#import "MPTransitAgencyInternal.h"
#import "MPTransitVehicleInternal.h"
@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Transit line information.
 */
@interface MPTransitLineInternal : JSONModel <MPTransitLine>

/**
 Name contains the full name of this transit line. eg. "7 Avenue Express".
 */
@property (nonatomic, copy, nullable) NSString* name;

/**
 short_name contains the short name of this transit line. This will normally be a line number, such as "M7" or "355".
 */
@property (nonatomic, copy, nullable) NSString* short_name;

/**
 The color commonly used in signage for this transit line. The color will be specified as a hex string such as: #FF0033.
 */
@property (nonatomic, copy, nullable) NSString* color;

/**
 An array of TransitAgency objects that each provide information about the operator of the line.
 */
@property (nonatomic, copy, nullable) NSArray<MPTransitAgencyInternal*>* agencies;

/**
 URL for this transit line as provided by the transit agency.
 */
@property (nonatomic, copy, nullable) NSString* url;

/**
 URL for the icon associated with this line.
 */
@property (nonatomic, copy, nullable) NSString* icon;

/**
 Color of text commonly used for signage of this line. The color will be specified as a hex string.
 */
@property (nonatomic, copy, nullable) NSString* text_color;

/**
 Type of vehicle used on this line. This may include the following properties:
 */
@property (nonatomic, strong, nullable) MPTransitVehicleInternal* vehicle;

@end
