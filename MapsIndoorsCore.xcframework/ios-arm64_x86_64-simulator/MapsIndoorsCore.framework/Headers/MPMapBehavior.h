//
//  MPMapBehavior.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 24/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPMapBehavior <NSObject>

@property (nonatomic, class, readonly) id<MPMapBehavior> defaultBehavior;
@property (nonatomic) BOOL moveCamera;
@property (nonatomic) BOOL showInfoWindow;

@end

NS_ASSUME_NONNULL_END
