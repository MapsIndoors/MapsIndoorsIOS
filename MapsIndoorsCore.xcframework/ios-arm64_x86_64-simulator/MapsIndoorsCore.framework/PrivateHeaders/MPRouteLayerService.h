//
//  MPRouteLayerService.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/09/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPGraphEdge.h"
#import "MPRouteObstacle.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^mpRouteElementsCompletion)(NSError* _Nullable error);

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteLayerService : NSObject

- (NSArray<MPRouteObstacle*>*) obstaclesForLocationsWithIds:(NSArray<NSString*>*) locationIds;
- (void) synchronizeObstacles:(mpRouteElementsCompletion)completionHandler;

@end

NS_ASSUME_NONNULL_END
