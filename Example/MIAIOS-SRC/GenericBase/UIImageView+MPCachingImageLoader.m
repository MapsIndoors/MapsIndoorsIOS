//
//  UIImageView+MPCachingImageLoader.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 24/03/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import "UIImageView+MPCachingImageLoader.h"
#import <MapsIndoors/MapsIndoors.h>


@implementation UIImageView (MPCachingImageLoader)

- (void) mp_setImageWithURL:(NSString*)url placeholderImageName:(NSString*)placeholderImageName {
    
    [self mp_setImageWithURL:url placeholderImage:[UIImage imageNamed:placeholderImageName]];
}

- (void) mp_setImageWithURL:(NSString*)url {
    
    NSString*   imageName = [url lastPathComponent];        // If we should happen to have an embedded image with a matching name (we do for venue images), use that as placeholder.
    
    [self mp_setImageWithURL:url placeholderImageName:imageName];
}

- (void) mp_setImageWithURL:(NSString*)url placeholderImage:(UIImage*)placeholderImage {
    
    if ( url.length == 0 ) {
        self.image = placeholderImage;
        
    } else {
        
        [MPImageProvider getImageFromUrlStringAsync:url completionHandler:^(UIImage *image, NSError *error) {
            
            if ( image && !error ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIView transitionWithView:self
                                      duration:0.2
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        [UIView transitionWithView:self
                                                          duration:0.2
                                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                                        animations:^{
                                                            self.image = (image && !error) ? image : placeholderImage;
                                                        } completion:NULL];
                                    } completion:NULL];
                });
            }
        }];
    }
}

@end

