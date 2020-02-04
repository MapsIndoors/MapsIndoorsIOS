//
//  Global.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

//Directions rendering
#define kDashSize 4;
#define kLineWidth 4;

#import <Foundation/Foundation.h>
#import <MapsIndoors/MapsIndoors.h>
#import "RoutingData.h"
#import "GPSPositionProvider.h"
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "NSString+Category.h"


@class MPUserRoleManager;


typedef enum {
    WALK = 0,
    BIKE,
    DRIVE,
    TRANSIT
} TRAVEL_MODE;


typedef NS_ENUM( NSUInteger, BuildingTransition ) {
    BuildingTransition_None,
    BuildingTransition_Enter,
    BuildingTransition_Exit
};


@interface Global : NSObject

+ (BuildingTransition) isEnter:(MPRouteLeg *)currentLeg previousLeg:(MPRouteLeg *)previousLeg;
+ (NSString *)stringWithDouble:(double)value;

+ (NSString *) getDistanceString:(double)distanceValue;
+ (NSAttributedString*) localizedStringForDuration:(float) duration travelMode:(NSString*)travelMode;
+ (NSString *) getDurationString:(double)durationValue;
+ (NSString *) getTravelModeString:(TRAVEL_MODE)mode;

+ (BOOL) isUnlikelyDuration:(NSTimeInterval)duration;
+ (BOOL) isUnlikelyDistance:(double)distanceInMeters;

+ (MPSolution*) solution;
+ (void) setSolution:(MPSolution*)value;

+ (MPVenue*) venue;
+ (void) setVenue:(MPVenue*)value;

+ (MPPoint*) initialPosition;
+ (void) setInitialPosition:(MPPoint*)value;

+ (MPLocationQuery*) locationQuery;
+ (void) setLocationQuery:(MPLocationQuery*)value;

+ (MPLocationQuery*) appSchemeLocationQuery;
+ (void) setAppSchemeLocationQuery:(MPLocationQuery*)value;

+ (RoutingData*) routingData;
+ (void) setRoutingData:(RoutingData*)value;

+ (NSString*) travelMode;
+ (void) setTravelMode:(NSString*)travelMode;

+ (BOOL) avoidStairs;
+ (void) setAvoidStairs:(BOOL)avoidStairs;

+ (MPAppData*) appData;
+ (void) setAppData:(MPAppData*)value;

+ (void) setupPositioning;

+ (NSString*)getIconUrlForType: (NSString*)typeName;

+ (MPLocationDisplayRule*)getDisplayRuleForType:(NSString*) typeName;

+ (NSString*) getAddressForLocation: (MPLocation*) location;

+ (NSString*) getBuildingLabelFromRouteLocation: (MPRouteCoordinate*)location;

+ (CLLocationDirection)getHeadingBetweenTwoLocation:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;
+ (CLLocationDistance)getDistanceFromCoordinate:(CLLocationCoordinate2D)coordinate1 toCoordinate:(CLLocationCoordinate2D)coordinate2;
+ (NSString*) getPropertyFromPlist:(NSString*)key;

#pragma mark - User roles
+ (MPUserRoleManager*) userRoleManager;

@end
