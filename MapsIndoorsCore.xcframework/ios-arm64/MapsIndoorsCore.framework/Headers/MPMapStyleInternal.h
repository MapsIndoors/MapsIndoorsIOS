//
//  MPMapStyle.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Map style used by MapsPeoples services. The map style refers to a graphical layout of the building floor plans.
 */
@interface MPMapStyleInternal : JSONModel <MPMapStyle>

/**
 Folder identifier of the map style
 */
@property (nonatomic, copy) NSString* folder;
/**
 Display name of the map style
 */
@property (nonatomic, copy, nullable) NSString* displayName;

@end

NS_ASSUME_NONNULL_END
