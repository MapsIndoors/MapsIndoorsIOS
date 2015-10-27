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

#import "MDToast.h"
#import "UIColorHelper.h"
#import "UIFontHelper.h"
#import "MDDeviceHelper.h"

#define kMDAnimationDuration .2f
#define kMDNormalPadding 14
#define kMDLargePadding 24
#define kMDCornerRadius 24
#define kMDMaxWidth 568

@protocol MDToastDelegate <NSObject>

@optional
- (void)toastDidAppear:(MDToast *)toast;
- (void)toastDidDisappear:(MDToast *)toast;
@end

@interface MDToastManager : NSObject <MDToastDelegate>

+ (MDToastManager *)instance;

- (void)show:(MDToast *)toast;

@end

MDToastManager *managerInstance;

@implementation MDToast {
  UIView *rootView;
  UILabel *textLabel;
  BOOL isAnimating;
  NSMutableSet *delegates;
}

- (instancetype)init {
  if (self = [super init]) {
    [self createContent];
  }
  return self;
}

- (instancetype)initWithText:(NSString *)text duration:(double)duration {
  if (self = [super init]) {
    [self createContent];
    self.text = text;
    self.duration = duration;
  }
  return self;
}

- (void)createContent {
  delegates = [[NSMutableSet alloc] init];
  _duration = kMDToastDurationShort;

  textLabel = [[UILabel alloc] init];
  //  textLabel.font = [UIFontHelper robotoFontOfSize:14];
  textLabel.numberOfLines = 0;

  self.backgroundColor = [UIColorHelper colorWithRGBA:@"#323232EE"];
  self.alpha = 0;

  self.textColor = [UIColor whiteColor];

  self.translatesAutoresizingMaskIntoConstraints = false;
  textLabel.translatesAutoresizingMaskIntoConstraints = false;
  [textLabel
      setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                      forAxis:UILayoutConstraintAxisHorizontal];

  self.layer.cornerRadius = kMDCornerRadius;
}

- (void)arrangeContent {
  [self addSubview:textLabel];

  NSDictionary *viewsDictionary = @{ @"label" : textLabel };
  NSDictionary *metrics = @{
    @"normalPadding" : @kMDNormalPadding,
    @"largePadding" : @kMDLargePadding
  };
  NSArray *labelConstraints;
  labelConstraints = [NSLayoutConstraint
      constraintsWithVisualFormat:@"V:|-normalPadding-[label]-normalPadding-|"
                          options:0
                          metrics:metrics
                            views:viewsDictionary];
  [self addConstraints:labelConstraints];

  NSArray *hConstraints = [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-largePadding-[label]-largePadding-|"
                          options:0
                          metrics:metrics
                            views:viewsDictionary];
  [self addConstraints:hConstraints];

  if (IS_IPAD) {
    // set max width
    NSLayoutConstraint *maxWidthConstraint =
        [NSLayoutConstraint constraintWithItem:self
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1.0
                                      constant:kMDMaxWidth];
    [self addConstraint:maxWidthConstraint];
  }
}

- (void)addSelfToScreen {
  rootView = [MDDeviceHelper getMainView];

  [rootView addSubview:self];
  NSDictionary *dict = @{ @"view" : self };
  NSDictionary *metrics = @{
    @"normalPadding" : @kMDNormalPadding,
    @"largePadding" : @kMDLargePadding
  };

  NSLayoutConstraint *centerConstraint =
      [NSLayoutConstraint constraintWithItem:self
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:rootView
                                   attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0
                                    constant:0.0];
  [rootView addConstraint:centerConstraint];

  NSArray *hConstraints =
      [NSLayoutConstraint constraintsWithVisualFormat:
                              @"H:|-(>=largePadding)-[view]-(>=largePadding)-|"
                                              options:0
                                              metrics:metrics
                                                views:dict];
  [rootView addConstraints:hConstraints];

  NSLayoutConstraint *bottomConstraint =
      [NSLayoutConstraint constraintWithItem:self
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:rootView
                                   attribute:NSLayoutAttributeBottom
                                  multiplier:1.0
                                    constant:-kMDLargePadding];

  [rootView addConstraint:bottomConstraint];
}

