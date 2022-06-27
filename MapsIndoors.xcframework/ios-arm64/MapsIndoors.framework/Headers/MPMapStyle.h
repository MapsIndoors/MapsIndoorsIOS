//
//  MPMapStyle.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

@import JSONModel;

/**
 Map style used by MapsPeoples services. The map style refers to a graphical layout of the building floor plans.
 */
@interface MPMapStyle : JSONModel


/**
 Initialise a map style with a string, corresponding to the folder identifier.

 @param string The map style identifier (folder)
 @return The map style instance
 */
- (instancetype _Nullable )initWithString: (NSString*_Nullable)string;
/**
 Folder identifier of the map style
 */
@property (nonatomic, strong, nonnull, readonly) NSString* folder;
/**
 Display name of the map style
 */
@property (nonatomic, strong, nullable, readonly) NSString* displayName;

@end
