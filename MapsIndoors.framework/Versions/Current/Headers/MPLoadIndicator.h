//
//  MPLoadIndicator.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/13/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 A basic load indicator, with the option to set a text.
 */
@interface MPLoadIndicator : NSObject

/**
 The indicator view.
 */
@property (nonatomic, strong, nullable) UIActivityIndicatorView *indicatorView;

/**
 View holding the load indicator.
 */
@property (nonatomic, strong, nullable) UIView* parentView;

/**
 The text view
 */
@property (nonatomic, strong, nullable) UITextView* textView;

/**
 Instantiates the indicator and places the indicator in a view.
 @param  view The view to hold the indicator.
 */
- (nullable instancetype) initOnView:(nonnull UIView*) view;

/**
 Instantiates the indicator and places the indicator in a view with a given text.
 @param  view The view to hold the indicator.
 @param  text The text to display with the indicator.
 */
- (nullable instancetype)initOnView:(nonnull UIView*) view withText:(nonnull NSString*) text;

/**
 Start and show the indicator animation
 */
- (void) start;

/**
 Stop and hide the indicator animation
 */
- (void) stop;

@end
