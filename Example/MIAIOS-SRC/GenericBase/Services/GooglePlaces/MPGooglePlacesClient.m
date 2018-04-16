//
//  MPGooglePlacesClient.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 27/04/2017.
//  Copyright © 2017-2018 Michael Bech Hansen. All rights reserved.
//

// Ref: https://developers.google.com/places/web-service/autocomplete

#import "MPGooglePlacesClient.h"


#if DEBUG && 0
    #define DEBUGLOG(fMT,...)  NSLog( @"[D] MPGooglePlacesClient.m(%d): "fMT,  __LINE__, __VA_ARGS__ )
#else
    #define DEBUGLOG(fMt,...)  /* Nada! */
#endif


#define kPlacesAPIURl           @"https://maps.googleapis.com/maps/api/place/autocomplete/json"
#define kPlaceDetailsAPIURl     @"https://maps.googleapis.com/maps/api/place/details/json?key=%@&placeid=%@"


NSString*  kMPPlacesType_All = nil;
NSString*  kMPPlacesType_GeoCode = @"geocode";
NSString*  kMPPlacesType_Address = @"address";
NSString*  kMPPlacesType_Establishment = @"establishment";
NSString*  kMPPlacesType_Regions = @"(regions)";
NSString*  kMPPlacesType_Cities = @"(cities)";


static NSString*    MPGooglePlacesClient_sharedApiKey;


@interface MPGooglePlacesClient ()
    
@property (nonatomic, strong) NSDictionary*     autoCompleteParams;
@property (nonatomic, strong) NSDictionary*     placeDetailsParams;

@end


@implementation MPGooglePlacesClient

+ (void) provideAPIKey:(NSString *)key {
    
    MPGooglePlacesClient_sharedApiKey = key;
}

- (instancetype)init {
    
    self = [self initWithApiKey: MPGooglePlacesClient_sharedApiKey];
    return self;
}

- (instancetype) initWithApiKey:(NSString*)apiKey {
    
    if ( apiKey ) {
        self = [super init];
        if ( self ) {
            _apiKey = apiKey;
            _language = [[NSLocale preferredLanguages] objectAtIndex:0];
        }
    } 
    return self;
}

- (void) setLocationBiasWithRadius:(double)radius latitude:(double)latitude longitude:(double)longitude strictBounds:(BOOL)strictBounds {
    
    _radius = radius;
    _latitude = latitude;
    _longitude = longitude;
    _strictBounds = strictBounds;
    
    self.autoCompleteParams = nil;
}

- (NSDictionary*) autoCompleteParams {
    
    if ( _autoCompleteParams == nil ) {
        
        NSMutableDictionary*    d = [NSMutableDictionary dictionary];
        d[@"key"] = self.apiKey;
        if ( self.radius != 0 )     d[@"radius"] = @(self.radius);
        if ( (self.latitude != 0) || (self.longitude != 0) ) {
            d[@"location"] = [NSString stringWithFormat:@"%g,%g", self.latitude, self.longitude];
        }
        if ( self.strictBounds )        d[@"strictbounds"] = @"1";
        if ( self.language.length )     d[@"language"] = self.language;
        if ( self.placesType.length )   d[@"type"] = self.placesType;
        if ( self.countries.count ) {
            NSMutableArray<NSString*>*  countryArray = [NSMutableArray array];
            for ( NSString* c in self.countries ) {
                [countryArray addObject:[NSString stringWithFormat:@"country:%@", c]];
            }
            d[@"components"] = [countryArray componentsJoinedByString:@"|"];
        }
        _autoCompleteParams = [d copy];
    }
    return _autoCompleteParams;
}

- (NSString*) autoCompleteParamsForQuery:(NSString*)q {
    
    NSMutableArray* keyValuePairs = [NSMutableArray array];
    NSArray*        paramKeys = [[self.autoCompleteParams.allKeys mutableCopy] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for ( NSString* k in paramKeys ) {
        [keyValuePairs addObject:[NSString stringWithFormat:@"%@=%@", k, self.autoCompleteParams[k]]];
    }
    [keyValuePairs addObject:[NSString stringWithFormat:@"input=%@", q]];
    
    NSString*   queryString = [keyValuePairs componentsJoinedByString:@"&"];
    
    return [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (MPGooglePlacesResult) resultFromPlacesDict:(NSDictionary*)dict {
    
    MPGooglePlacesResult    result = MPGooglePlacesResult_UNKNOWN_ERROR;
    
    NSString*   status = dict[ @"status" ];
    if ( [status isEqualToString:@"OK"] ) {
        result = MPGooglePlacesResult_OK;
    } else if ( [status isEqualToString:@"ZERO_RESULTS"] ) {
        result = MPGooglePlacesResult_ZERO_RESULTS;
    } else if ( [status isEqualToString:@"OVER_QUERY_LIMIT"] ) {
        result = MPGooglePlacesResult_OVER_QUERY_LIMIT;
    } else if ( [status isEqualToString:@"REQUEST_DENIED"] ) {
        result = MPGooglePlacesResult_REQUEST_DENIED;
    } else if ( [status isEqualToString:@"INVALID_REQUEST"] ) {
        result = MPGooglePlacesResult_INVALID_REQUEST;
    }
    
    return result;
}

- (void) autoComplete:(NSString*)q callback:(PlacesAutoCompleteCompletion)callback {
    
    NSAssert( callback != nil, @"Must supply callback" );
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", kPlacesAPIURl, [self autoCompleteParamsForQuery:q]]];
    
    DEBUGLOG( @"REQ %@", url.absoluteString );
    
    NSURLSessionDataTask*   task = [NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary*           resultDict;
        NSArray<NSDictionary*>* predictions;
        MPGooglePlacesResult    result = MPGooglePlacesResult_UNKNOWN_ERROR;
        
        if ( error ) {
            DEBUGLOG( @"ERR %@", error );
        }
        if ( data ) {
            
            NSError*        jsonError;
            resultDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            
            if ( jsonError && !error ) {
                error = jsonError;
                
            } else {
                predictions = resultDict[ @"predictions" ];
                result = [self resultFromPlacesDict: resultDict];
            }
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            callback( self, result, predictions, error );
        });
    }];
    [task resume];
}

- (void) placeDetailsFromPlaceId:(NSString*)placeId callback:(PlaceDetailsCompletion)callback {

    NSAssert( callback != nil, @"Must supply callback" );
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:kPlaceDetailsAPIURl, self.apiKey, placeId]];
    
    DEBUGLOG( @"REQ %@", url.absoluteString );
    
    NSURLSessionDataTask*   task = [NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary*           resultDict;
        MPGooglePlacesResult    result = MPGooglePlacesResult_UNKNOWN_ERROR;
        
        if ( error ) {
            DEBUGLOG( @"ERR %@", error );
        }
        if ( data ) {
            
            NSError*        jsonError;
            resultDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            
            if ( jsonError && !error ) {
                error = jsonError;
                
            } else {
                result = [self resultFromPlacesDict: resultDict];
            }
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            callback( self, result, resultDict, error );
        });
    }];
    [task resume];
}

@end
