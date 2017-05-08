//
//  MPLocationDetailsView.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 11/26/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationPropertyView.h"
#import "MPLocation.h"

/**
 * Delegate protocol specification, to keep track of the tapping on a locations details.
 */
@protocol MPLocationViewDelegate <NSObject>
/**
 * Delegate method that is to fire when a location property is tapped on in MPLocationView
 */
@required
- (void) onLocationPropertyTapped:(MPLocation*)location withProperty:(MPLocationProperty*)locationProperty;
@end

/**
 * Creates a specialized scroll view, designed to hold a locations details
 */
@interface MPLocationView : UIScrollView<MPLocationPropertyViewDelegate>

/**
 * Delegate protocol specification, to keep track of the tapping on a locations details.
 */
@property (weak) id <MPLocationViewDelegate> mpdelegate;
/**
 * The array of the locations properties views.
 */
@property NSMutableArray* locationPropertyViews;
/**
 * The location that will be displayed in the view as layouted properties.
 */
@property MPLocation* location;

/**
 * Initialization of the view using a location.
 */
- (id)initWithLocation: (MPLocation*) location;
/**
 * Add a simple text detail. This will add a location property view to this view.
 */
- (void)addDetail: (NSString*)value withType: (NSString*)type andIcon: (NSString*) icon useFontIcon:(BOOL)useFont;

@end
