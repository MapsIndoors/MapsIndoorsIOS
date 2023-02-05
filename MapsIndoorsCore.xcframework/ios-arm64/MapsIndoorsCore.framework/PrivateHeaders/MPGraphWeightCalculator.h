//
//  MPGraphWeightCalculator.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 28/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MPPropertyClassification.h"
typedef NSString* MPHighwayType;


NS_ASSUME_NONNULL_BEGIN


@class MPGraphNode;
@class MPGraphEdge;


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPGraphWeightCalculator : NSObject

@property (nonatomic) BOOL                          avoiding;
@property (nonatomic, strong) NSSet<NSString*>*     accessTokens;

- (NSInteger) getWeightFromNode:(MPGraphNode*)from viaEdge:(MPGraphEdge*)edge toNode:(MPGraphNode*)to byAvoiding:(NSArray<MPHighwayType>*)avoid;

@end


NS_ASSUME_NONNULL_END
