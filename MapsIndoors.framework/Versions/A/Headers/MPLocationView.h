//
//  MPLocationDetailsView.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 11/26/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationPropertyView.h"
#import "MPLocation.h"

/**
 Delegate protocol specification, to keep track of the tapping on a locations details.
 */
@protocol MPLocationViewDelegate <NSObject>
/**
 Delegate method that is to fire when a location property is tapped on in MPLocationView
 */
@required
- (void) onLocationPropertyTapped:(nullable MPLocation*)location withProperty:(nullable MPLocationProperty*)locationProperty;
@end

/**
 Creates a specialized scroll view, designed to hold a locations details
 */
@interface MPLocationView : UIScrollView

/**
 Delegate protocol specification, to keep track of the tapping on a locations details.
 */
@property (nonatomic, weak, nullable) id <MPLocationViewDelegate> mpdelegate;
/**
 The array of the locations properties views.
 */
@property (nonatomic, strong, nullable) NSMutableArray* locationPropertyViews;

/**
 The location that will be displayed in the view as layouted properties.
 */
@property (nonatomic, strong, nullable) MPLocation* location;

/**
 Initialization of the view using a location.
 */
- (nullable instancetype)initWithLocation: (nullable MPLocation*) location;

/**
 Add a simple text detail. This will add a location property view to this view.
 */
- (void)addDetail: (nullable NSString*)value withType: (nullable NSString*)type andIcon: (nullable NSString*) icon useFontIcon:(BOOL)useFont;

@end
