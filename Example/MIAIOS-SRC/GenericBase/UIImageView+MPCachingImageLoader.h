//
//  UIImageView+MPCachingImageLoader.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 24/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MPImageProvider)

- (void) mp_setImageWithURL:(NSString*)url;
- (void) mp_setImageWithURL:(NSString*)url placeholderImage:(UIImage*)placeholderImage;
- (void) mp_setImageWithURL:(NSString*)url placeholderImageName:(NSString*)placeholderImageName;

@end
