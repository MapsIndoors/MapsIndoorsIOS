// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from SharedInterface.djinni

#import <Foundation/Foundation.h>

/**
 * name: MapsIndoors Models;
 * A simple point model.;
 */
@interface MIPoint : NSObject
- (nonnull instancetype)initWithX:(double)x
                                y:(double)y;
+ (nonnull instancetype)PointWithX:(double)x
                                 y:(double)y;

@property (nonatomic, readonly) double x;

@property (nonatomic, readonly) double y;

@end