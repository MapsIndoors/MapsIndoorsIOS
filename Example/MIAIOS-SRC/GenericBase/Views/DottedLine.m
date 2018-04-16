//
//  DottedLine.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 24/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "DottedLine.h"

#import <UIKit/UIKit.h>


@implementation DottedLine

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Set Default Values
        _thickness = 1.0f;
        _color = [UIColor whiteColor];
        _dashedGap = 1.0f;
        _dashedLength = 5.0f;
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)layoutSubviews {
    // Note, this object draws a straight line. If you wanted the line at an angle you simply need to adjust the start and/or end point here.
    [self updateLine];
}

#pragma mark - Setters

- (void)setThickness:(CGFloat)thickness {
    _thickness = thickness;
    [self setNeedsLayout];
}

- (void)setColor:(UIColor *)color {
    _color = [color copy];
    [self setNeedsLayout];
}

- (void)setDashedGap:(CGFloat)dashedGap {
    _dashedGap = dashedGap;
    [self setNeedsLayout];
}

- (void)setDashedLength:(CGFloat)dashedLength {
    _dashedLength = dashedLength;
    [self setNeedsLayout];
}

#pragma mark - Draw Methods

-(void)updateLine {
    
    // Important, otherwise we will be adding multiple sub layers
    if ([[[self layer] sublayers] objectAtIndex:0]) {
        self.layer.sublayers = nil;
    }
    
    CAShapeLayer *_border = [CAShapeLayer layer];
    _border.strokeColor = self.color.CGColor;
    _border.fillColor = nil;
    _border.lineDashPattern = @[@(self.dashedLength), @(self.dashedGap)];
    _border.lineWidth = self.thickness;
    _border.fillColor = [UIColor clearColor].CGColor;
    [_border setLineJoin:kCALineJoinRound];
    [self.layer addSublayer:_border];
    
//    _border.path = [UIBezierPath bezierPathWith:self.bounds].CGPath;
    _border.frame = self.bounds;
    CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, _border.frame.size.width, _border.frame.size.height);
    _border.path = path;
        CGPathRelease(path);
    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    [shapeLayer setBounds:self.bounds];
//    [shapeLayer setPosition:CGPointMake(0, 0)];
//    [shapeLayer setStrokeColor:self.color.CGColor];
//    [shapeLayer setLineWidth:self.thickness];
//    [shapeLayer setLineJoin:kCALineJoinRound];
//    [shapeLayer setLineDashPattern:@[@(self.dashedLength), @(self.dashedGap)]];
    
    // Setup the path
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, beginPoint.x, beginPoint.y);
//    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
//    [shapeLayer setPath:path];
//    CGPathRelease(path);
//    
//    [[self layer] addSublayer:shapeLayer];
    
}

@end
