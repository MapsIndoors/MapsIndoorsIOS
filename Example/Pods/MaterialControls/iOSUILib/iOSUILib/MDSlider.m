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

#import "MDSlider.h"
#import "MDSliderIcon.h"
#import "UIColorHelper.h"
#import "MDConstants.h"
#import "MDSliderTickMarksView.h"
#import "UIViewHelper.h"
#import "MDBubbleLabel.h"
#import "MDSliderThumbView.h"

#define kMDTrackPadding 16
#define kMDTrackPaddingWithLabel 24
#define kMDTrackWidth 2

#define kMDTrackBackgroundColor @"#00000042"
#define kMDDisabledColor @"#00000021"

@implementation MDSlider {
  UIView *intensityView;
  UIView *trackView;
  MDSliderTickMarksView *tickMarksView;
  MDSliderThumbView *thumbView;
  CAShapeLayer *trackOverlayLayer;
  MDSliderIcon *leftIcon;
  MDSliderIcon *rightIcon;

  NSDictionary *viewsDictionary;
  NSDictionary *metricsDictionary;

  NSLayoutConstraint *intensityWidthConstraint;
  NSLayoutConstraint *thumbCenterXConstraint;
  NSArray *constraintsArray;

  float rawValue;
}
@dynamic enabled;

- (instancetype)init {
  if (self = [super init]) {
  }

  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self setupContent];
    [self layoutContent];
  }

  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super init]) {
    [self setupContent];
    [self layoutContent];
  }

  return self;
}

