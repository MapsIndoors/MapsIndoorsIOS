//
//  MPGooglePlacesAutoCompletePrediction.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 02/05/2017.
//  Copyright © 2017-2018 Michael Bech Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPGooglePlacesAutoCompletePrediction : NSObject

@property (nonatomic, copy, readonly) NSAttributedString*               attributedFullText;
@property (nonatomic, copy, readonly) NSAttributedString*               attributedPrimaryText;
@property (nonatomic, copy, readonly, nullable) NSAttributedString*     attributedSecondaryText;
@property (nonatomic, copy, readonly, nullable) NSString*               placeID;
@property (nonatomic, copy, readonly, nullable) NSArray<NSString *>*    types;    // https://developers.google.com/places/ios-api/supported_types

+ (instancetype _Nullable) newWithDict:(NSDictionary*)dict;
- (instancetype _Nullable) initWithDict:(NSDictionary*)dict;
- (instancetype) init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
