//
//  MPGraphEdgePropertyProtocol.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 12/12/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPGraphEdgePropertyProtocol <NSObject>

@property (nonatomic, readonly)                   BOOL              directed;       // "oneway" flag
@property (nonatomic, readonly, strong, nullable) NSString*         highway;
@property (nonatomic, readonly, strong, nullable) NSString*         context;
@property (nonatomic, readonly)                   NSUInteger        distance;       // mm
@property (nonatomic, readonly)                   double            speedFactor;
@property (nonatomic, readonly)                   NSTimeInterval    waittime;

- (BOOL) haveSameGraphEdgeProperties:(id<MPGraphEdgePropertyProtocol>)otherObject;

@end

NS_ASSUME_NONNULL_END
