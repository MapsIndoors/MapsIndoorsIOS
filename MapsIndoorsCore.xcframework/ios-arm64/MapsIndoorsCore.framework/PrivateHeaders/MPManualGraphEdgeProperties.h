//
//  MPManualGraphEdgeProperties.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 12/12/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPGraphEdgePropertyProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPManualGraphEdgeProperties : NSObject <MPGraphEdgePropertyProtocol>

+ (instancetype) newGraphEdgePropertiesWithContext:(NSString*)context
                                           highway:(NSString*)highway
                                          distance:(NSUInteger)distance
                                       speedFactor:(double)speedFactor
                                          waittime:(NSTimeInterval)waittime
                                          directed:(BOOL)directed
                                                  ;

+ (instancetype) newDirectedGraphEdgePropertiesWithContext:(NSString*)context
                                                   highway:(NSString*)highway
                                                  distance:(NSUInteger)distance
                                                          ;


@end

NS_ASSUME_NONNULL_END
