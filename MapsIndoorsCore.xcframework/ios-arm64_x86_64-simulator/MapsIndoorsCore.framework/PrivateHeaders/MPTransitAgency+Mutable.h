//
//  MPTransitAgency.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Transit agency information.
 */
@interface MPTransitAgency()

@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* name;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* url;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* phone;

@end
