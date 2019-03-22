//
//  TCFKA_MDSnackbar.m
//  The Class Formerly Known as MDSnackbar
//
//  Add support for dynamic text size.
//
//  Created by Michael Bech Hansen on 23/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//


// The MIT License (MIT)
//
// Copyright (c) 2015 FPT Software
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TCFKA_MDSnackbar.h"
#import "UIColorHelper.h"
#import "UIFontHelper.h"
#import "MDConstants.h"
#import "MDDeviceHelper.h"
#import "AppFonts.h"

#define kMDAnimationDuration .25f
#define kMDNormalPadding 14
#define kMDLargePadding 24
#define kMDCornerRadius 2
#define kMDMinWidth 288
#define kMDDefaultMaxWidth 568

@interface TCFKA_MDSnackbarManger : NSObject

+ (TCFKA_MDSnackbarManger *)instance;

- (void)show:(TCFKA_MDSnackbar *)snackbar;

@end

TCFKA_MDSnackbarManger *snackbarManagerInstance;

@implementation TCFKA_MDSnackbar {
  NSLayoutConstraint *hiddenConstraint;
  NSLayoutConstraint *showingConstraint;
  UIView *rootView;
  UILabel *textLabel;
  BOOL isAnimating;
  NSMutableSet *delegates;
  UIButton *actionButton;
}

@synthesize bottomPadding = _bottomPadding;

- (instancetype)init {
  if (self = [super init]) {
    [self createContent];
    self.maxWidth = kMDDefaultMaxWidth;
  }
  return self;
}

- (instancetype)initWithText:(NSString *)text actionTitle:(NSString *)action {
  if (self = [super init]) {
    [self createContent];
    self.text = text;
    self.actionTitle = action;
    self.maxWidth = kMDDefaultMaxWidth;
  }
  return self;
}

- (instancetype)initWithText:(NSString *)text
                 actionTitle:(NSString *)action
                    duration:(double)duration {
  if (self = [super init]) {
    [self createContent];
    self.text = text;
    self.actionTitle = action;
    self.duration = duration;
    self.maxWidth = kMDDefaultMaxWidth;
  }
  return self;
}

- (void)createContent {
  delegates = [[NSMutableSet alloc] init];
  _duration = kMDSnackbarDurationShort;
  self.backgroundColor = [UIColorHelper colorWithRGBA:@"#323232"];

  textLabel = [[UILabel alloc] init];
  textLabel.font = [[AppFonts sharedInstance] scaledFontForSize:14];
  textLabel.alpha = 0;

  actionButton = [[UIButton alloc] init];
  actionButton.titleLabel.font = [[AppFonts sharedInstance] scaledBoldFontForSize:14] ;
  actionButton.alpha = 0;
  actionButton.enabled = false;

  self.actionTitleColor = self.textColor = [UIColor whiteColor];

  self.translatesAutoresizingMaskIntoConstraints = false;
  textLabel.translatesAutoresizingMaskIntoConstraints = false;
  actionButton.translatesAutoresizingMaskIntoConstraints = false;
  [actionButton addTarget:self
                   action:@selector(buttonTouchUpInside:)
         forControlEvents:UIControlEventTouchUpInside];
  [actionButton setContentHuggingPriority:UILayoutPriorityRequired
                                  forAxis:UILayoutConstraintAxisHorizontal];
  [textLabel
      setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                      forAxis:UILayoutConstraintAxisHorizontal];

  if (IS_IPAD) {
    self.layer.cornerRadius = kMDCornerRadius;
  }

  UISwipeGestureRecognizer *swipeGesture =
      [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(slideDown:)];
  swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    
   _bottomPadding = 0.0;
  [self addGestureRecognizer:swipeGesture];
}

