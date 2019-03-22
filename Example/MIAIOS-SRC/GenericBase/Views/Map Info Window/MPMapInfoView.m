//
//  MPMapInfoView.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 30/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPMapInfoView.h"
#import "UIColor+AppColor.h"
#import <MapsIndoors/MPLocation.h>
#import <PureLayout/PureLayout.h>
#import "AppFonts.h"


@interface MPMapInfoView ()

@property (weak, nonatomic) IBOutlet UIView*        backgroundView;
@property (weak, nonatomic) IBOutlet UIView*        dropArrowView;
@property (weak, nonatomic) IBOutlet UILabel*       infoLabel;
@property (strong, nonatomic) NSLayoutConstraint*   heightConstraint;
@property (strong, nonatomic) NSLayoutConstraint*   widthConstraint;

@end


@implementation MPMapInfoView

+ (instancetype) createMapInfoWindowForLocation:(MPLocation*)model {
    
    MPMapInfoView*  newMapInfoWindow;
    
    if ( model ) {
        
        NSArray*            nib = [[NSBundle mainBundle] loadNibNamed:@"MPMapInfoView" owner:self options:nil];
        newMapInfoWindow = [nib objectAtIndex:0];
        [newMapInfoWindow configureMapInfoWindowForLocation:model];
    }
    
    return newMapInfoWindow;
}

- (void) configureMapInfoWindowForLocation:(MPLocation*)model {
    
    self.backgroundView.backgroundColor = [UIColor darkGrayColor];
    CALayer* drop = [self.dropArrowView layer];
    drop.borderColor = [UIColor darkGrayColor].CGColor;
    drop.borderWidth = 1.5f;
    drop.transform = CATransform3DMakeRotation(M_PI*0.25, 0, 0.0, 1.0);
    self.infoLabel.text = model.name;
    self.infoLabel.textColor = [UIColor appTertiaryHighlightColor];
    self.infoLabel.font = [AppFonts sharedInstance].infoWindowFont;
    [self.infoLabel sizeToFit];
    [self.infoLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(4, 8, 4, 8)];
    
    CGSize labelContentSize = self.infoLabel.intrinsicContentSize;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 4;
    self.layer.shadowOffset = CGSizeMake(2, 2);

    CGFloat hScale =  [AppFonts sharedInstance].fontSizeScaleFactor > 1.2 ? 1.2 : 1;
    CGFloat h = self.bounds.size.height * hScale;
    self.heightConstraint = [self autoSetDimension:ALDimensionHeight toSize:h];
    self.widthConstraint = [self autoSetDimension:ALDimensionWidth toSize:labelContentSize.width+2*8 relation:NSLayoutRelationLessThanOrEqual];
    
    [self layoutIfNeeded];
}

@end
