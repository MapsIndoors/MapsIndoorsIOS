//
//  MPFloorButton.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/16/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDefines.h"


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Create a button with a floor index property
 */
DEPRECATED_ATTRIBUTE
@interface MPFloorButton : UIButton

/**
 Floor index property, corresponds to the index property of MPFloor
 */
@property NSNumber* floorIndex;

@end
