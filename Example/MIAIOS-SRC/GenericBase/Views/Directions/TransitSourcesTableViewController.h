//
//  TransitSourcesTableViewController.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 07/08/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPTransitAgency;


@interface TransitSourcesTableViewController : UITableViewController

@property (nonatomic, strong) NSArray<MPTransitAgency*>*        transitSources;

@end
