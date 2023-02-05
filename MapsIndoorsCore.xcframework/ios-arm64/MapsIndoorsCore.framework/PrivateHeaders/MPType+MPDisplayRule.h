//
//  MPType+MPDisplayRule.h
//  MapsIndoors
//
//  Created by Christian Wolf Johannsen on 15/11/2022.
//  Copyright © 2022 MapsPeople A/S. All rights reserved.
//

#import "MPType.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPType (MPDisplayRule)

- (void)setDisplayRuleWithJSONObject:(NSDictionary*)json;

@end

NS_ASSUME_NONNULL_END
