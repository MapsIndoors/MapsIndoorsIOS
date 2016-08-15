//
//  DetailViewController.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>
#import "UIFont+SystemFontOverride.h"

@interface DetailViewController : UIViewController<MPRoutingProviderDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) IBOutlet UIView *tableFooter;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIImageView *backIconView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MPLocation* location;

- (UIImage*) materialIcon:(NSString*)iconCode;

@end
