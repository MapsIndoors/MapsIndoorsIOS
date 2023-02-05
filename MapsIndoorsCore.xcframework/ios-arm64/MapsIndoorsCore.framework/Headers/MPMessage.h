//
//  MPMessage.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 08/03/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPMessage : JSONModel

@property (nonatomic, strong, nullable) NSString* messageId;
@property (nonatomic, strong, nullable) NSString<Optional>* beaconId;
@property (nonatomic, strong, nullable) NSString<Optional>* locationId;
@property (nonatomic, strong, nullable) NSString<Optional>* title;
@property (nonatomic, strong, nullable) NSString<Optional>* content;
@property (nonatomic, strong, nullable) NSString<Optional>* imagePath;
@property (readonly, assign, nullable) NSNumber<Optional>* maxPushTimes;
@property (readonly, assign, nullable) NSNumber<Optional>* pushInterval;
@property (nonatomic, strong, nullable) NSNumber<Optional>* notificationCount;
@property (nonatomic, strong, nullable) UIImage<Ignore>* image;
@property (nonatomic, strong, nullable) NSDictionary<Optional>* geometry;
@property (nonatomic, strong, nullable) NSDate<Ignore>* deliveredDate;

@end
