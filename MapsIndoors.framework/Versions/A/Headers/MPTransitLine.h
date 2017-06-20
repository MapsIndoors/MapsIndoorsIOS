//
//  MPTransitLine.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"
#import "MPTransitAgency.h"
#import "MPTransitVehicle.h"

@interface MPTransitLine : JSONModel

//name contains the full name of this transit line. eg. "7 Avenue Express".
@property NSString<Optional>* name;
//short_name contains the short name of this transit line. This will normally be a line number, such as "M7" or "355".
@property NSString<Optional>* short_name;
//color contains the color commonly used in signage for this transit line. The color will be specified as a hex string such as: #FF0033.
@property NSString<Optional>* color;
//agencies contains an array of TransitAgency objects that each provide information about the operator of the line.
@property NSArray<MPTransitAgency>* agencies;
//url contains the URL for this transit line as provided by the transit agency.
@property NSString<Optional>* url;
//icon contains the URL for the icon associated with this line.
@property NSString<Optional>* icon;
//text_color contains the color of text commonly used for signage of this line. The color will be specified as a hex string.
@property NSString<Optional>* text_color;
//vehicle contains the type of vehicle used on this line. This may include the following properties:
@property MPTransitVehicle<Optional>* vehicle;

@end
