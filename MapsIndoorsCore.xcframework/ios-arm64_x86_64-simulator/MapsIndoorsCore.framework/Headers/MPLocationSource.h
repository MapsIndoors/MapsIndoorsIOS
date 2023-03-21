//
//  MPLocationSource.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

@protocol MPLocationsObserver;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]

@interface MPMapsIndoorsLocationSource : NSObject<MPLocationSource>

+ (BOOL) isOfflineDataAvailableForSolutionId:(NSString*)solutionId language:(NSString*)language;
+ (int) mpMapsIndoorsSourceId;

- (void) synchronizeContentWithCompletion:(void(^_Nullable)(NSError*))completion;

@end

NS_ASSUME_NONNULL_END
