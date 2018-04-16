//
//  MPDirectionsViewHeadlineModel.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 06/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface MPDirectionsViewHeadlineModel : NSObject

@property (nonatomic, strong) NSString*     text;
@property (nonatomic, strong) NSString*     travelModeText;
@property (nonatomic, strong) NSString*     materialDesignIconCode;
@property (nonatomic, strong) UIColor*      iconColor;
@property (nonatomic, strong) NSString*     imageUrl;
@property (nonatomic, strong) UIColor*      color;
@property (nonatomic, strong) UIColor*      textColor;
@property (nonatomic, strong) NSString*     primaryTextRight;
@property (nonatomic, strong) NSString*     detailText;
@property (nonatomic, strong) UIColor*      detailTextColor;

@end
