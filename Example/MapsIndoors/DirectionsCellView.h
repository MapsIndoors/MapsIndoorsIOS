//
//  DirectionsCellView.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 24/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DottedLine.h"

@interface DirectionsCellView : UITableViewCell


@property (nonatomic, weak) IBOutlet UIImageView *firstIcon;
@property (nonatomic, weak) IBOutlet UIImageView *secondIcon;
@property (nonatomic, weak) IBOutlet UILabel *firstLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondLabel;
@property (nonatomic, weak) IBOutlet DottedLine *lineTop;
@property (nonatomic, weak) IBOutlet DottedLine *lineMiddle;
@property (nonatomic, weak) IBOutlet DottedLine *lineBottom;
@property (nonatomic, weak) IBOutlet UIView *highlightView;


@end
