//
//  NSIndexSet+FromImmutableNodesString.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 09/01/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSIndexSet (FromImmutableNodesString)

+ (instancetype _Nullable) mp_newWithImmutableNodesString:(nullable NSString*)immutableNodes;

@end

NS_ASSUME_NONNULL_END
