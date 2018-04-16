//
//  MPLocationCell.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 01/08/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPLocationCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTextLabel;

- (void) centerTextLabelVertically;

@end
