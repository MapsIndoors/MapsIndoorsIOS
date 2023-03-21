//
//  MPRouteNode.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 09/01/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationCoordinate3D.h"

@class MINode;

NS_ASSUME_NONNULL_BEGIN

/// > Warning: [INTERNAL - DO NOT USE]
@protocol MPRouteNodeProtocol <NSObject>

@property (nonatomic, readonly)                   NSUInteger                nodeId;
@property (nonatomic, readonly)                   MPLocationCoordinate3D    coordinate;
@property (nonatomic, readonly)                   NSTimeInterval            waittime;
@property (nonatomic, readonly)                   NSString*                 label;

@end


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteNode : NSObject< MPRouteNodeProtocol >

- (instancetype)initWithMINode:(MINode*) miNode graphNode:(id<MPRouteNodeProtocol>)graphNode;

@end

NS_ASSUME_NONNULL_END
