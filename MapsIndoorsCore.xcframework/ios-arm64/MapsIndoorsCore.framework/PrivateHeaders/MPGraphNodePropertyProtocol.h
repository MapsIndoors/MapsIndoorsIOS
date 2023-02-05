//
//  MPGraphNodePropertyProtocol.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 12/12/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@protocol MPGraphNodePropertyProtocol <NSObject>

@property (nonatomic, readonly)                   NSUInteger                boundary;
@property (nonatomic, readonly, strong, nullable) NSString*                 barrier;
@property (nonatomic, readonly, strong, nullable) NSString*                 floorname;
@property (nonatomic, readonly)                   NSTimeInterval            waittime;

- (BOOL) haveSameGraphNodeProperties:(id<MPGraphNodePropertyProtocol>)otherObject;

@end

NS_ASSUME_NONNULL_END
