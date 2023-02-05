//
//  MPTransitTime.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Transit time information.
 */
@interface MPTransitTime()

@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* text;
@property (nonatomic, strong, nullable, readwrite) NSNumber<Optional>* value;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* time_zone;

@end
