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
@property (weak, nonatomic) IBOutlet UILabel *lowerLeftBadgeLabel;


- (void) centerTextLabelVertically;

- (void) setBadgeColor:(UIColor*)c andText:(NSString*)s;

@end