- (void)setupContent {
  trackView = [[UIView alloc] init];
  thumbView = [[MDSliderThumbView alloc] initWithMDSlider:self];
  intensityView = [[UIView alloc] init];
  tickMarksView = [[MDSliderTickMarksView alloc] init];
  leftIcon = [[MDSliderIcon alloc] init];
  rightIcon = [[MDSliderIcon alloc] init];

  UIBezierPath *path = [self createTrackLayerPath];
  trackOverlayLayer = [CAShapeLayer layer];
  trackOverlayLayer.path = path.CGPath;
  trackOverlayLayer.fillRule = kCAFillRuleEvenOdd;
  trackView.layer.mask = trackOverlayLayer;

  [self addSubview:trackView];
  [self addSubview:leftIcon];
  [self addSubview:rightIcon];
  [trackView addSubview:intensityView];
  [trackView addSubview:tickMarksView];
  [self addSubview:thumbView];

  [self createInitialContraints];

  self.trackOffColor = [UIColorHelper colorWithRGBA:kMDTrackBackgroundColor];
  self.trackOnColor = [UIColorHelper colorWithRGBA:kMDColorPrimary500];
  self.thumbOnColor = [UIColorHelper colorWithRGBA:kMDColorPrimary500];
  self.thumbOffColor = [UIColorHelper colorWithRGBA:kMDTrackBackgroundColor];
  self.disabledColor = [UIColorHelper colorWithRGBA:kMDDisabledColor];

  // initial values
  self.minimumValue = 0;
  self.maximumValue = 100;
  self.value = 0;
  self.precision = 0;

  [thumbView.bubble setValue:_value];

  [trackView addObserver:self forKeyPath:@"bounds" options:0 context:nil];
}
- (void)createInitialContraints {
  self.translatesAutoresizingMaskIntoConstraints = NO;
  trackView.translatesAutoresizingMaskIntoConstraints = NO;
  intensityView.translatesAutoresizingMaskIntoConstraints = NO;
  tickMarksView.translatesAutoresizingMaskIntoConstraints = NO;
  thumbView.translatesAutoresizingMaskIntoConstraints = NO;
  leftIcon.translatesAutoresizingMaskIntoConstraints = NO;
  rightIcon.translatesAutoresizingMaskIntoConstraints = NO;
  viewsDictionary = NSDictionaryOfVariableBindings(
      trackView, intensityView, tickMarksView, thumbView, leftIcon, rightIcon);

  metricsDictionary = @{
    @"trackPadding" : @kMDTrackPadding,
    @"labeledPadding" : @kMDTrackPaddingWithLabel,
    @"trackWidth" : @kMDTrackWidth
  };
  [UIViewHelper
      addConstraintsWithVisualFormat:
          @"V:|-(>=trackPadding)-[trackView(trackWidth)]-(>=trackPadding)-|"
                             options:0
                             metrics:metricsDictionary
                               views:viewsDictionary
                              toView:self];
  [UIViewHelper addConstraintsWithVisualFormat:@"V:|-(>=0)-[leftIcon]-(>=0)-|"
                                       options:0
                                       metrics:nil
                                         views:viewsDictionary
                                        toView:self];
  [UIViewHelper addConstraintsWithVisualFormat:@"V:|-(>=0)-[rightIcon]-(>=0)-|"
                                       options:0
                                       metrics:nil
                                         views:viewsDictionary
                                        toView:self];

  [UIViewHelper addConstraintWithItem:leftIcon
                            attribute:NSLayoutAttributeCenterY
                            relatedBy:NSLayoutRelationEqual
                               toItem:trackView
                            attribute:NSLayoutAttributeCenterY
                           multiplier:1
                             constant:0
                               toView:self];

  [UIViewHelper addConstraintWithItem:rightIcon
                            attribute:NSLayoutAttributeCenterY
                            relatedBy:NSLayoutRelationEqual
                               toItem:trackView
                            attribute:NSLayoutAttributeCenterY
                           multiplier:1
                             constant:0
                               toView:self];

  //   align intensityView with trackView
  [UIViewHelper addConstraintWithItem:intensityView
                            attribute:NSLayoutAttributeLeading
                            relatedBy:NSLayoutRelationEqual
                               toItem:trackView
                            attribute:NSLayoutAttributeLeading
                           multiplier:1
                             constant:0
                               toView:trackView];

  [UIViewHelper addConstraintWithItem:intensityView
                            attribute:NSLayoutAttributeTop
                            relatedBy:NSLayoutRelationEqual
                               toItem:trackView
                            attribute:NSLayoutAttributeTop
                           multiplier:1
                             constant:0
                               toView:trackView];

  [UIViewHelper addConstraintWithItem:intensityView
                            attribute:NSLayoutAttributeBottom
                            relatedBy:NSLayoutRelationEqual
                               toItem:trackView
                            attribute:NSLayoutAttributeBottom
                           multiplier:1
                             constant:0
                               toView:trackView];
  intensityWidthConstraint =
      [UIViewHelper addConstraintWithItem:intensityView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                attribute:NSLayoutAttributeNotAnAttribute
                               multiplier:0
                                 constant:0
                                   toView:trackView];

  // ticks marks view
  [UIViewHelper addConstraintsWithVisualFormat:@"V:|-0-[tickMarksView]-0-|"
                                       options:0
                                       metrics:nil
                                         views:viewsDictionary
                                        toView:self];
  [UIViewHelper addConstraintsWithVisualFormat:@"H:|-0-[tickMarksView]-0-|"
                                       options:0
                                       metrics:nil
                                         views:viewsDictionary
                                        toView:self];

  // thumbview's constraints
  [UIViewHelper addConstraintWithItem:thumbView
                            attribute:NSLayoutAttributeTop
                            relatedBy:NSLayoutRelationEqual
                               toItem:self
                            attribute:NSLayoutAttributeTop
                           multiplier:1
                             constant:0
                               toView:self];
  [UIViewHelper addConstraintWithItem:thumbView.node
                            attribute:NSLayoutAttributeCenterY
                            relatedBy:NSLayoutRelationEqual
                               toItem:trackView
                            attribute:NSLayoutAttributeCenterY
                           multiplier:1
                             constant:0
                               toView:self];
  thumbCenterXConstraint =
      [UIViewHelper addConstraintWithItem:thumbView
                                attribute:NSLayoutAttributeCenterX
                                relatedBy:NSLayoutRelationEqual
                                   toItem:trackView
                                attribute:NSLayoutAttributeLeft
                               multiplier:1
                                 constant:0
                                   toView:self];
}

