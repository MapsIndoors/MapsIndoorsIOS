//
//  MPHorizontalDirectionsHeadlineView.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 07/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPDirectionsHeadlineView.h"
#import "MPDirectionsViewHeadlineModel.h"
#import "UIImageView+MPCachingImageLoader.h"
@import VCMaterialDesignIcons;


@interface MPDirectionsHeadlineView ()

@property (nonatomic, weak) UIImageView*    imageView;
@property (nonatomic, weak) UILabel*        directionsLabel;
@property (nonatomic, weak) UILabel*        directionsRightLabel;
@property (nonatomic, weak) UIView*         textBackgroundView;
@property (nonatomic, weak) UILabel*        directionsDetailLabel;
@property (nonatomic, readonly) UIFont*     currentFont;

@end


@implementation MPDirectionsHeadlineView

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
    self.clipsToBounds = YES;
}

- (UIFont *)fontForHorizonalLayout {
    
    if ( _fontForHorizonalLayout == nil ) {
        _fontForHorizonalLayout = [UIFont systemFontOfSize:11];
    }
    return _fontForHorizonalLayout;
}

- (UIFont*) fontForVerticalLayout {

    if ( _fontForVerticalLayout == nil ) {
        _fontForVerticalLayout = [UIFont systemFontOfSize:13];
    }
    return _fontForVerticalLayout;
}

- (UIFont *)currentFont {
    
    return self.verticalLayout ? self.fontForVerticalLayout : self.fontForHorizonalLayout;
}

- (void) updateLabelFonts {

    self.directionsLabel.font = self.currentFont;
    self.directionsRightLabel.font = self.currentFont;
    self.directionsDetailLabel.font = self.currentFont;
}

- (void)setVerticalLayout:(BOOL)verticalLayout {
    
    if ( _verticalLayout != verticalLayout ) {
        _verticalLayout = verticalLayout;
        
        [self updateLabelFonts];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat availableWidth = self.bounds.size.width;
    CGFloat horizontalPadding = 0;
    
    if ( self.verticalLayout == NO ) {
        horizontalPadding = 8;
        availableWidth -= 2 * horizontalPadding;
    } else {
    }
    
    CGSize  imageSize = CGSizeZero;
    if ( self.imageView ) {
        
        CGFloat imageHW = (self.bounds.size.height > 21) ? 21 : self.bounds.size.height;
        imageSize = CGSizeMake( imageHW, imageHW );      // Square image!
    }
    
    CGSize  textSize = CGSizeZero;
    CGFloat maxTextWidth = availableWidth -imageSize.width -8;  // -8: Allow for some left/right padding
    if ( self.directionsLabel.text.length == 0 ) {
        self.directionsLabel.text = @" ";
        textSize = [self.directionsLabel sizeThatFits:CGSizeMake(maxTextWidth,FLT_MAX)];
        textSize.width = 0;
        self.directionsLabel.text = @"";
    
    } else if ( self.directionsLabel ) {
        textSize = [self.directionsLabel sizeThatFits:CGSizeMake(maxTextWidth,FLT_MAX)];
        
        CGFloat textSizeMax = self.verticalLayout ? ((availableWidth -8) / 2) : availableWidth * 0.8;
        CGFloat textSizeMin = 16;
        if ( textSize.width > textSizeMax ) {
            textSize.width = textSizeMax;
        } else if ( textSize.width < textSizeMin ) {
            textSize.width = textSizeMin;
        }
        textSize.width += 8;
    }

    if ( textSize.height > self.bounds.size.height ) {
        textSize.height = self.bounds.size.height;
    }
    
    CGFloat x = 0;
    if ( self.verticalLayout == NO ) {
        CGFloat widthToCenter = imageSize.width + textSize.width;
        if ( imageSize.width && textSize.width ) {
            widthToCenter += 4;     // padding between image and text.
        }
        
        x = (availableWidth - widthToCenter) / 2;
    } else {
        
    }
    
    CGRect  imageRect = CGRectZero;
    CGRect  directionsLabelRect = CGRectZero;
    CGRect  directionsLabelBackgroundRect = CGRectZero;
    CGRect  directionsRightLabelRect = CGRectZero;
    CGRect  directionsDetailLabelRect = CGRectZero;

    if ( imageSize.width ) {
        x += horizontalPadding;
        imageRect = CGRectMake(x, (self.bounds.size.height - imageSize.height) / 2, imageSize.width, imageSize.height);
        x += imageSize.width;
    }
    if ( textSize.width ) {
        x += 4;
        if ( textSize.width < (textSize.height +4) ) {  // Since we round the corners, we need to make sure we have enough space to complete the arc.  +4 is so we get a (little) horinzontal stretch.
            textSize.width = textSize.height +4;
        }
        directionsLabelRect = CGRectMake(x +4, (self.bounds.size.height - textSize.height) / 2, textSize.width -8, textSize.height);
        directionsLabelBackgroundRect = CGRectMake(x, (self.bounds.size.height - textSize.height) / 2, textSize.width, textSize.height);
    } else {
        directionsLabelRect = CGRectMake(x, (self.bounds.size.height - textSize.height) / 2, 0, textSize.height);
    }
    
    if ( self.verticalLayout ) {
        CGRect rRightLabel = CGRectMake( CGRectGetMaxX(directionsLabelRect) + 8,
                                         CGRectGetMinY(directionsLabelRect),
                                         availableWidth -CGRectGetMaxX(directionsLabelRect),
                                         directionsLabelRect.size.height );
        directionsRightLabelRect = rRightLabel;
        self.directionsRightLabel.hidden = NO;
        
        self.directionsDetailLabel.hidden = self.directionsDetailLabel.text.length == 0;
        if ( self.directionsDetailLabel.hidden == NO ) {
            directionsDetailLabelRect = directionsLabelRect;
            if ( textSize.width == 0 ) {
                directionsDetailLabelRect.origin.x += 8;
            }
            directionsDetailLabelRect.size.width = availableWidth - directionsDetailLabelRect.origin.x;
            
            CGFloat dy = directionsLabelRect.size.height * 0.66;
            directionsLabelRect.origin.y -= dy;
            directionsLabelBackgroundRect.origin.y = directionsRightLabelRect.origin.y = directionsLabelRect.origin.y;
            directionsDetailLabelRect.origin.y += dy;
            
            self.directionsDetailLabel.hidden = NO;
        }
    } else {
        self.directionsRightLabel.hidden = YES;
        self.directionsDetailLabel.hidden = YES;
    }
    
    // Move around the views:
    self.imageView.frame = imageRect;
    self.directionsLabel.frame = directionsLabelRect;
    self.textBackgroundView.frame = directionsLabelBackgroundRect;
    self.textBackgroundView.layer.cornerRadius = directionsLabelBackgroundRect.size.height / 2;
    self.directionsRightLabel.frame = directionsRightLabelRect;
    self.directionsDetailLabel.frame = directionsDetailLabelRect;
}

- (void) configureWithModel:(MPDirectionsViewHeadlineModel*)model {
    
    if ( self.imageView == nil ) {
        
        UIImageView*    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        
        UIView*         textBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        textBackgroundView.layer.masksToBounds = YES;
        
        UILabel*        directionsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        directionsLabel.textColor = model.textColor;
        directionsLabel.textAlignment = NSTextAlignmentCenter;
        directionsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        directionsLabel.numberOfLines = 1;

        UILabel*        directionsRightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        directionsRightLabel.textColor = [UIColor lightGrayColor];
        directionsRightLabel.textAlignment = NSTextAlignmentLeft;
        directionsRightLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        directionsRightLabel.numberOfLines = 1;
        
        UILabel*        directionsDetailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        directionsDetailLabel.textColor = [UIColor lightGrayColor];
        directionsDetailLabel.textAlignment = NSTextAlignmentLeft;
        directionsDetailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        directionsDetailLabel.numberOfLines = 1;
        
        // Add subviews:
        [self addSubview: imageView ];
        [self addSubview:textBackgroundView];
        [self addSubview: directionsLabel ];
        [self addSubview:directionsRightLabel];
        [self addSubview:directionsDetailLabel];
        
        // Remember views for easy access:
        self.imageView = imageView;
        self.textBackgroundView = textBackgroundView;
        self.directionsLabel = directionsLabel;
        self.directionsRightLabel = directionsRightLabel;
        self.directionsDetailLabel = directionsDetailLabel;
    }

    [self updateLabelFonts];

    if ( self.verticalLayout ) {
        self.directionsLabel.text = model.text.length ? model.text : model.travelModeText;
    } else {
        self.directionsLabel.text = model.text;
    }
    self.directionsLabel.textColor = model.textColor ?: [UIColor darkGrayColor];
    self.directionsRightLabel.text = model.primaryTextRight;
    self.textBackgroundView.backgroundColor = model.color;
    self.directionsDetailLabel.text = model.detailText;
    self.directionsDetailLabel.textColor = model.detailTextColor ?: [UIColor darkGrayColor];
    
    if ( model.imageUrl ) {
        [self.imageView mp_setImageWithURL:model.imageUrl];
        
    } else if ( model.materialDesignIconCode ) {
        VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:model.materialDesignIconCode fontSize:18];
        if ( model.iconColor ) {
            [icon addAttribute:NSForegroundColorAttributeName value:model.iconColor];
        }
        self.imageView.image = icon.image;
    }

    [self setNeedsLayout];
}


