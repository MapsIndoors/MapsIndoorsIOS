//
//  MPLocationServiceDelegate.h
//  MapsIndoors
//
//  Created by Christian Wolf Johannsen on 26/07/2022.
//  Copyright © 2022 MapsPeople A/S. All rights reserved.
//

#ifndef MPLocationServiceDelegate_h
#define MPLocationServiceDelegate_h

#import <Foundation/Foundation.h>

/**
 This delegate informs about the status of loading the Locations of the current
 Solution.
 */
@protocol MPLocationServiceDelegate <NSObject>

/**
 This method on the delegate is invoked when the Locations in the current
 Solution are all loaded and ready to be worked with, e.g. search in them.
 */
- (void)locationsReady;

@end

#endif /* MPLocationServiceDelegate_h */
