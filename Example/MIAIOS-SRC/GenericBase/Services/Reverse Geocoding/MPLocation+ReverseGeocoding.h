//
//  MPLocation+ReverseGeocoding.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 24/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MPLocation.h>


@class GMSReverseGeocodeResponse;


@interface MPLocation (ReverseGeocoding)

@property (nonatomic, strong, setter= mp_setReverseGeocodingResponse:) GMSReverseGeocodeResponse<Optional>*   mp_reverseGeocodingResponse;
@property (nonatomic, weak, readonly) NSString<Optional>*                                                     mp_firstReverseGeocodedAddress;     // [mp_reverseGeocodingResponse.firstResult.lines componentsJoinedByString:@", "]

@end
