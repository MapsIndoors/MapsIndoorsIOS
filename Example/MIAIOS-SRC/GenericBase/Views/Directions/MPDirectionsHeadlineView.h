//
//  MPHorizontalDirectionsHeadlineView.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 07/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPDirectionsViewHeadlineModel;


@interface MPDirectionsHeadlineView : UIView

@property (nonatomic) BOOL      verticalLayout;
@property (nonatomic) UIFont*   fontForVerticalLayout;
@property (nonatomic) UIFont*   fontForHorizonalLayout;

- (void) configureWithModel:(MPDirectionsViewHeadlineModel*)model;

- (BOOL) isHitForDirectionsLabel:(CGPoint)point;

@end