- (void)arrangeContent {
  [self addSubview:textLabel];

  if (_actionTitle) {
    [self addSubview:actionButton];
  }

  NSDictionary *viewsDictionary = @{
    @"label" : textLabel,
    @"button" : actionButton
  };
  NSDictionary *metrics = @{
    @"normalPadding" : @kMDNormalPadding,
    @"largePadding" : @kMDLargePadding
  };
  NSArray *labelConstraints;
  if (_multiline) {
    labelConstraints = [NSLayoutConstraint
        constraintsWithVisualFormat:@"V:|-largePadding-[label]-largePadding-|"
                            options:0
                            metrics:metrics
                              views:viewsDictionary];
  } else {
    labelConstraints = [NSLayoutConstraint
        constraintsWithVisualFormat:@"V:|-normalPadding-[label]-normalPadding-|"
                            options:0
                            metrics:metrics
                              views:viewsDictionary];
  }
  [self addConstraints:labelConstraints];

  if (_actionTitle) {
    NSLayoutConstraint *c =
        [NSLayoutConstraint constraintWithItem:actionButton
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1
                                      constant:0];
    [self addConstraint:c];

    NSArray *hConstraints = [NSLayoutConstraint
        constraintsWithVisualFormat:
            @"H:|-largePadding-[label]-largePadding-[button]-largePadding-|"
                            options:0
                            metrics:metrics
                              views:viewsDictionary];
    [self addConstraints:hConstraints];
  } else {
    NSArray *hConstraints = [NSLayoutConstraint
        constraintsWithVisualFormat:@"H:|-largePadding-[label]-largePadding-|"
                            options:0
                            metrics:metrics
                              views:viewsDictionary];
    [self addConstraints:hConstraints];
  }

  if (IS_IPAD) {
    // set min, max width
    NSLayoutConstraint *minWidthConstraint = [NSLayoutConstraint
        constraintWithItem:self
                 attribute:NSLayoutAttributeWidth
                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                    toItem:nil
                 attribute:NSLayoutAttributeNotAnAttribute
                multiplier:1.0
                  constant:kMDMinWidth];
    [self addConstraint:minWidthConstraint];
    NSLayoutConstraint *maxWidthConstraint =
        [NSLayoutConstraint constraintWithItem:self
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:self.maxWidth];
    [self addConstraint:maxWidthConstraint];
  }
}

- (void)addSelfToScreen {
  rootView = [MDDeviceHelper getMainView];

  [rootView addSubview:self];
  NSDictionary *dict = @{ @"view" : self };

  if (IS_IPAD) {
    NSLayoutConstraint *centerConstraint =
        [NSLayoutConstraint constraintWithItem:self
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:rootView
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                      constant:0.0];
    [rootView addConstraint:centerConstraint];
  } else {
    NSArray *hConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                options:0
                                                metrics:nil
                                                  views:dict];
    [rootView addConstraints:hConstraints];
  }
  hiddenConstraint =
      [NSLayoutConstraint constraintWithItem:self
                                   attribute:NSLayoutAttributeTop
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:rootView
                                   attribute:NSLayoutAttributeBottom
                                  multiplier:1.0
                                    constant:0.0];

  showingConstraint =
      [NSLayoutConstraint constraintWithItem:self
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:rootView
                                   attribute:NSLayoutAttributeBottom
                                  multiplier:1.0
                                    constant:-_bottomPadding];

  [rootView addConstraint:hiddenConstraint];
}

- (void)buttonTouchUpInside:(id)sender {
  [self performDelegateAction:@selector(actionTouched:)];
  actionButton.enabled = false;
  [self dismiss];
}

- (void)slideDown:(UISwipeGestureRecognizer *)gestureRecognizer {
  [self dismiss];
}

