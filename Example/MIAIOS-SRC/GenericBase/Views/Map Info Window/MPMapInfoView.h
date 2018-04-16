//
//  MPMapInfoView.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 30/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPLocation;


@interface MPMapInfoView : UIView

+ (instancetype) createMapInfoWindowForLocation:(MPLocation*)model;

@end
