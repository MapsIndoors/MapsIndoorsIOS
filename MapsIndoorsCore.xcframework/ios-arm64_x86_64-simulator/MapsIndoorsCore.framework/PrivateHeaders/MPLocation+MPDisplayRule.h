//
//  MPLocation+MPDisplayRule.h
//  
//
//  Created by Christian Wolf Johannsen on 17/11/2022.
//

#import "MPLocation.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLocation (MPDisplayRule)

- (void)setDisplayRuleWithJSONObject:(NSDictionary*)json;

@end

NS_ASSUME_NONNULL_END
