//
//  MPInfoSnippetView.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 10/1/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#define kTapPositionLEFT @"LEFT"
#define kTapPositionRIGHT @"RIGHT"
#define kTapPositionCENTER @"CENTER"

#import <UIKit/UIKit.h>
#import "MPLocation.h"

/**
 Info snippet view delegate
 */
DEPRECATED_ATTRIBUTE
@protocol MPInfoSnippetViewDelegate <NSObject>
/**
 Info snippet view delegate method, fires when the info snippet view is tapped
 */
@required
- (void) onInfoSnippetTapped:(MPLocation*)location tapPosition:(NSString*)position;
@end

/**
 Create an location info view, designed to contain information from a tapped location on the map.
 */
@interface MPInfoSnippetView : UIView

/**
 Info snippet view delegate
 */
@property (weak) id <MPInfoSnippetViewDelegate> delegate;
/**
 Set the height of the info snippet
 */
@property int snippetHeight;
/**
 Set the location which information will show in the view
 */
@property MPLocation* location;
/**
 Parent view property
 */
@property UIView* parentView;
/**
 View containing the child views
 */
@property UIView* containerView;
/**
 Center view. To customize, just remove or add views inside this view.
 */
@property UIView* centerView;
/**
 Left view. To customize, just remove or add views inside this view.
 */
@property UIView* leftView;
/**
 Right view. To customize, just remove or add views inside this view.
 */
@property UIView* rightView;
/**
 Label view positioned top center (inside centerView)
 */
@property UILabel* centerTopTextView;
/**
 Label view positioned top left (inside leftView)
 */
@property UILabel* leftTopTextView;
/**
 Label view positioned top right (inside rightView)
 */
@property UILabel* rightTopTextView;
/**
 Label view positioned bottom center (inside centerView)
 */
@property UILabel* centerBottomTextView;
/**
 Label view positioned bottom left (inside leftView)
 */
@property UILabel* leftBottomTextView;
/**
 Label view positioned bottom right (inside rightView)
 */
@property UILabel* rightBottomTextView;

/**
 Add the info snippet to another view
 */
- (void) addToView: (UIView*) view;
/**
 Attach a new location object to the info snippet
 */
- (void)attachLocation: (MPLocation*) location;
/**
 Attach a new location object to the info snippet and provide an initial user position (for displaying distances).
 */
- (void)attachLocation:(MPLocation *)location currentPosition:(MPLocation*)position;
/**
 Enable the left view, disabled by default
 */
- (void)enableLeftView;
/**
 Hide the info snippet
 */
- (void)hide;
/**
 Show the info snippet, by animating from bottom and up
 */
- (void)show;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

+ (UIColor*) rightButtonColor;
+ (void) setRightButtonColor:(UIColor*)color;

@end
