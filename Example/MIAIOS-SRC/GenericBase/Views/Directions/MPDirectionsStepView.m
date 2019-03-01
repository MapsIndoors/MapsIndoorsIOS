//
//  MPDirectionsStepView.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 15/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPDirectionsStepView.h"
#import "MPDirectionsStepViewModel.h"
@import PureLayout;
#import "AppFonts.h"


@interface MPDirectionsStepView ()

@property (nonatomic, weak, readwrite) UIImageView*     manueverImageView;
@property (nonatomic, weak, readwrite) UILabel*         textLabel;

@end


@implementation MPDirectionsStepView

#pragma mark - init

- (instancetype) initWithFrame:(CGRect)aRect {
    
    self = [super initWithFrame:aRect];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder*)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    UIImageView*    img = [[UIImageView alloc] initWithFrame:CGRectZero];
    UILabel*        lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [img configureForAutoLayout];
    [lbl configureForAutoLayout];

    img.contentMode = UIViewContentModeScaleAspectFit;
    
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.numberOfLines = 3;
    lbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
    lbl.font = [AppFonts sharedInstance].directionsFontSmall;
    lbl.textColor = [UIColor darkGrayColor];
    
    [self addSubview:img];
    [self addSubview:lbl];
    
    [img autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [img autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [img autoSetDimensionsToSize:CGSizeMake(21,21)];
    
    [lbl autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [lbl autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:img withOffset:8];
    [lbl autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lbl autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.95 relation:NSLayoutRelationLessThanOrEqual];
    
    self.manueverImageView = img;
    self.textLabel = lbl;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void) configureWithModel:(MPDirectionsStepViewModel*)model {
    
    [self configureWithDescription:model.stepDescription detail:model.stepDetail manuever:model.stepManuever isStairs:model.isStairs];
}

- (void) configureWithDescription:(NSString*)desc detail:(NSString*)detail manuever:(NSString*)manuever isStairs:(BOOL)isStairs {
    
    NSString*   imageName = (manuever.length == 0) ? @"straight" : manuever;
    if ( isStairs ) {
        imageName = @"RouteStepStairs";
    }
    self.manueverImageView.image = [UIImage imageNamed:imageName];

    CGFloat     fontSize = [[AppFonts sharedInstance] scaledFontSizeForFontSize:12];
    self.textLabel.attributedText = [self attributedStringForStep:desc fontSize:fontSize distanceText:detail distanceFontSize:fontSize];
}

#pragma mark - String helpers

- (NSAttributedString*) attributedStringForStep:(NSString*)descr fontSize:(CGFloat)fontSize distanceText:(NSString*)distanceText distanceFontSize:(CGFloat)distanceFontSize {
    
    NSMutableAttributedString*  text = [NSMutableAttributedString new];
    NSAttributedString*         distAttributedString;
    NSAttributedString*         descrAttributedString;
    
    if ( distanceText.length ) {
        NSDictionary*   distanceAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:distanceFontSize], NSForegroundColorAttributeName : [UIColor lightGrayColor] };
        
        distAttributedString = [[NSAttributedString alloc] initWithString:distanceText attributes:distanceAttrs];
    }
    
    if ( descr.length ) {
        
        NSDictionary*   textAttrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName : [UIColor darkGrayColor] };
        
        descrAttributedString = [[NSAttributedString alloc] initWithString:descr attributes:textAttrs];
    }
    
    if ( descrAttributedString && distAttributedString ) {
        [text appendAttributedString:descrAttributedString];
        [text appendAttributedString: [[NSAttributedString alloc] initWithString:@"\n"]];
        [text appendAttributedString:distAttributedString];

    } else if ( distAttributedString ) {
        [text appendAttributedString:distAttributedString];

    } else if ( descrAttributedString ) {
        [text appendAttributedString:descrAttributedString];
    }
    
    return [text copy];
}

@end
