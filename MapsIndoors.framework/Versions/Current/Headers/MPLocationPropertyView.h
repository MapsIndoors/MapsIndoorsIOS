//
//  MPLocationDetailItemView.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 10/1/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDefines.h"


@class MPLocation;
@class MPLocationProperty;


/**
 Delegate protocol specification
 */
MP_DEPRECATED_ATTRIBUTE
@protocol MPLocationPropertyViewDelegate <NSObject>
/**
 Delegate method that is to fire when a locations property is tapped in MPLocationPropertyView
 */
@required
- (void) onLocationPropertyTapped:(MPLocationProperty *)locationProperty;
@end

/**
 Creates a view designed to contain an icon and some content (default is text) side by side.
 */
@interface MPLocationPropertyView : UIView

/**
 Delegate object
 */
@property (weak) id <MPLocationPropertyViewDelegate> delegate;
/**
 Parent view reference.
 */
@property UIView* parentView;
/**
 Container view, holding the icon and content view.
 */
@property UIView* containerView;
/**
 The icon view, which normally will be placed to the left.
 */
@property UIView* iconView;
/**
 The content view, which normally will be placed to the right.
 */
@property UIView* contentView;
/**
 The location property, that should be displayed in the view
 */
@property MPLocationProperty* locationProperty;

/**
 Initialization with location property, icon and whether to interpret the icon value as a reference or a font icon value.
 */
- (id)initWithProperty:(MPLocationProperty *)property andIcon: (NSString*)icon useFontIcon: (BOOL)useFont;
/**
 Add the view to it's parent, setting the width to its parents width.
 */
- (void)addToView: (UIView*) view;
/**
 Attach a new location property to this view
 */
- (void)attachProperty:(MPLocationProperty *)property andIcon: (NSString*)icon;
/**
 *
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
/**
 *
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
/**
 *
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
/**
 *
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end
