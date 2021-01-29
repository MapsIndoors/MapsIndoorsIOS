//
//  MPUrlSchemeHelper.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 26/05/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPUrlSchemeHelper.h"


@interface MPUrlSchemeHelper ()

@property (nonatomic, strong, readwrite) NSString*              httpUrl;
@property (nonatomic, strong, readwrite) NSString*              appUrl;
@property (nonatomic,         readwrite) MPUrlSchemeCommand     command;
@property (nonatomic, strong, readwrite) NSString*              datasetId;
@property (nonatomic, strong, readwrite) MPPoint*               origin;                 // lat/long/floor
@property (nonatomic, strong, readwrite) NSString*              originLocation;         // Location ID
@property (nonatomic, strong, readwrite) MPPoint*               destination;            // lat/long/floor
@property (nonatomic, strong, readwrite) NSString*              destinationLocation;    // Location ID
@property (nonatomic, strong, readwrite) NSString*              travelMode;
@property (nonatomic, strong, readwrite) NSString*              avoid;
@property (nonatomic, strong, readwrite) NSArray<NSString*>*    avoids;
@property (nonatomic, strong, readwrite) NSString*              location;               // Location ID

@end


@implementation MPUrlSchemeHelper

#pragma mark - Construction

+ (instancetype) newWithAppUrlScheme:(nullable NSString*)appUrlScheme builderDatasetId:(nullable NSString*)builderDatasetId {

    return [[self alloc] initWithAppUrlScheme:appUrlScheme builderDatasetId:builderDatasetId];
}


- (instancetype) init {

    self = [self initWithAppUrlScheme:nil builderDatasetId:nil];
    return self;
}


- (instancetype) initWithAppUrlScheme:(nullable NSString*)appUrlScheme builderDatasetId:(nullable NSString*)builderDatasetId {

    self = [super init];
    if (self) {
        _builderDatasetId = builderDatasetId;
        _appUrlScheme = appUrlScheme;

        if ( appUrlScheme == nil ) {
            NSArray<NSString*>* redirectSchemes = [[NSBundle mainBundle] valueForKeyPath:@"infoDictionary.CFBundleURLTypes.@distinctUnionOfArrays.CFBundleURLSchemes"];
            if ( redirectSchemes.count == 1 ) {
                _appUrlScheme = redirectSchemes.firstObject;
            }
        }
    }

    return self;
}


- (void) reset {

    self.httpUrl = nil;
    self.appUrl = nil;
    self.command = MPUrlSchemeCommand_Unknown;
    self.datasetId = nil;
    self.origin = nil;
    self.originLocation = nil;
    self.destination = nil;
    self.destinationLocation = nil;
    self.travelMode = nil;
    self.avoid = nil;
    self.avoids = nil;
    self.location = nil;
}


- (BOOL) isEqual:(id)object {

    MPUrlSchemeHelper*  o;

    if ( [object isKindOfClass:[MPUrlSchemeHelper class]] ) {
        o = object;
        return [self.datasetId isEqualToString:o.datasetId] &&
               (self.command == o.command) &&
               ((self.httpUrl == o.httpUrl) || [self.httpUrl isEqualToString:o.httpUrl]) &&
               ((self.appUrl == o.appUrl) || [self.appUrl isEqualToString:o.appUrl]) &&
               ((self.datasetId == o.datasetId) || [self.datasetId isEqualToString:o.datasetId]) &&
               ((self.origin == o.origin) || [self.origin.latLngString isEqualToString:o.origin.latLngString]) &&
               ((self.originLocation == o.originLocation) || [self.originLocation isEqualToString:o.originLocation]) &&
               ((self.destination == o.destination) || [self.destination.latLngString isEqualToString:o.destination.latLngString]) &&
               ((self.destinationLocation == o.destinationLocation) || [self.destinationLocation isEqualToString:o.destinationLocation]) &&
               ((self.travelMode == o.travelMode) || [self.travelMode isEqualToString:o.travelMode]) &&
               ((self.avoid == o.avoid) || [self.avoid isEqualToString:o.avoid]) &&
               ((self.avoids == o.avoids) || [self.avoids isEqualToArray:o.avoids]) &&
               ((self.location == o.location) || [self.location isEqualToString:o.location])
               ;
    }

    return NO;
}


- (NSArray<NSString*>*) urls {

    if ( self.httpUrl && self.appUrl ) {
        return @[ self.httpUrl, self.appUrl ];
    } else if ( self.httpUrl ) {
        return @[ self.httpUrl ];
    } else if ( self.appUrl ) {
        return @[ self.appUrl ];
    }

    return nil;
}


