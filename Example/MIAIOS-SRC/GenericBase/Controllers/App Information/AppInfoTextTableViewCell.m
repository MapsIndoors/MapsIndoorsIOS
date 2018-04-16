//
//  AppInfoVersionTableViewCell.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 12/10/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "AppInfoTextTableViewCell.h"
#import "UIColor+AppColor.h"


@interface AppInfoTextTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel*   leftText;
@property (weak, nonatomic) IBOutlet UILabel*   rightText;
@property (nonatomic, readwrite) BOOL           selectable;

@end


@implementation AppInfoTextTableViewCell

- (void) configureWithText:(NSString*)text detail:(NSString*)detail {
    
    [self configureWithText:text detail:detail selectable:NO];
}

- (void) configureWithText:(NSString*)text detail:(NSString*)detail selectable:(BOOL)selectable {
    
    self.leftText.text = text;
    self.rightText.text = detail;
    self.selectable = selectable;
    
    UIColor*    color = self.selectable ? [UIColor appTertiaryHighlightColor] : [UIColor appPrimaryTextColor];
    self.leftText.textColor = color;
    self.rightText.textColor = color;

    if ( self.selectable ) {
        self.leftText.font = [UIFont boldSystemFontOfSize:15];
        self.rightText.font = self.leftText.font;
    }
}

@end
