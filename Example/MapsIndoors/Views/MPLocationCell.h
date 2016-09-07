//
//  MPLocationCell.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 01/08/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPLocationCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *floorLabel;
@property (nonatomic, weak) IBOutlet UILabel *buildingLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *floorIcon;
@property (nonatomic, weak) IBOutlet UIImageView *buildingIcon;
@property (nonatomic, weak) IBOutlet UIImageView *distanceIcon;


@end
