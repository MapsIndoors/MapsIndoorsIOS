//
//  MPGooglePlaceDetails.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 02/05/2017.
//  Copyright © 2017-2018 Michael Bech Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@interface MPGooglePlaceDetails : NSObject

@property (nonatomic, copy, readonly) NSString*                         name;
@property (nonatomic, copy, readonly) NSString*                         address;
@property (nonatomic, readonly)       CLLocationCoordinate2D            location;
@property (nonatomic, readonly)       CLLocationCoordinate2D            viewPortNorthEast;
@property (nonatomic, readonly)       CLLocationCoordinate2D            viewPortSouthWest;
@property (nonatomic, copy, readonly) NSString*                         icon;
@property (nonatomic, copy, readonly) NSDictionary*                     rawData;
@property (nonatomic, copy, readonly, nullable) NSArray<NSString *>*    types;    // https://developers.google.com/places/ios-api/supported_types
@property (nonatomic, copy, readonly) NSString*                         url;
@property (nonatomic, readonly)       NSInteger                         utcOffset;
@property (nonatomic, copy, readonly) NSString*                         vicinity;
@property (nonatomic, copy, readonly) NSArray<NSDictionary*>*           photos;

+ (instancetype _Nullable) newWithDict:(NSDictionary*)dict;
- (instancetype _Nullable) initWithDict:(NSDictionary*)dict;
- (instancetype) init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