#pragma mark - URL builders:

- (BOOL) routeFromLatitudeLongitude:(MPLocation*)location {

    if ( location.locationId && location.type && ([location.type isEqualToString:@"google-place"] == NO) && ([location.locationId isEqualToString:@"0-0"] == NO) ) {

        switch ( location.baseType ) {
            case MPLocationBaseTypeArea:
            case MPLocationBaseTypeRoom:
            case MPLocationBaseTypePointOfInterest:
                return NO;

            case MPLocationBaseTypeBuilding:
            case MPLocationBaseTypeFloor:
            case MPLocationBaseTypeVenue:
                break;
        }
    }

    return YES;
}


- (nullable NSString*) urlForDirectionsWithOrigin:(nullable MPLocation*)origin destination:(nullable MPLocation*)destination travelMode:(nullable NSString*)travelMode avoids:(nullable NSArray<NSString*>*)avoids {

    [self reset];

    if ( origin || destination ) {

        NSURLComponents*    urlBuilder = [NSURLComponents new];
        NSString*           datasetId = self.builderDatasetId ?: [MapsIndoors getMapsIndoorsAPIKey];

        urlBuilder.scheme = @"https";

        urlBuilder.host = @"clients.mapsindoors.com";
        urlBuilder.path = [NSString stringWithFormat:@"/%@/directions", datasetId];

        NSMutableArray<NSURLQueryItem*>*    queryItems = [NSMutableArray array];

        if ( origin ) {
            if ( [self routeFromLatitudeLongitude:origin] ) {
                self.origin = origin.geometry;
                [queryItems addObject:[NSURLQueryItem queryItemWithName:@"origin" value:[self.origin latLngString]]];
            } else {
                self.originLocation = origin.locationId;
                [queryItems addObject:[NSURLQueryItem queryItemWithName:@"originLocation" value:self.originLocation]];
            }
        }

        if ( destination ) {
            if ( [self routeFromLatitudeLongitude:destination] ) {
                self.destination = destination.geometry;
                [queryItems addObject:[NSURLQueryItem queryItemWithName:@"destination" value:[self.destination latLngString]]];
            } else {
                self.destinationLocation = destination.locationId;
                [queryItems addObject:[NSURLQueryItem queryItemWithName:@"destinationLocation" value:self.destinationLocation]];
            }
        }

        if ( travelMode ) {
            self.travelMode = travelMode;
            [queryItems addObject:[NSURLQueryItem queryItemWithName:@"travelMode" value:self.travelMode]];
        }

        if ( avoids.count ) {
            self.avoid  = avoids.count == 1 ? avoids.firstObject : nil;
            self.avoids = avoids.count >  0 ? avoids             : nil;
            for ( NSString* avoid in self.avoids ) {
                [queryItems addObject:[NSURLQueryItem queryItemWithName:@"avoid" value:avoid]];
            }
        }

        urlBuilder.queryItems = queryItems;

        if ( urlBuilder.URL.absoluteString ) {
            self.httpUrl = urlBuilder.URL.absoluteString;
        }

        NSString*   scheme = self.appUrlScheme ?: [self appUrlScheme];
        if ( scheme ) {
            urlBuilder.scheme = scheme;
            if ( urlBuilder.URL.absoluteString ) {
                self.appUrl = [urlBuilder.URL.absoluteString stringByReplacingOccurrencesOfString:@"clients.mapsindoors.com/" withString:@""];
            }
        }

        if ( self.httpUrl || self.appUrl ) {
            self.command = MPUrlSchemeCommand_Directions;
        }
    }

    return self.httpUrl ?: self.appUrl;
}


- (BOOL) detailUrlAvailableForLocation:(MPLocation*)location {

    if ( location.locationId && location.type ) {

        switch ( location.baseType ) {
            case MPLocationBaseTypeArea:
            case MPLocationBaseTypeRoom:
            case MPLocationBaseTypePointOfInterest:
                return YES;

            case MPLocationBaseTypeBuilding:
            case MPLocationBaseTypeFloor:
            case MPLocationBaseTypeVenue:
                break;
        }
    }

    return NO;
}


