//
//  UIImage+MPHash.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 19/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MPHash)

- (NSUInteger)mp_fnvHash;

@end

NS_ASSUME_NONNULL_END
