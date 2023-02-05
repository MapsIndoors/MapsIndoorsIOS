//
//  MPMapsIndoorsLocationSource+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 21/10/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLocationSource.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPMapsIndoorsLocationSource (Private)

/**
 Get or set the user roles that should apply generally for locations. The roles are applied in an OR fashion. This means that if for example a locations internal restrictions matches one or more of the given roles, the location will be included in response object.
 */
@property (nonatomic, strong, nullable) NSArray<MPUserRole*>*       userRoles;

/**
Synchronize content using only embedded or cached content - this will bring objects into memory and notify the different observers.
*/
- (void) synchronizeContent:(BOOL)forceLocalContent completion:(void(^_Nullable)(NSError*))nullableSyncCompletion;

@end

NS_ASSUME_NONNULL_END
