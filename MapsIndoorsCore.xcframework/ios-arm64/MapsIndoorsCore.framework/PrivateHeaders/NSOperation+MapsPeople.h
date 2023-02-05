//
//  NSOperation+MapsPeople.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 09/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSOperation (MapsPeople)

- (void) mp_addCompletionBlock:(void (^)(void))completionBlock;
- (void) mp_addMainQueueCompletionBlock:(void (^)(void))newCompletionBlock;
- (void) mp_addDependencies:(NSArray<NSOperation*>*)dependencies;

@end

NS_ASSUME_NONNULL_END
