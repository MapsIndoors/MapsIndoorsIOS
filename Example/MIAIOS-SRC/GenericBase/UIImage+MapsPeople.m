//
//  UIImage+MapsPeople.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 02/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "UIImage+MapsPeople.h"

@implementation UIImage (MapsPeople)

+ (UIImage*) imageWithRepeatingDots:(CGSize)imageSize
                            dotSize:(CGFloat)dotSize
                        dotInterval:(CGFloat)dotInterval
                           dotColor:(UIColor*)dotColor
                      startEndInset:(CGFloat)inset
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    imageSize.width  *= scale;
    imageSize.height *= scale;
    dotSize          *= scale;
    dotInterval      *= scale;
    inset            *= scale;
    
    NSInteger   numberOfDots = 0;
    CGFloat     x = 0;
    CGFloat     y = 0;
    CGFloat     dx = 0;
    CGFloat     dy = 0;
    
    if ( imageSize.width > imageSize.height ) {     // Horizontal layout
        CGFloat widthForDots = (imageSize.width - 2.0*inset);
        numberOfDots = MAX( 1, widthForDots / dotInterval );
        dotInterval = widthForDots / (CGFloat)numberOfDots;
        x = inset + dotInterval / 2.0 - dotSize / 2.0;
        y = (imageSize.height - dotSize) / 2.0;
        dx = dotInterval;
    } else {
        CGFloat heightForDots = (imageSize.height - 2.0*inset);
        numberOfDots = MAX( 1, heightForDots / dotInterval );
        dotInterval = heightForDots / (CGFloat)numberOfDots;
        y = inset + dotInterval / 2.0 - dotSize / 2.0;
        x = (imageSize.width - dotSize) / 2.0;
        dy = dotInterval;
    }
    
    UIGraphicsBeginImageContext( imageSize );
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor( ctx, dotColor.CGColor);
    
    CGRect circleRect = CGRectMake( x, y, dotSize, dotSize );
    for ( ; numberOfDots > 0; --numberOfDots ) {
        CGContextFillEllipseInRect( ctx, circleRect );
        
        circleRect.origin.x += dx;
        circleRect.origin.y += dy;
    }
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) imageSolidBar:(CGSize)imageSize
               barFraction:(CGFloat)barFraction
                  barColor:(UIColor*)color
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    imageSize.width  *= scale;
    imageSize.height *= scale;
    
    CGRect r;
    
    if ( imageSize.width > imageSize.height ) {     // Horizontal layout
        CGFloat barHeight = imageSize.height * barFraction;
        CGFloat y = MAX( 0, (imageSize.height - barHeight) / 2 );
        r = CGRectMake(0, y, imageSize.width, barHeight );
    } else {
        CGFloat barWidth = imageSize.width * barFraction;
        CGFloat x = MAX( 0, (imageSize.width- barWidth) / 2 );
        r = CGRectMake(x, 0, barWidth, imageSize.height );
    }
    
    UIGraphicsBeginImageContext( imageSize );
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( ctx, color.CGColor);
    CGContextFillRect( ctx, r );
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*) circleImageForSize:(CGSize)imageSize
                 circleFraction:(CGFloat)circleFraction
                      lineWidth:(CGFloat)lineWidth
                      lineColor:(UIColor*)lineColor
                      fillColor:(UIColor*)fillColor
                    innerCircle:(BOOL)innerCircle
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    imageSize.width   *= scale;
    imageSize.height  *= scale;
    lineWidth         *= scale;

    CGFloat squareSize = MIN(imageSize.width, imageSize.height);
    CGFloat circleDiameter = squareSize * circleFraction;
    CGRect  circleRect = CGRectMake( 0, 0, circleDiameter -lineWidth, circleDiameter -lineWidth );
    
    circleRect.origin.x += (imageSize.width - circleRect.size.width) / 2;
    circleRect.origin.y += (imageSize.height - circleRect.size.height) / 2;
    
    UIGraphicsBeginImageContext( imageSize );
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( ctx, fillColor.CGColor);
    CGContextSetLineWidth( ctx, lineWidth );
    CGContextSetStrokeColorWithColor( ctx, lineColor.CGColor);
    
    CGContextFillEllipseInRect( ctx, circleRect );
    CGContextStrokeEllipseInRect( ctx, circleRect );
    
    if ( innerCircle ) {
        CGRect  circleRect = CGRectMake( 0, 0, circleDiameter -4*lineWidth, circleDiameter -4*lineWidth );
        
        circleRect.origin.x += (imageSize.width - circleRect.size.width) / 2;
        circleRect.origin.y += (imageSize.height - circleRect.size.height) / 2;
    
        CGContextSetFillColorWithColor( ctx, lineColor.CGColor);
        CGContextFillEllipseInRect( ctx, circleRect );
    }
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*) imageWithEmbeddedImage:(UIImage*)innerImage
                 innerImageFraction:(CGFloat)innerImageFraction
{
    UIImage*    result = self;
    
    if ( innerImage ) {
        CGFloat h = self.size.height * innerImageFraction;
        CGFloat w = self.size.width  * innerImageFraction;
        CGRect  innerRect = CGRectMake( (self.size.width - w) / 2, (self.size.height - h) / 2, w, h );
        
        UIGraphicsBeginImageContextWithOptions( self.size, NO, self.scale );
        [self drawInRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height)];
        [innerImage drawInRect:innerRect];
        UIImage*    newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if ( newImage ) {
            result = newImage;
        }
    }
    
    return result;
}

- (UIImage*) imageWithEmbeddedImageNamed:(NSString*)innerImageName
                      innerImageFraction:(CGFloat)innerImageFraction
{
    UIImage*    result = self;
    if (innerImageName) {
        result = [self imageWithEmbeddedImage:[UIImage imageNamed:innerImageName] innerImageFraction:innerImageFraction];
    }
    return result;
}

@end