- (void)layoutContent {

  if (constraintsArray)
    [self removeConstraints:constraintsArray];

  NSMutableArray *constraintsMutableArray = [NSMutableArray array];
  if (leftIcon.hasContent) {
    leftIcon.hidden = NO;
    [constraintsMutableArray
        addObjectsFromArray:[UIViewHelper
                                addConstraintsWithVisualFormat:
                                    @"H:|-0-[leftIcon]-trackPadding-[trackView]"
                                                       options:0
                                                       metrics:metricsDictionary
                                                         views:viewsDictionary
                                                        toView:self]];
  } else {
    leftIcon.hidden = YES;
    [constraintsMutableArray
        addObjectsFromArray:
            [UIViewHelper
                addConstraintsWithVisualFormat:@"H:|-trackPadding-[trackView]"
                                       options:0
                                       metrics:metricsDictionary
                                         views:viewsDictionary
                                        toView:self]];
  }

  if (rightIcon.hasContent) {
    rightIcon.hidden = NO;
    [constraintsMutableArray
        addObjectsFromArray:
            [UIViewHelper addConstraintsWithVisualFormat:
                              @"H:[trackView]-trackPadding-[rightIcon]-0-|"
                                                 options:0
                                                 metrics:metricsDictionary
                                                   views:viewsDictionary
                                                  toView:self]];

  } else {
    rightIcon.hidden = YES;
    [constraintsMutableArray
        addObjectsFromArray:
            [UIViewHelper
                addConstraintsWithVisualFormat:@"H:[trackView]-trackPadding-|"
                                       options:0
                                       metrics:metricsDictionary
                                         views:viewsDictionary
                                        toView:self]];
  }

  constraintsArray = constraintsMutableArray;
}

- (void)updateIntensity {
  float intentsity;
  if (_value == _minimumValue)
    intentsity = 0;
  else {
    intentsity = (_value - _minimumValue) / (_maximumValue - _minimumValue);
  }
  intensityWidthConstraint.constant = intentsity * trackView.bounds.size.width;
  thumbCenterXConstraint.constant = intensityWidthConstraint.constant;

  [UIView animateWithDuration:kMDAnimationDuration
                   animations:^{
                     [self layoutIfNeeded];
                   }];
}

- (void)updateColors {
  if (self.enabled) {
    trackView.backgroundColor = _trackOffColor;
    intensityView.backgroundColor = _trackOnColor;
  } else {
    trackView.backgroundColor = _disabledColor;
    intensityView.backgroundColor = _disabledColor;
  }
  [thumbView changeThumbShape:NO withValue:rawValue];
}

- (void)updateTrackOverlayLayer {
  UIBezierPath *path = [self createTrackLayerPath];
  trackOverlayLayer.path = path.CGPath;
}

- (UIBezierPath *)createTrackLayerPath {
  UIBezierPath *path = [UIBezierPath
      bezierPathWithRect:CGRectMake(-5, 0, trackView.bounds.size.width + 10,
                                    trackView.bounds.size.height)];
  if (!self.enabled) {
    float thumbRadius;
    switch (thumbView.state) {
    case Normal:
      thumbRadius = kMDThumbRadius;
      break;
    case Focused:
      thumbRadius = kMDThumbForcusedRadius;
      break;
    case Disabled:
      thumbRadius = kMDThumbDisabledRadius;
      break;

    default:
      break;
    }

    thumbRadius += kMDTrackWidth;

    UIBezierPath *circlePath = [UIBezierPath
        bezierPathWithRect:CGRectMake(
                               thumbCenterXConstraint.constant - thumbRadius, 0,
                               thumbRadius * 2, trackView.bounds.size.height)];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
  }
  return path;
}

- (void)snapsThumbToTicks {
  float value = [tickMarksView theNearestTickValueFromValue:rawValue];
  [self setRawValue:value];
  if (value != _value) {
    self.value = value;
  }
}

- (void)setRawValue:(float)value {
  rawValue = value;
  [self updateIntensity];
}

#pragma mark setters
- (void)setLeftImage:(UIImage *)leftImage {
  [leftIcon setImage:leftImage];
  [self layoutContent];
}

- (void)setRightImage:(UIImage *)rightImage {
  [rightIcon setImage:rightImage];
  [self layoutContent];
}

- (void)setMinimumValue:(float)minimumValue {
  _minimumValue = minimumValue;
  if (_minimumValue > _maximumValue) {
    float f = _minimumValue;
    _minimumValue = _maximumValue;
    _maximumValue = f;
    [thumbView.bubble setMaxValue:_maximumValue];
  }
  if (_value < _minimumValue) {
    self.value = _minimumValue;
  } else {
    [self updateIntensity];
    [thumbView changeThumbShape:YES withValue:rawValue];
  }

  tickMarksView.minimumValue = _minimumValue;
}

