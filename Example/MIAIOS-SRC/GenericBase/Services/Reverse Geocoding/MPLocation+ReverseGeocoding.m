//
//  MPLocation+ReverseGeocoding.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 24/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPLocation+ReverseGeocoding.h"
#import <objc/runtime.h>


@implementation MPLocation (ReverseGeocoding)

- (GMSReverseGeocodeResponse *)mp_reverseGeocodingResponse {
    
    return (GMSReverseGeocodeResponse *)objc_getAssociatedObject( self, @selector(mp_reverseGeocodingResponse) );
}

- (void)mp_setReverseGeocodingResponse:(GMSReverseGeocodeResponse *)reverseGeocodingResponse {
    
    objc_setAssociatedObject( self, @selector(mp_reverseGeocodingResponse), reverseGeocodingResponse, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSString *)mp_firstReverseGeocodedAddress {

    return self.mp_reverseGeocodingResponse.firstResult.lines.count ? [self.mp_reverseGeocodingResponse.firstResult.lines componentsJoinedByString:@", "] : nil;
}

@end
