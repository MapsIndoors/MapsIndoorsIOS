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

- (NSCharacterSet*) mp_urlEscapingCharacterSet {

    static NSCharacterSet*  _urlEscapingCharacterSet;
    static dispatch_once_t  onceToken;

    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet*  set = [NSMutableCharacterSet new];

        [set formUnionWithCharacterSet:[NSCharacterSet URLPathAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLHostAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLUserAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLPasswordAllowedCharacterSet]];

        _urlEscapingCharacterSet = [set copy];
    });

    return _urlEscapingCharacterSet;
}

- (void) mp_setImageWithURL:(NSString*)url size:(CGSize)size placeholderImageName:(NSString*)placeholderImageName {

    [self mp_setImageWithURL:url size:(CGSize)size placeholderImage:[UIImage imageNamed:placeholderImageName]];
}

- (void) mp_setImageWithURL:(NSString*)url size:(CGSize)size {

    NSString*   imageName = [url lastPathComponent];        // If we should happen to have an embedded image with a matching name (we do for venue images), use that as placeholder.

    [self mp_setImageWithURL:url size:(CGSize)size placeholderImageName:imageName];
}

- (void) mp_setImageWithURL:(NSString*)url size:(CGSize)size placeholderImage:(UIImage*)placeholderImage {

    if ( [url containsString:@"%"] == NO ) {        // We get URLs that area already URL-escaped and some that are not: assume URL-escaping has already been performed if the url-string contains %-characters.
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[self mp_urlEscapingCharacterSet]];
    }

    if ( url.length == 0 ) {
        self.image = placeholderImage;

    } else {

        [MapsIndoors.imageProvider getImageFromUrlStringAsync:url imageSize:size completionHandler:^(UIImage *image, NSError *error) {

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

