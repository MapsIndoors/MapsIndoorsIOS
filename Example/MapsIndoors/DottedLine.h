//
//  H3DottedLine.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 24/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Simple UIView for a dotted line
 */
@interface DottedLine : UIView

/**
 *  Set the line's thickness
 */
@property (nonatomic, assign) CGFloat thickness;

/**
 *  Set the line's color
 */
@property (nonatomic, copy) UIColor *color;

/**
 *  Set the length of the dash
 */
@property (nonatomic, assign) CGFloat dashedLength;

/**
 *  Set the gap between dashes
 */
@property (nonatomic, assign) CGFloat dashedGap;

@end
