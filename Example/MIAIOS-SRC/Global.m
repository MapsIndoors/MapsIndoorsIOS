//
//  Global.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "Global.h"
#import <MapsIndoors/MapsIndoors.h>
#import "GPSPositionProvider.h"
#import "BeaconPositionProvider.h"
#import "LocalizedStrings.h"
#import "AppVariantData.h"
#import <MapKit/MapKit.h>
#import "NSString+TRAVEL_MODE.h"
#import "MPUserRoleManager.h"


#define METERS_TO_FEET  3.2808399
#define METERS_TO_MILES 0.000621371192
#define METERS_CUTOFF   100
#define FEET_CUTOFF     3281
#define FEET_IN_MILES   5280
#define SECONDS_PER_24H (60*60*24)
#define LIKELY_DURATION_LIMIT_DAYS      1000
#define LIKELY_DISTANCE_LIMIT_KM        50000       // Earth circumference is ~40000


@implementation Global

+ (CLLocationDistance)getDistanceFromCoordinate:(CLLocationCoordinate2D)coordinate1 toCoordinate:(CLLocationCoordinate2D)coordinate2 {
    
    CLLocation * location1 = [[CLLocation alloc] initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
    CLLocation * location2 = [[CLLocation alloc] initWithLatitude:coordinate2.latitude longitude:coordinate2.longitude];
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    
    return  distance;
}

+ (BuildingTransition)isEnter:(MPRouteLeg *)currentLeg previousLeg:(MPRouteLeg *)previousLeg {
    
    MPRouteStep *lastStep = previousLeg.steps.lastObject;
    MPRouteStep *firstStep = currentLeg.steps.firstObject;
    
    if ((lastStep.routeContext == nil || [lastStep.routeContext isEqualToString:@"OutsideOnVenue"])  && [firstStep.routeContext isEqualToString:@"InsideBuilding"]) {
        
        return BuildingTransition_Enter;
        
    } else if ([lastStep.routeContext isEqualToString:@"InsideBuilding"] && (firstStep.routeContext == nil || [firstStep.routeContext isEqualToString:@"OutsideOnVenue"])) {
        
        return BuildingTransition_Exit;
    }
    
    return BuildingTransition_None;
}

+ (NSString*) getDurationString:(double)durationValue {

    // Round up to nearest minute
    int secs = durationValue;
    if ( secs % 60 ) {
        secs += 60 - (secs % 60);
    }

    NSDateComponentsFormatter*  formatter = [NSDateComponentsFormatter new];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleShort;
    formatter.allowedUnits = durationValue > SECONDS_PER_24H ? kCFCalendarUnitDay | kCFCalendarUnitHour : kCFCalendarUnitHour | kCFCalendarUnitMinute;
    
    return [formatter stringFromTimeInterval:secs];
}

+ (NSAttributedString*) localizedStringForDuration:(float)duration travelMode:(NSString*) travelMode {
    
    NSString*   text = [self getDurationString:duration];
    NSUInteger  lengthOfDurationPart = text.length;
    NSRange     range = NSMakeRange(0, lengthOfDurationPart);
    
    if ([travelMode isEqualToString:@"walking"]) {
        text = [NSString stringWithFormat:@"%@ %@", text, kLangByWalk];
    } else if ([travelMode isEqualToString:@"driving"]) {
        text = [NSString stringWithFormat:@"%@ %@", text, kLangByCar];
    } else if ([travelMode isEqualToString:@"transit"]) {
        text = [NSString stringWithFormat:@"%@ %@", text, kLangByTransit];
    } else if ([travelMode isEqualToString:@"bicycling"]) {
        text = [NSString stringWithFormat:@"%@ %@", text, kLangByCycling];
    }
    
    // Create the attributes
    const CGFloat   fontSize = 15;
    NSDictionary*   attrs = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize], NSForegroundColorAttributeName:[UIColor darkGrayColor] };
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    if ( range.length > 0 ) {
        [attributedText setAttributes:attrs range:range];
    }
    
    return attributedText;
}

+ (NSString *) getDistanceString:(double)distanceValue {

    NSString*   s;

    if ( distanceValue < 1000 ) {
        NSLengthFormatter*  formatter = [NSLengthFormatter new];
        formatter.numberFormatter.maximumFractionDigits = 0;

        s = [formatter stringFromMeters:distanceValue];

    } else {
        MKDistanceFormatter*    formatter = [MKDistanceFormatter new];
        formatter.unitStyle = MKDistanceFormatterUnitStyleAbbreviated;

        s = [formatter stringFromDistance:distanceValue];
    }

    return s;
}

+ (BOOL) isUnlikelyDuration:(NSTimeInterval)duration {

    double days = duration / SECONDS_PER_24H;
    
    return days > LIKELY_DURATION_LIMIT_DAYS;
}

+ (BOOL) isUnlikelyDistance:(double)distanceInMeters {

    return (distanceInMeters / 1000) > LIKELY_DISTANCE_LIMIT_KM;
}


// Return a string of the number to one decimal place and with commas & periods based on the locale.
+ (NSString *)stringWithDouble:(double)value {
    return [self stringWithDouble:value numDecimals:1];
}

+ (NSString *)stringWithDouble:(double)value numDecimals:(NSUInteger)numDecimals {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:numDecimals];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

+ (NSString *)getTravelModeString:(TRAVEL_MODE)mode {
    
    switch (mode) {
        case WALK:
            return NSLocalizedString(@"Walk",);
        case BIKE:
            return NSLocalizedString(@"Bike",);
        case DRIVE:
            return NSLocalizedString(@"Drive",);
        case TRANSIT:
            return NSLocalizedString(@"Transit",);
    }
    
    return NSLocalizedString(@"Walk",);
}


