//
//  MPTransitLine.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

@import JSONModel;
#import "MPTransitAgency.h"
#import "MPTransitVehicle.h"

/**
 Transit line information.
 */
@interface MPTransitLine : JSONModel

/**
 Name contains the full name of this transit line. eg. "7 Avenue Express".
 */
@property (nonatomic, strong, nullable) NSString<Optional>* name;

/**
 short_name contains the short name of this transit line. This will normally be a line number, such as "M7" or "355".
 */
@property (nonatomic, strong, nullable) NSString<Optional>* short_name;

/**
 The color commonly used in signage for this transit line. The color will be specified as a hex string such as: #FF0033.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* color;

/**
 An array of TransitAgency objects that each provide information about the operator of the line.
 */
@property (nonatomic, strong, nullable) NSArray<MPTransitAgency*><MPTransitAgency>* agencies;

/**
 URL for this transit line as provided by the transit agency.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* url;

/**
 URL for the icon associated with this line.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* icon;

/**
 Color of text commonly used for signage of this line. The color will be specified as a hex string.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* text_color;

/**
 Type of vehicle used on this line. This may include the following properties:
 */
@property (nonatomic, strong, nullable) MPTransitVehicle<Optional>* vehicle;

@end
