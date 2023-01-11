//
//  UIImage+MapsIndoorsSDK.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/12/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MapsIndoorsSDK)

- (BOOL) mp_isBlankImage;

+ (UIImage*) mp_transparentImageWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
