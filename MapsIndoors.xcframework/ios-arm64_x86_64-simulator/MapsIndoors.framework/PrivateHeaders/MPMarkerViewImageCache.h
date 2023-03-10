//
//  MPMarkerView+ImageCache.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/04/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPMarkerView.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface MPMarkerViewImageCache : NSObject

+ (void) setupCacheIfNeeded;
+ (nullable UIImage*) getImageForKey: (nonnull NSString*) key;
+ (void) setImage: (UIImage*) image forKey: (NSString*) key;

@end


NS_ASSUME_NONNULL_END
