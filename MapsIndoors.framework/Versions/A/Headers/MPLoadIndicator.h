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
 * A basic load indicator, with the option to set a text.
 */
@interface MPLoadIndicator : NSObject
/**
 * The indicator view.
 */
@property UIActivityIndicatorView *indicatorView;
/**
 * View holding the load indicator.
 */
@property UIView* parentView;
/**
 * The text view
 */
@property UITextView* textView;
/**
 * Instantiates the indicator and places the indicator in a view.
 * @param view The view to hold the indicator.
 */
- (id)initOnView:(UIView*) view;
/**
 * Instantiates the indicator and places the indicator in a view with a given text.
 * @param view The view to hold the indicator.
 * @param text The text to display with the indicator.
 */
- (id)initOnView:(UIView*) view withText:(NSString*) text;
/**
 * Start and show the indicator animation
 */
- (void) start;
/**
 * Stop and hide the indicator animation
 */
- (void) stop;

@end
