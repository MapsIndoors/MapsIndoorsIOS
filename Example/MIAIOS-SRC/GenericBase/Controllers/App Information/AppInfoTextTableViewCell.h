//
//  AppInfoVersionTableViewCell.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 12/10/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppInfoTextTableViewCell : UITableViewCell

@property (nonatomic, readonly) BOOL            selectable;

- (void) configureWithText:(NSString*)text detail:(NSString*)detail;
- (void) configureWithText:(NSString*)text detail:(NSString*)detail selectable:(BOOL)selectable;

@end
