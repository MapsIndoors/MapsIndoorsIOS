//
//  MPUIViewController.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/1/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPLocation.h"
#import "MPLocationDataset.h"

/**
 * Simple view controller interface with current location and location data models for convenient interoperation
 */
@interface MPUIViewController : UIViewController
/**
 * Location dataset model
 */
@property MPLocationDataset* locationData;
/**
 * Current location property, useful for location detail views.
 */
@property MPLocation* currentLocation;

@end
