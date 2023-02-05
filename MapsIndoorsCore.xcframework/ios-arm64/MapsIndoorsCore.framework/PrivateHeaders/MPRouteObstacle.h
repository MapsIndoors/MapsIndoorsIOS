//
//  MPRouteObstacle.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/09/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPolygonGeometry.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteObstacle : NSObject

@property (nonatomic, strong, readonly) NSString* elementId;
@property (nonatomic, strong, readonly) NSArray<NSString*>* restrictions;
@property (nonatomic, strong, readonly) NSArray<NSString*>* roomIdList;
@property (nonatomic, strong, readonly) NSString* graphId;
@property (nonatomic, strong, readonly) MPPolygonGeometry* geometry;

- (instancetype) initWithDictionary:(NSDictionary<NSString*, id>*) dict;

@end

NS_ASSUME_NONNULL_END