- (void)setMaximumValue:(float)maximumValue {
  _maximumValue = maximumValue;
  if (_minimumValue > _maximumValue) {
    float f = _minimumValue;
    _minimumValue = _maximumValue;
    _maximumValue = f;
  }

  [thumbView.bubble setMaxValue:_maximumValue];

  if (_value > _maximumValue) {
    self.value = _maximumValue;
  } else {
    [self updateIntensity];
  }

  tickMarksView.maximumValue = _maximumValue;
}

- (void)setStep:(float)step {
  _step = step;
  tickMarksView.step = step;
  if (step > 0 && _enabledValueLabel) {
    [thumbView enableBubble:YES];
  } else {
    [thumbView enableBubble:NO];
  }
}

- (void)setEnabledValueLabel:(BOOL)enabledValueLabel {
  _enabledValueLabel = enabledValueLabel;
  if (_step > 0 && _enabledValueLabel) {
    [thumbView enableBubble:YES];
  } else {
    [thumbView enableBubble:NO];
  }
}

- (void)setValue:(float)value {
  if (_value != value) {
    if (value < _minimumValue)
      _value = _minimumValue;
    else if (value > _maximumValue)
      _value = _maximumValue;
    else
      _value = value;
    [self sendActionsForControlEvents:UIControlEventValueChanged];

    [self setRawValue:_value];
    [self updateIntensity];
    [thumbView.bubble setValue:value];
    [thumbView changeThumbShape:YES withValue:rawValue];
  }
}

- (void)setTrackOffColor:(UIColor *)trackOffColor {
  _trackOffColor = trackOffColor;
  [self updateColors];
}

- (void)setTrackOnColor:(UIColor *)trackOnColor {
  _trackOnColor = trackOnColor;
  [self updateColors];
}

- (void)setThumbOffColor:(UIColor *)thumbOffColor {
  _thumbOffColor = thumbOffColor;
  [self updateColors];
}

- (void)setThumbOnColor:(UIColor *)thumbOnColor {
  _thumbOnColor = thumbOnColor;
  [self updateColors];
}

- (void)setDisabledColor:(UIColor *)disabledColor {
  _disabledColor = disabledColor;
  [self updateColors];
}

- (void)setEnabled:(BOOL)enabled {
  if (super.enabled != enabled) {
    super.enabled = enabled;
    if (enabled) {
      trackView.backgroundColor = _trackOffColor;
      [thumbView lostFocused:^(BOOL finished) {
        if (finished) {
          [self updateTrackOverlayLayer];
          intensityView.hidden = NO;
          tickMarksView.hidden = NO;
        }
      }];
    } else {
      tickMarksView.hidden = YES;
      intensityView.hidden = YES;
      trackView.backgroundColor = _disabledColor;
      [thumbView disabled:^(BOOL finished) {
        if (finished) {
        }
      }];
      [self updateTrackOverlayLayer];
    }

    [thumbView changeThumbShape:YES withValue:rawValue];
  }
}

- (void)setPrecision:(NSUInteger)precision {
  _precision = precision;
  thumbView.bubble.precision = precision;
}
#pragma mark touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint point = [touches.allObjects[0] locationInView:trackView];
  [self calculateValueFromTouchPoint:point];
  [thumbView focused:nil];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint point = [touches.allObjects[0] locationInView:trackView];
  [self calculateValueFromTouchPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [thumbView lostFocused:nil];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [thumbView lostFocused:nil];
}

- (void)calculateValueFromTouchPoint:(CGPoint)touchedPoint {
  float intentsity = touchedPoint.x / trackView.bounds.size.width;
  if (intentsity < 0)
    intentsity = 0;
  if (intentsity > 1)
    intentsity = 1;

  [self
      setRawValue:(_maximumValue - _minimumValue) * intentsity + _minimumValue];

  if (_step <= 0) {
    self.value = rawValue;

  } else {
    [self snapsThumbToTicks];
  }
}

#pragma mark value observer
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (object == trackView && [keyPath isEqualToString:@"bounds"]) {
    [self updateIntensity];
    [self updateTrackOverlayLayer];
  }
}

- (void)dealloc {
  [trackView removeObserver:self forKeyPath:@"bounds"];
}

@end
