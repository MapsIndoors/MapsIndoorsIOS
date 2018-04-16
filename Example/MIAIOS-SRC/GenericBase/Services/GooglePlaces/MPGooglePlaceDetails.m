//
//  MPGooglePlaceDetails.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 02/05/2017.
//  Copyright © 2017-2018 Michael Bech Hansen. All rights reserved.
//

#import "MPGooglePlaceDetails.h"

@implementation MPGooglePlaceDetails

+ (instancetype) newWithDict:(NSDictionary*)dict {
    
    return [[MPGooglePlaceDetails alloc] initWithDict:dict];
}

- (instancetype) initWithDict:(NSDictionary*)dict {
    
    self = [super init];
    if (self) {
        _rawData = dict;
    }
    
    return self;
}

- (NSString *)name {
    
    return [self.rawData valueForKeyPath:@"result.name"];
}

- (NSString*) address {

    return [self.rawData valueForKeyPath:@"result.formatted_address"];
}

- (CLLocationCoordinate2D)location {
    
    double  latitude  = [[self.rawData valueForKeyPath:@"result.geometry.location.lat"] doubleValue];
    double  longitude = [[self.rawData valueForKeyPath:@"result.geometry.location.lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (CLLocationCoordinate2D)viewPortNorthEast {
    
    double  latitude  = [[self.rawData valueForKeyPath:@"result.geometry.viewport.northeast.lat"] doubleValue];
    double  longitude = [[self.rawData valueForKeyPath:@"result.geometry.viewport.northeast.lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (CLLocationCoordinate2D)viewPortSouthWest {
    
    double  latitude  = [[self.rawData valueForKeyPath:@"result.geometry.viewport.southwest.lat"] doubleValue];
    double  longitude = [[self.rawData valueForKeyPath:@"result.geometry.viewport.southwest.lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (NSString *)icon {
    
    return [self.rawData valueForKeyPath:@"result.icon"];
}

- (NSArray<NSString *> *)types {
    
    return [self.rawData valueForKeyPath:@"result.types"];
}

- (NSString *)url {
    
    return [self.rawData valueForKeyPath:@"result.url"];
}

- (NSInteger)utcOffset {

    return [[self.rawData valueForKeyPath:@"result.url"] integerValue];
}

- (NSString *)vicinity {
    
    return [self.rawData valueForKeyPath:@"result.vicinity"];
}

- (NSArray<NSDictionary *> *)photos {
    
    return [self.rawData valueForKeyPath:@"result.photos"];
}

- (NSString *)debugDescription {

    return [NSString stringWithFormat:@"<MPGooglePlaceDetails %p: %@, addr=%@, lat=%@, lng=%@>", self, self.name, self.address, @(self.location.latitude), @(self.location.longitude)];
}

@end
