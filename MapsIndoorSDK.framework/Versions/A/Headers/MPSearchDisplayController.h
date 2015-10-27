//
//  SearchController.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/31/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPUIViewController.h"

@interface MPSearchDisplayController : UITableViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

/**
 * Location dataset model
 */
@property MPLocationDataset* locationData;
/**
 * Current location property, useful for location detail views.
 */
@property MPLocation* currentLocation;

@end
