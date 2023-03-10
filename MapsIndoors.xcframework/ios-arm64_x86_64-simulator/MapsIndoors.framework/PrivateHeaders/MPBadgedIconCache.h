//
//  MPBadgedIconCache.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 19/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPBadgedIconCache : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSNumber*, UIImage*>* cache;

@end

NS_ASSUME_NONNULL_END
