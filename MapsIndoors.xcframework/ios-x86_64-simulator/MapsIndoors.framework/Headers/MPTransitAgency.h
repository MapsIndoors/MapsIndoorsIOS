//
//  MPTransitAgency.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "MPJSONModel.h"


@protocol MPTransitAgency
@end

/**
 Transit agency information.
 */
@interface MPTransitAgency : MPJSONModel
/**
 Name contains the name of the transit agency.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* name;
/**
 Url contains the URL for the transit agency.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* url;
/**
 Phone contains the phone number of the transit agency.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* phone;

@end
