//
//  MPMutableLocation.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "MPLocation.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Mutable extensions to MPLocation.
 */
@interface MPLocation ()

@property (nonatomic, strong, readwrite) NSString *locationId;
@property (nonatomic, strong, readwrite) NSString *type;
@property (nonatomic, strong, nullable, readwrite) NSNumber *activeFrom;
@property (nonatomic, strong, nullable, readwrite) NSNumber *activeTo;
@property (nonatomic, strong, nullable, readwrite) NSString *venue;
@property (nonatomic, strong, nullable, readwrite) NSString *building;
@property (nonatomic, strong, nullable, readwrite) NSString *externalId;
@property (nonatomic, strong, nullable, readwrite) NSString *locationDescription;
@property (nonatomic, strong, readwrite) NSArray<NSString*> *aliases;
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSNumber* floorIndex;
@property (nonatomic, strong, readwrite) NSString* floorName;
@property (nonatomic, strong, nullable, readwrite) NSMutableArray<NSString*>* categories;
@property (nonatomic, strong, nullable, readwrite) NSMutableDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *properties;
@property (nonatomic, strong, nullable, readwrite) MPPoint<Ignore> *position;
@property (nonatomic, strong, nullable, readwrite) UIImage *  image;
@property (nonatomic, strong, nullable, readwrite) NSString*  imageURL;
@property (nonatomic, strong, nullable, readwrite) UIImage*   icon;
@property (nonatomic, strong, nullable, readwrite) NSURL*     iconUrl;
@property (nonatomic, strong, readwrite) NSString*  locationBaseTypeString;

@end

typedef MPLocation      MPMutableLocation;

NS_ASSUME_NONNULL_END
