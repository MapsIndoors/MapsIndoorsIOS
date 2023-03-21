//
//  MPManualGraphEdgeProperties.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 12/12/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPGraphEdgePropertyProtocol.h"

@class MPHighway;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPManualGraphEdgeProperties : NSObject <MPGraphEdgePropertyProtocol>

+ (instancetype) newGraphEdgePropertiesWithContext:(NSString*)context
                                           highway:(MPHighway*)highway
                                          distance:(NSUInteger)distance
                                       speedFactor:(double)speedFactor
                                          waittime:(NSTimeInterval)waittime
                                          directed:(BOOL)directed
                                                  ;

+ (instancetype) newDirectedGraphEdgePropertiesWithContext:(NSString*)context
                                                   highway:(MPHighway*)highway
                                                  distance:(NSUInteger)distance
                                                          ;


@end

NS_ASSUME_NONNULL_END
