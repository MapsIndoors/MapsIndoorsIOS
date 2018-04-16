//
//  MPGooglePlacesClient.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 27/04/2017.
//  Copyright © 2017-2018 Michael Bech Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString*  kMPPlacesType_All;
extern NSString*  kMPPlacesType_GeoCode;
extern NSString*  kMPPlacesType_Address;
extern NSString*  kMPPlacesType_Establishment;
extern NSString*  kMPPlacesType_Regions;
extern NSString*  kMPPlacesType_Cities;

typedef NS_ENUM(NSUInteger, MPGooglePlacesResult) {
    MPGooglePlacesResult_OK,
    MPGooglePlacesResult_ZERO_RESULTS,      // indicates that the search was successful but returned no results. This may occur if the search was passed a bounds in a remote location.
    MPGooglePlacesResult_OVER_QUERY_LIMIT,  // indicates that you are over your quota.
    MPGooglePlacesResult_REQUEST_DENIED,    // indicates that your request was denied, generally because of lack of an invalid key parameter.
    MPGooglePlacesResult_INVALID_REQUEST,   // generally indicates that the input parameter is missing.
    
    MPGooglePlacesResult_UNKNOWN_ERROR
};

@class MPGooglePlacesClient;
typedef void (^PlacesAutoCompleteCompletion)( MPGooglePlacesClient* placesClient, MPGooglePlacesResult result, NSArray<NSDictionary*>* placesPredictions, NSError* placesError );
typedef void (^PlaceDetailsCompletion)( MPGooglePlacesClient* placesClient, MPGooglePlacesResult result, NSDictionary* placesPredictions, NSError* placesError );


@interface MPGooglePlacesClient : NSObject
    
@property (nonatomic, readonly) NSString*       apiKey;
@property (nonatomic, readonly) BOOL            strictBounds;
@property (nonatomic, readonly) double          radius;
@property (nonatomic, readonly) double          latitude;
@property (nonatomic, readonly) double          longitude;
@property (nonatomic) NSString*                 language;
@property (nonatomic) NSString*                 placesType;     // kMPPlacesType_*
@property (nonatomic) NSArray<NSString*>*       countries;      // Array of ISO_3166-1_alpha-2 country codes (see https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)

+ (void) provideAPIKey:(NSString *)key;
- (instancetype) init;
- (instancetype) initWithApiKey:(NSString*)apiKey NS_DESIGNATED_INITIALIZER;

- (void) setLocationBiasWithRadius:(double)r latitude:(double)latitude longitude:(double)longitude strictBounds:(BOOL)strictBounds;

- (void) autoComplete:(NSString*)q callback:(PlacesAutoCompleteCompletion)callback;
- (void) placeDetailsFromPlaceId:(NSString*)placeId callback:(PlaceDetailsCompletion)callback;

@end
