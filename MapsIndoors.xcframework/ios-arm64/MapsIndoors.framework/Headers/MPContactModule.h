//
//  MPContactModule.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 12/4/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPJSONModel.h"
#import "MPDataField.h"

@interface MPContactModule : MPJSONModel

@property (nonatomic, strong, nullable) MPDataField<Optional>* email;
@property (nonatomic, strong, nullable) MPDataField<Optional>* phone;
@property (nonatomic, strong, nullable) MPDataField<Optional>* faxNumber;
@property (nonatomic, strong, nullable) MPDataField<Optional>* website;

@end
