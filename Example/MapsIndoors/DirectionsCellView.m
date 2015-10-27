//
//  DirectionsCellView.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 24/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "DirectionsCellView.h"
#import "UIColor+AppColor.h"

@implementation DirectionsCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (id)init
//{
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DirectionsCellView" owner:self options:nil];
//    self = [nib objectAtIndex:0];
//
//    return self;
//}

//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        // Do your custom initialization here
//    }
//    return self;
//}
//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DirectionsCellView" owner:self options:nil];
//    self = [nib objectAtIndex:0];
//    return self;
//}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted)
        self.highlightView.backgroundColor = [UIColor appLightPrimaryColor];
    else self.highlightView.backgroundColor = nil;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted)
        self.highlightView.backgroundColor = [UIColor appLightPrimaryColor];
    else self.highlightView.backgroundColor = nil;
}

- (void)setSelected:(BOOL)selected {
    if (selected)
        self.highlightView.backgroundColor = [UIColor appLightPrimaryColor];
    else self.highlightView.backgroundColor = nil;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected)
        self.highlightView.backgroundColor = [UIColor appLightPrimaryColor];
    else self.highlightView.backgroundColor = nil;
}

@end
