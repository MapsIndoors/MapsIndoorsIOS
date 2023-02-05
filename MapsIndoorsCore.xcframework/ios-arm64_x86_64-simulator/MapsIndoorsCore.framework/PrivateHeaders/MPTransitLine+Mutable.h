//
//  MPTransitLine.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"
#import "MPTransitAgency.h"
#import "MPTransitVehicle.h"

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Transit line information.
 */
@interface MPTransitLine()

@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* name;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* short_name;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* color;
@property (nonatomic, strong, nullable, readwrite) NSArray<MPTransitAgency*><MPTransitAgency>* agencies;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* url;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* icon;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* text_color;
@property (nonatomic, strong, nullable, readwrite) MPTransitVehicle<Optional>* vehicle;

@end