- (void)performDelegateAction:(SEL)aSelector {
  for (id<TCFKA_MDSnackbarDelegate> del in delegates) {
    if ([del respondsToSelector:aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [del performSelector:aSelector withObject:self];
#pragma clang diagnostic pop
    }
  }
}

- (void)doShow {
  if (_isShowing || isAnimating)
    return;
  _isShowing = true;
  isAnimating = true;
  [self arrangeContent];
  [self addSelfToScreen];

  [rootView layoutIfNeeded];
  [self performDelegateAction:@selector(snackbarWillAppear:)];

  [UIView animateWithDuration:kMDAnimationDuration
      delay:0.f
      options:UIViewAnimationOptionCurveEaseInOut
      animations:^{
        textLabel.alpha = 1;
        actionButton.alpha = 1;
        [rootView removeConstraint:hiddenConstraint];
        [rootView addConstraint:showingConstraint];
        [rootView layoutIfNeeded];
      }
      completion:^(BOOL finished) {
        if (finished) {
          isAnimating = false;
          [self performDelegateAction:@selector(snackbarDidAppear:)];

            if(_duration > 0)
          [self performSelector:@selector(dismiss)
                     withObject:nil
                     afterDelay:_duration];

          actionButton.enabled = true;
        }
      }];
}

#pragma mark setter
- (void)setText:(NSString *)text {
  _text = text;
  textLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
  _textColor = textColor;
  textLabel.textColor = textColor;
}

- (void)setActionTitle:(NSString *)actionTitle {
  _actionTitle = actionTitle;
  [actionButton setTitle:actionTitle.uppercaseString
                forState:UIControlStateNormal];
}

- (void)setActionTitleColor:(UIColor *)actionTitleColor {
  _actionTitleColor = actionTitleColor;
  [actionButton setTitleColor:actionTitleColor forState:UIControlStateNormal];
  UIColor *highlightedColor = [actionTitleColor colorWithAlphaComponent:.7f];
  [actionButton setTitleColor:highlightedColor
                     forState:UIControlStateHighlighted];
}

- (void)setMultiline:(BOOL)multiline {
  _multiline = multiline;
  if (multiline) {
    textLabel.numberOfLines = 0;
  } else {
    textLabel.numberOfLines = 1;
  }
}

#pragma mark public methods
- (void)addTarget:(id)target action:(SEL)aSelector {
  [actionButton addTarget:target
                   action:aSelector
         forControlEvents:UIControlEventTouchUpInside];
}
- (void)addDelegate:(id<TCFKA_MDSnackbarDelegate>)delegate {
  [delegates addObject:delegate];
}

- (void)removeDelegate:(id<TCFKA_MDSnackbarDelegate>)delegate {
  [delegates removeObject:delegate];
}

- (void)show {
  [[TCFKA_MDSnackbarManger instance] show:self];
}

- (void)dismiss {
  if (!_isShowing) // || isAnimating //#90
    return;
  isAnimating = true;
  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(dismiss)
                                             object:nil];
  [rootView layoutIfNeeded];
  [self performDelegateAction:@selector(snackbarWillDisappear:)];

  [UIView animateWithDuration:kMDAnimationDuration
      delay:0.f
      options:UIViewAnimationOptionCurveEaseInOut
      animations:^{
        textLabel.alpha = 0;
        actionButton.alpha = 0;

        [rootView removeConstraint:showingConstraint];
        [rootView addConstraint:hiddenConstraint];
        [rootView layoutIfNeeded];
      }
      completion:^(BOOL finished) {
        if (finished) {
          isAnimating = false;
          [self performDelegateAction:@selector(snackbarDidDisappear:)];
          [self removeFromSuperview];
          [textLabel removeFromSuperview];
          [actionButton removeFromSuperview];
          _isShowing = false;
        }
      }];
}

@end

@interface TCFKA_MDSnackbarManger () <TCFKA_MDSnackbarDelegate>

@end

@implementation TCFKA_MDSnackbarManger {
  NSMutableArray *snackbarQueue;
}

- (instancetype)init {
  if (self = [super init]) {
    snackbarQueue = [NSMutableArray array];
  }

  return self;
}

+ (TCFKA_MDSnackbarManger *)instance {
  if (!snackbarManagerInstance) {
    snackbarManagerInstance = [[TCFKA_MDSnackbarManger alloc] init];
  }

  return snackbarManagerInstance;
}

- (void)show:(TCFKA_MDSnackbar *)snackbar {
  if (![snackbarQueue containsObject:snackbar]) {
    [snackbar addDelegate:self];
    [snackbarQueue addObject:snackbar];

    if (snackbarQueue.count == 1) {
      [snackbar doShow];
    } else {
      [[snackbarQueue objectAtIndex:0] dismiss];
    }
  }
}

#pragma mark TCFKA_MDSnackbarDelegate
- (void)snackbarDidAppear:(TCFKA_MDSnackbar *)snackbar {

  if ([snackbarQueue containsObject:snackbar] && snackbarQueue.count == 1) {
    // snackbar is the last object in queue, do nothing
  } else {
    [snackbar dismiss];
  }
}

- (void)snackbarDidDisappear:(TCFKA_MDSnackbar *)snackbar {
  [snackbarQueue removeObject:snackbar];
  if ((snackbarQueue.count > 0)) {
    [[snackbarQueue objectAtIndex:0] doShow];
  }
}

@end
