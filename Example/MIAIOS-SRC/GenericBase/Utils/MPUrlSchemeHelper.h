//
//  MPUrlSchemeHelper.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 26/05/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>


typedef NS_ENUM(NSUInteger, MPUrlSchemeCommand) {
    MPUrlSchemeCommand_Unknown,

    /*
     https://clients.mapsindoors.com/DatasetId/directions?origin=47.423822,9.378053&destinationLocation=111122223333444455556666&travelMode=walking&avoid=stairs
     appmap://DatasetId/directions?origin=47.423822,9.378053&destinationLocation=111122223333444455556666&travelMode=walking&avoid=stairs
     */
    MPUrlSchemeCommand_Directions,

    /*
     https://clients.mapsindoors.com/DatasetId/details?location=111122223333444455556666
     appmap://DatasetId/details?location=111122223333444455556666
     */
    MPUrlSchemeCommand_LocationDetails,
};


NS_ASSUME_NONNULL_BEGIN

@interface MPUrlSchemeHelper : NSObject

// Configuration
@property (nonatomic, strong)           NSString*           appUrlScheme;           // Detected automatically, but can be overridden
@property (nonatomic, strong)           NSString*           builderDatasetId;       // Current MapsIndoors datasetId unless explicitly overridden.

// Url related:
@property (nonatomic, strong, readonly) NSString*           httpUrl;
@property (nonatomic, strong, readonly) NSString*           appUrl;
@property (nonatomic, strong, readonly) NSArray<NSString*>* urls;
@property (nonatomic,         readonly) MPUrlSchemeCommand  command;
@property (nonatomic, strong, readonly) NSString*           datasetId;
@property (nonatomic, strong, readonly) MPPoint*            origin;                 // lat/long/floor
@property (nonatomic, strong, readonly) NSString*           originLocation;         // Location ID
@property (nonatomic, strong, readonly) MPPoint*            destination;            // lat/long/floor
@property (nonatomic, strong, readonly) NSString*           destinationLocation;    // Location ID
@property (nonatomic, strong, readonly) NSString*           travelMode;
@property (nonatomic, strong, readonly) NSString*           avoid;
@property (nonatomic, strong, readonly) NSArray<NSString*>* avoids;
@property (nonatomic, strong, readonly) NSString*           location;               // Location ID

#pragma mark - Construction

+ (instancetype) newWithAppUrlScheme:(nullable NSString*)appUrlScheme builderDatasetId:(nullable NSString*)builderDatasetId;
- (instancetype) initWithAppUrlScheme:(nullable NSString*)appUrlScheme builderDatasetId:(nullable NSString*)builderDatasetId NS_DESIGNATED_INITIALIZER;

#pragma mark - URL builders:

/// Build an URL for routing between origin and destination using travelmode and avoids-restrictions.
/// @param origin Route origin
/// @param destination Routedestination
/// @param travelMode travelMode
/// @param avoids Route restrictions.  "stairs" is only option right now.
/// @return http URL of successfull.
- (nullable NSString*) urlForDirectionsWithOrigin:(nullable MPLocation*)origin destination:(nullable MPLocation*)destination travelMode:(nullable NSString*)travelMode avoids:(nullable NSArray<NSString*>*)avoids;

/// Build an URL for viewing location details.
/// @param location Location to get detail URL for.
/// @return http URL
- (nullable NSString*) urlForLocationDetails:(MPLocation*)location;

#pragma mark - URL consumers
/// Parse the given URL into member fields.
/// Use .command to determine which kind of URL if any was parsed.
/// Deails of the URL can be read from the other properties of this object.
/// @param url Url
/// @return YES if successfull else NO.
- (BOOL) parseUrl:(NSString*)url;

@end

NS_ASSUME_NONNULL_END
