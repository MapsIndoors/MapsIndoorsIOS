//
//  MPDataSetScope.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 31/01/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#ifndef MPDataSetEnums_h
#define MPDataSetEnums_h

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]

#define MPDataSetCachingScopeString(enum) @[ \
    @"basic", \
    @"detailed", \
    @"full" \
][enum]\

#define MPDataSetCachingStrategyString(enum) @[ \
    @"dontCache", \
    @"automatic", \
    @"manual" \
][enum]\

#endif /* MPDataSetScope_h */
