//
//  MPQuickAccessPointsProvider.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 18/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class MPLocationDataset;
typedef void(^QuickAccessPointsHandlerBlock)( MPLocationDataset* _Nullable locationData, NSError* _Nullable error );


@interface MPQuickAccessPointsProvider : NSObject

+ (instancetype) sharedInstance;

/**
 Method to initiate fetching quick access points for one or all venues.
 
 @param venueKey venue for which quick access points should be returned.  nil if quick access points for all venues should be found.
 @param handler The handler callback block. Receives a MPLocationDataset with quick access points (can be nil) and an NSError object (can be nil).
 */
- (void) getQuickAccessPointsForVenue:(NSString* _Nullable)venueKey completion:(QuickAccessPointsHandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
