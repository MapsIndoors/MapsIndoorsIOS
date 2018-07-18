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


@interface MPTransitAgency : MPJSONModel

//name contains the name of the transit agency.
@property (nonatomic, strong, nullable) NSString<Optional>* name;
//url contains the URL for the transit agency.
@property (nonatomic, strong, nullable) NSString<Optional>* url;
//phone contains the phone number of the transit agency.
@property (nonatomic, strong, nullable) NSString<Optional>* phone;

@end
