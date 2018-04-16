//
//  MPGooglePlacesAutoCompletePrediction.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 02/05/2017.
//  Copyright © 2017-2018 Michael Bech Hansen. All rights reserved.
//

#import "MPGooglePlacesAutoCompletePrediction.h"

@implementation MPGooglePlacesAutoCompletePrediction

+ (instancetype _Nullable) newWithDict:(NSDictionary*)dict {

    return [[MPGooglePlacesAutoCompletePrediction alloc] initWithDict:dict];
}

- (instancetype _Nullable) initWithDict:(NSDictionary*)dict {
    
    self = [super init];
    if (self) {
        _attributedFullText      = dict[@"description"] ? [[NSAttributedString alloc] initWithString:dict[@"description"]] : nil;
        _attributedPrimaryText   = [dict valueForKeyPath:@"structured_formatting.main_text"] ? [[NSAttributedString alloc] initWithString:[dict valueForKeyPath:@"structured_formatting.main_text"]] : nil;
        _attributedSecondaryText = [dict valueForKeyPath:@"structured_formatting.secondary_text"] ? [[NSAttributedString alloc] initWithString:[dict valueForKeyPath:@"structured_formatting.secondary_text"]] : nil;
        _placeID                 = [dict valueForKeyPath:@"place_id"];
        _types                   = [dict valueForKeyPath:@"types"];
        
        if ( !_attributedFullText || !_attributedPrimaryText || !_placeID ) {
            self = nil;
        }
    }
    
    return self;
}

- (NSString *)debugDescription {
    
    return [NSString stringWithFormat:@"<MPGooglePlacesAutoCompletePrediction %p: %@, '%@', '%@'>", self, self.placeID, [self.attributedPrimaryText string], [self.attributedSecondaryText string]];
}

@end