static MPSolution* solution;
+ (MPSolution*) solution {
    @synchronized(self) {
        return solution;
    }
}

+ (void) setSolution:(MPSolution*)value {
    @synchronized(self) {
        solution = value;
    }
    [self setUserRoleManager:[MPUserRoleManager new]];
}


static MPVenue* venue;
+ (MPVenue*) venue {
    @synchronized(self) {
        return venue;
    }
}

+ (void) setVenue:(MPVenue*)value {
    @synchronized(self) {
        venue = value;
    }
}


static MPPoint* initialPosition;
+ (MPPoint*) initialPosition {
    @synchronized(self) {
        return initialPosition;
    }
}

+ (void) setInitialPosition:(MPPoint*)value {
    @synchronized(self) {
        initialPosition = value;
    }
}


static RoutingData* routingData;
+ (RoutingData*) routingData {
    @synchronized(self) {
        return routingData;
    }
}

+ (void) setRoutingData:(RoutingData*)value {
    @synchronized(self) {
        routingData = value;
    }
}


+ (NSString*) travelMode {
    NSString* travelMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"travelMode"];
    return travelMode ?: @"walking";
}

+ (void) setTravelMode:(NSString*)travelMode {
    NSString*   validatedTravelMode = [NSString stringFromTravelMode: [travelMode as_TRAVEL_MODE] ];
    [[NSUserDefaults standardUserDefaults] setObject:validatedTravelMode forKey:@"travelMode"];
}


+ (BOOL) avoidStairs {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"avoidStairs"];
}

+ (void) setAvoidStairs:(BOOL)avoidStairs {
    [[NSUserDefaults standardUserDefaults] setBool:avoidStairs forKey:@"avoidStairs"];
}


static MPAppData* appData;
+ (MPAppData*) appData {
    @synchronized(self) {
        return appData;
    }
}

+ (void) setAppData:(MPAppData*)value {
    @synchronized(self) {
        appData = value;
    }
}


static MPLocationQuery* locationQuery;
+ (MPLocationQuery*) locationQuery {
    @synchronized(self) {
        if (locationQuery == nil) {
            locationQuery = [[MPLocationQuery alloc] init];
        }
        return locationQuery;
    }
}

+ (void) setLocationQuery:(MPLocationQuery*)value {
    @synchronized(self) {
        locationQuery = value;
    }
}

+ (void) setupPositioning {
    
    #if defined(MI_SDK_VERSION_MAJOR) && (MI_SDK_VERSION_MAJOR >= 2)
        if ( [MapsIndoors isAPIKeyValid] == NO ) {
            return;
        }
    #endif
    
    if (MapsIndoors.positionProvider == nil) {
        GPSPositionProvider*    pp = [GPSPositionProvider new];
        MapsIndoors.positionProvider = pp;
    }
    if ( [self.solution.modules containsObject:@"messages"] ) {
#if defined(MI_SDK_VERSION_MAJOR) && (MI_SDK_VERSION_MAJOR >= 2)
        MapsIndoors.positionProvider.preferAlwaysLocationPermission = YES;
#endif
    }
    [MapsIndoors.positionProvider startPositioning:[MapsIndoors getMapsIndoorsAPIKey]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPositioningInitialized object:self];
}

+ (NSString*)getIconUrlForType:(NSString*) typeName {
    if (Global.solution) {
        for (MPType* type in Global.solution.types) {
            if ([type.name isEqualToString:typeName]) {
                return type.icon;
            }
        }
    }
    return @"";
}

+ (MPLocationDisplayRule*)getDisplayRuleForType:(NSString*) typeName {
    if (Global.solution) {
        for (MPType* type in Global.solution.types) {
            if ([type.name isEqualToString:typeName]) {
                return type.displayRule;
            }
        }
    }
    return nil;
}

+ (NSString*) getAddressForLocation: (MPLocation*) location {
    MPLocationDisplayRule* displayRule = [Global getDisplayRuleForType:location.type];
    NSString* addr = [NSString stringWithString: location.name? : @""];
    if (displayRule) {
        addr = [displayRule getLabelContent:location];
    }
    return addr;
}

+ (NSString*)getBuildingLabelFromRouteLocation: (MPRouteCoordinate*)location {
    double lat = location.lat.doubleValue;
    double lng = location.lng.doubleValue;
    double level = location.zLevel.intValue;
    MPPoint* p = [[MPPoint alloc] initWithLat:lat lon:lng zValue:level];
    NSDictionary* venueData = [MPVenueProvider getDataFromPoint:p];
    MPBuilding* building = [venueData objectForKey:@"building"];
    return building.name;
}

+ (CLLocationDirection)getHeadingBetweenTwoLocation:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to {
    return GMSGeometryHeading(from, to);
}

+ (NSString*) getPropertyFromPlist:(NSString*)key {

    NSString* value = [[AppVariantData sharedAppVariantData].dict objectForKey:key];
    return value;
}


#pragma mark - User roles
static MPUserRoleManager*       g_userRoleManager;

+ (MPUserRoleManager*) userRoleManager {

    @synchronized(self) {
        return g_userRoleManager;
    }
}

+ (void) setUserRoleManager:(MPUserRoleManager*)userRoleManager {

    @synchronized(self) {
        g_userRoleManager = userRoleManager;
    }
}


@end