- (nullable NSString*) urlForLocationDetails:(MPLocation*)location {

    [self reset];

    if ( location && [self detailUrlAvailableForLocation:location] ) {

        NSURLComponents*    urlBuilder = [NSURLComponents new];
        NSString*           datasetId = self.builderDatasetId ?: [MapsIndoors getMapsIndoorsAPIKey];

        urlBuilder.scheme = @"https";

        urlBuilder.host = @"clients.mapsindoors.com";
        urlBuilder.path = [NSString stringWithFormat:@"/%@/details", datasetId];

        NSMutableArray<NSURLQueryItem*>*    queryItems = [NSMutableArray array];

        self.location = location.locationId;
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"location" value:self.location]];

        urlBuilder.queryItems = queryItems;

        if ( urlBuilder.URL.absoluteString ) {
            self.httpUrl = urlBuilder.URL.absoluteString;
        }

        NSString*   scheme = self.appUrlScheme ?: [self appUrlScheme];
        if ( scheme ) {
            urlBuilder.scheme = scheme;
            if ( urlBuilder.URL.absoluteString ) {
                self.appUrl = [urlBuilder.URL.absoluteString stringByReplacingOccurrencesOfString:@"clients.mapsindoors.com/" withString:@""];
            }
        }

        if ( self.httpUrl || self.appUrl ) {
            self.command = MPUrlSchemeCommand_LocationDetails;
        }
    }

    return self.httpUrl ?: self.appUrl;
}


#pragma mark - URL consumers

- (BOOL) validate {

    BOOL    isValid = NO;

    if ( self.datasetId ) {
        switch ( self.command ) {
            case MPUrlSchemeCommand_Directions:
                isValid = self.origin || self.originLocation || self.destination|| self.destinationLocation;
                break;

            case MPUrlSchemeCommand_LocationDetails:
                isValid = self.location != nil;
                break;

            case MPUrlSchemeCommand_Unknown:
                break;
        }
    }

    return isValid;
}


- (BOOL) parseUrl:(NSString*)url {

    [self reset];

    if ( url ) {

        NSURLComponents*    urlComponents = [NSURLComponents componentsWithString:url];
        BOOL                isHttp = [urlComponents.scheme isEqualToString:@"https"] || [urlComponents.scheme isEqualToString:@"http"];
        NSString*           normalizedPath = isHttp ? urlComponents.path : [urlComponents.host stringByAppendingString:urlComponents.path];

        if ( [normalizedPath hasPrefix:@"/"] ) {
            normalizedPath = [normalizedPath substringFromIndex:1];
        }

        NSArray<NSString*>* pathParts = [normalizedPath componentsSeparatedByString:@"/"];

        self.datasetId = pathParts.firstObject;

        if ( pathParts.count == 2 ) {

            if ( [pathParts.lastObject isEqualToString:@"directions"] ) {
                self.command = MPUrlSchemeCommand_Directions;
            } else if ( [pathParts.lastObject isEqualToString:@"details"] ) {
                self.command = MPUrlSchemeCommand_LocationDetails;
            }

            for ( NSURLQueryItem* qi in urlComponents.queryItems ) {
                if ( [qi.name isEqualToString:@"origin"]  ) {
                    self.origin = [self pointFromString:qi.value];
                } else if ( [qi.name isEqualToString:@"originLocation"]  ) {
                    self.originLocation = qi.value;
                } else if ( [qi.name isEqualToString:@"destination"]  ) {
                    self.destination = [self pointFromString:qi.value];
                } else if ( [qi.name isEqualToString:@"destinationLocation"]  ) {
                    self.destinationLocation = qi.value;
                } else if ( [qi.name isEqualToString:@"avoid"]  ) {
                    self.avoids = [@[qi.value] arrayByAddingObjectsFromArray:self.avoids];
                } else if ( [qi.name isEqualToString:@"travelMode"]  ) {
                    self.travelMode = qi.value;
                } else if ( [qi.name isEqualToString:@"location"]  ) {
                    self.location = qi.value;
                }
            }

            if ( self.avoids.count == 1 ) {
                self.avoid = self.avoids.firstObject;
            }

            if ( ![self validate] ) {
                [self reset];
            }
        }
    }

    return self.command != MPUrlSchemeCommand_Unknown;
}

- (MPPoint*) pointFromString:(NSString*)coordinate {

    MPPoint*            point;
    NSArray<NSString*>* arr = [coordinate componentsSeparatedByString:@","];

    if (arr.count > 2) {
        point = [[MPPoint alloc] initWithLat:[[arr objectAtIndex:0] doubleValue] lon:[[arr objectAtIndex:1] doubleValue] zValue:[[arr objectAtIndex:2] doubleValue]];
    } else if (arr.count > 1) {
        point = [[MPPoint alloc] initWithLat:[[arr objectAtIndex:0] doubleValue] lon:[[arr objectAtIndex:1] doubleValue]];
    }

    return point;
}

@end
