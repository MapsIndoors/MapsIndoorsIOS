//
//  UIImageView+MPCachingImageLoader.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 24/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MPImageProvider)

- (void) mp_setImageWithURL:(NSString*)url size:(CGSize)size;
- (void) mp_setImageWithURL:(NSString*)url size:(CGSize)size placeholderImage:(UIImage*)placeholderImage;
- (void) mp_setImageWithURL:(NSString*)url size:(CGSize)size placeholderImageName:(NSString*)placeholderImageName;

@end
