//
//  MPRouteEdge.h
//  AFNetworking
//
//  Created by Daniel Nielsen on 05/12/2019.
//

#import <Foundation/Foundation.h>
#import "NSString+MPPropertyClassification.h"
#import "MPDefines.h"

@class MIEdge;


NS_ASSUME_NONNULL_BEGIN

@protocol MPRouteEdgeProtocol <NSObject>

/**
 Node index of node at one end of the edge
 */
@property (nonatomic, readonly) NSUInteger        u;

/**
 Node index of node at one end of the edge
 */
@property (nonatomic, readonly) NSUInteger        v;

/**
Highway type
*/
@property (nonatomic, readonly)                   MPHighwayType     highway;
/**
Context value
*/
@property (nonatomic, readonly, strong, nullable) NSString*         context;
/**
Distance of the edge in millimeters
*/
@property (nonatomic, readonly)                   NSUInteger        distance;       // mm
/**
Waittime somewhere on this edge
*/
@property (nonatomic, readonly)                   NSTimeInterval    waittime;

@end

@interface MPRouteEdge : NSObject<MPRouteEdgeProtocol>

/**
 Initalize an instance of MPGraphEdge with an edge from MICommon
 @return instance of MPGraphEdge
 */
- (nullable instancetype) initGraphEdgeWithMIEdge:(MIEdge*)miEdge
                    NS_DESIGNATED_INITIALIZER;

/**
 Create and initialize an MPGraphEdge with an edge from MICommon
 @return instance of MPGraphEdge
 */
+ (nullable instancetype) newGraphEdgeWithMIEdge:(MIEdge*)miEdge;

@end

NS_ASSUME_NONNULL_END
