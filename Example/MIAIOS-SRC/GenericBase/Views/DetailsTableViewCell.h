//
//  DetailsTableViewCell.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 16/06/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewCell : UITableViewCell

@property (nonatomic) BOOL      showSeparator;
@property (nonatomic) BOOL      showActivityIndicator;
@property (nonatomic) BOOL      compactHeight;

- (void) configureWithTitle:(id)title subTitle:(NSString*)subTitle image:(UIImage*)image;
- (void) configureWithTitle:(id)title titleColor:(UIColor*)titleColor image:(UIImage*)image imageTintColor:(UIColor*)imageTintColor;

@end