- (BOOL) isHitForDirectionsLabel:(CGPoint)point {
    
    CGRect rDirections = CGRectMake( self.directionsDetailLabel.frame.origin.x, self.directionsDetailLabel.frame.origin.y -12, self.directionsDetailLabel.frame.size.width, self.directionsDetailLabel.frame.size.height +24);
        
    return CGRectContainsPoint(rDirections, point);
}

#pragma mark - Debug

- (NSString *) description {
    
    NSMutableString*    s = [NSMutableString stringWithFormat:@"<MPDirectionsHeadlineView %p: frame=%@:%@ - %@:%@", self, @(self.frame.origin.x), @(self.frame.origin.y), @(self.frame.size.width), @(self.frame.size.height)];
    [s appendFormat:@"\n  image.frame = %@:%@ - %@:%@", @(self.imageView.frame.origin.x), @(self.imageView.frame.origin.y), @(self.imageView.frame.size.width), @(self.imageView.frame.size.height)];
    [s appendFormat:@"\n  topL.frame = %@:%@ - %@:%@", @(self.directionsLabel.frame.origin.x), @(self.directionsLabel.frame.origin.y), @(self.directionsLabel.frame.size.width), @(self.directionsLabel.frame.size.height)];
    [s appendFormat:@"\n  topR.frame = %@:%@ - %@:%@", @(self.directionsRightLabel.frame.origin.x), @(self.directionsRightLabel.frame.origin.y), @(self.directionsRightLabel.frame.size.width), @(self.directionsRightLabel.frame.size.height)];
    [s appendFormat:@"\n  detail.frame = %@:%@ - %@:%@", @(self.directionsDetailLabel.frame.origin.x), @(self.directionsDetailLabel.frame.origin.y), @(self.directionsDetailLabel.frame.size.width), @(self.directionsDetailLabel.frame.size.height)];
    return [s copy];
}

@end