- (void)doShow {
  if (_isShowing)
    return;
  _isShowing = true;
  [self arrangeContent];
  [self addSelfToScreen];

  [rootView layoutIfNeeded];

  [UIView animateWithDuration:kMDAnimationDuration
      delay:0.f
      options:UIViewAnimationOptionCurveEaseInOut
      animations:^{
        self.alpha = 1;
      }
      completion:^(BOOL finished) {
        if (finished) {
          isAnimating = false;
          [self performDelegateAction:@selector(toastDidAppear:)];
          [self performSelector:@selector(dismiss)
                     withObject:nil
                     afterDelay:_duration];
        }
      }];
}

- (void)performDelegateAction:(SEL)aSelector {
  for (id<MDToastDelegate> del in delegates) {
    if ([del respondsToSelector:aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [del performSelector:aSelector withObject:self];
#pragma clang diagnostic pop
    }
  }
}

- (void)resetTimer {
  if (_isShowing) {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(dismiss)
                                               object:nil];
    [self performSelector:@selector(dismiss)
               withObject:nil
               afterDelay:_duration];
  }
}

#pragma mark public methods
- (void)show {
  [[MDToastManager instance] show:self];
}

- (void)dismiss {
  if (!_isShowing || isAnimating)
    return;
  isAnimating = true;
  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(dismiss)
                                             object:nil];
  [rootView layoutIfNeeded];

  [UIView animateWithDuration:kMDAnimationDuration * 2
      delay:0.f
      options:UIViewAnimationOptionCurveEaseInOut
      animations:^{
        self.alpha = 0;
      }
      completion:^(BOOL finished) {
        if (finished) {
          isAnimating = false;
          [self removeFromSuperview];
          [textLabel removeFromSuperview];
          _isShowing = false;
          [self performDelegateAction:@selector(toastDidDisappear:)];
        }
      }];
}

- (void)addDelegate:(id<MDToastDelegate>)delegate {
  [delegates addObject:delegate];
}

- (void)removeDelegate:(id<MDToastDelegate>)delegate {
  [delegates removeObject:delegate];
}

#pragma mark setter
- (void)setText:(NSString *)text {
  _text = text;
  textLabel.text = text;
  [self resetTimer];
}

- (void)setTextColor:(UIColor *)textColor {
  _textColor = textColor;
  textLabel.textColor = textColor;
}

@end

@implementation MDToastManager {
  NSMutableArray *toastQueue;
  NSLock *arrayLock;
}

- (instancetype)init {
  if (self = [super init]) {
    toastQueue = [NSMutableArray array];
    arrayLock = [[NSLock alloc] init];
  }

  return self;
}

+ (MDToastManager *)instance {
  if (!managerInstance) {
    managerInstance = [[MDToastManager alloc] init];
  }

  return managerInstance;
}

- (void)show:(MDToast *)toast {
  if (![toastQueue containsObject:toast]) {
    [toast addDelegate:self];
    [toastQueue addObject:toast];
    [toast doShow];
    for (int i = 0; i < toastQueue.count - 1; i++) {
      [[toastQueue objectAtIndex:i] dismiss];
    }
  }
}

#pragma mark MDToastDelegate
//- (void)toastDidAppear:(MDToast *)toast {
//  if (toast != [toastQueue lastObject]) {
//    [toast dismiss];
//  }
//}

- (void)toastDidDisappear:(MDToast *)toast {
  [toastQueue removeObject:toast];
  //  if ((toastQueue.count > 0)) {
  //    [[toastQueue objectAtIndex:0] doShow];
  //  }
}

@end
