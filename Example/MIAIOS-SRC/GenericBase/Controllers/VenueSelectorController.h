//
//  VenueSelectorController.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 05/07/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>

typedef void(^mpVenueSelectBlockType)(MPVenue* venue);

@protocol VenueSelectorDelegate

@required

- (void) onVenueSelected: (MPVenue*) venue;

@end

@interface VenueSelectorController : UITableViewController

@property (weak) id venueSelectDelegate;

@property (class, nonatomic, readonly) BOOL     venueSelectorIsShown;

- (void) venueSelectCallback: (mpVenueSelectBlockType)selectCallbackFn;

@end
