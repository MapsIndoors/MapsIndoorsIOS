//
//  Tracker.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 19/04/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapsIndoors/MapsIndoors.h>


#define kMPEventNameSearch              @"Search"
#define kMPEventNameDirectionsExpanded  @"Directions_Expanded"
#define kMPEventNameRouteCalculated     @"Route_Calculated"
#define kMPEventNameTappedLocationOnMap @"Tapped_Location_On_Map"
#define kMPEventNamePlacesAPI           @"Places_API"
#define kMPEventNameSearchDismissed     @"Search_Dismissed"
#define kMPEventNameOriginSearch        @"Directions_Origin_Search"
#define kMPEventNameDestinationSearch   @"Directions_Destination_Search"


@interface Tracker : NSObject

@property (class, nonatomic) BOOL disabled;

+ (void) setup;
+ (void) trackSearch:(MPLocationQuery*)query results:(NSUInteger)count selectedLocation:(NSString*)selectedLocation;
+ (void) trackDirectionsSearch:(NSString*)queryText results:(NSUInteger)count selectedLocation:(NSString*)selectedLocation isOriginSearch:(BOOL)isOriginSearch;
+ (void) trackEvent:(NSString *)name parameters:(NSDictionary<NSString*,id> *)parameters;
+ (void) trackScreen:(NSString*) screenName;

@end
