//
//  MPLogUploader.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 28/01/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLogRemover : NSObject

+ (void) removeLogFiles:(NSString*) logDirectory apiKey:(NSString*) apiKey;

@end

NS_ASSUME_NONNULL_END
