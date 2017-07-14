//
//  MPMessage.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 08/03/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import "MPJSONModel.h"
#import <UIKit/UIKit.h>

@interface MPMessage : MPJSONModel

@property NSString* messageId;
@property NSString<Optional>* beaconId;
@property NSString<Optional>* locationId;
@property NSString<Optional>* title;
@property NSString<Optional>* content;
@property NSString<Optional>* imagePath;
@property UIImage<Ignore>* image;
@property NSDictionary<Optional>* geometry;
@property NSDate<Ignore>* deliveredDate;

@end
