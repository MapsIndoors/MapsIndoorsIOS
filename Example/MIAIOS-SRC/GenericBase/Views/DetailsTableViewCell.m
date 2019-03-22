//
//  DetailsTableViewCell.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 16/06/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "DetailsTableViewCell.h"
#import "UIColor+AppColor.h"
#import "AppFonts.h"
#import "NSObject+ContentSizeChange.h"


@interface DetailsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView*               detailImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint*        detailImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel*                   detailLabel;
@property (weak, nonatomic) IBOutlet UIView*                    separatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView*   activityIndicator;

@end


@implementation DetailsTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];

    self.detailLabel.textColor = [UIColor appPrimaryTextColor];
}

- (void) prepareForReuse {
    [super prepareForReuse];
    
    self.detailImageView.image = nil;
    self.detailImageView.tintColor = nil;
    self.detailImageView.alpha = 1;
    self.detailLabel.textColor = [UIColor appPrimaryTextColor];
    self.showSeparator = NO;
    self.showActivityIndicator = NO;
    [self.activityIndicator stopAnimating];
}

- (void) configureWithTitle:(id)title subTitle:(NSString*)subTitle image:(UIImage*)image {
    
    self.detailImageView.image = image;
    self.detailImageView.contentMode = UIViewContentModeCenter;
    self.detailImageViewWidthConstraint.constant = image ? 54 : 0;
    self.detailLabel.font = [AppFonts sharedInstance].listItemFont;

    if ( [title isKindOfClass:[NSAttributedString class]] ) {
        title = [(NSAttributedString*)title string];
    }

    NSMutableAttributedString* s = [NSMutableAttributedString new];
    
    if ( [title isKindOfClass:[NSAttributedString class]] ) {
        [s appendAttributedString:title];
    } else if ( title ) {
        [s appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
    }
    
    if ( subTitle ) {
        
        subTitle = [NSString stringWithFormat:@"\n%@", subTitle];
        
        NSDictionary*   attrs = @{ NSFontAttributeName:[AppFonts sharedInstance].listItemSubTextFont, NSForegroundColorAttributeName:[UIColor appSecondaryTextColor] };
        
        NSMutableAttributedString*  attributedSubTitle = [[NSMutableAttributedString alloc] initWithString:subTitle];
        [attributedSubTitle setAttributes:attrs range:NSMakeRange(0, subTitle.length)];

        [s appendAttributedString:attributedSubTitle];
    }

    self.detailLabel.attributedText = [s copy];
}

- (void) configureWithTitle:(id)title titleColor:(UIColor*)titleColor image:(UIImage*)image imageTintColor:(UIColor*)imageTintColor {
    
    if ( imageTintColor ) {
        self.detailImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.detailImageView.tintColor = imageTintColor;
    } else {
        self.detailImageView.image = image;
    }
    self.detailImageView.contentMode = UIViewContentModeCenter;
    self.detailImageViewWidthConstraint.constant = image ? 54 : 0;
    
    NSMutableAttributedString* s = [NSMutableAttributedString new];
    
    if ( [title isKindOfClass:[NSAttributedString class]] ) {
        [s appendAttributedString:title];
    } else if ( title ) {
        [s appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
    }

    self.detailLabel.font = [AppFonts sharedInstance].listItemFont;
    self.detailLabel.textColor = titleColor;
    self.detailLabel.attributedText = [s copy];
}

-  (void) setShowSeparator:(BOOL)showSeparator {
    
    if ( _showSeparator != showSeparator ) {
        _showSeparator = showSeparator;
        
        self.separatorView.hidden = _showSeparator == NO;
    }
}

- (void) setShowActivityIndicator:(BOOL)showActivityIndicator {
    
    if ( _showActivityIndicator != showActivityIndicator ) {
        _showActivityIndicator = showActivityIndicator;
        
        if ( showActivityIndicator ) {
            [self.activityIndicator startAnimating];
        } else {
            [self.activityIndicator stopAnimating];
        }
    }
}

@end
