//
//  MPMapsIndoorsDelegate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 15/10/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///MapsIndoors delegate protocol
@protocol MPMapsIndoorsDelegate <NSObject>


/// Called when error occurs while initialising or synchronising.
/// @param error The error object.
- (void) onError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
