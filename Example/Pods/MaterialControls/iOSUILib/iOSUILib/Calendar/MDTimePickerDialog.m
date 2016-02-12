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

#import "NSDate+MDExtension.h"
#import "UIView+MDExtension.h"
#import "MDButton.h"
#import "MDTimePickerDialog.h"
#import "UIColorHelper.h"
#import "UIFontHelper.h"
#import "MDDeviceHelper.h"
#import "NSDateHelper.h"

#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees) / 180)

#define kCalendarHeaderHeight                                                  \
  (([[UIScreen mainScreen] bounds].size.width > 320) ? 120 : 70)
#define kCalendarTimerModeHeight 60
#define kCalendarActionBarHeight 50
#define kCalendarClockHeight                                                   \
  (MIN(popupHolder.mdWidth, popupHolder.mdHeight) * 4.5 / 6.0)

#define kMainCircleRadius 15
#define kSmallCircleRadius 2
#define kHourItemSize 30

@interface MDTimePickerDialog ()

@property(nonatomic) CAShapeLayer *backgroundColock;

@property(nonatomic) MDCalendarTimeMode pickerClockMode;
@property(nonatomic) UILabel *labelTimeModeAM;
@property(nonatomic) UILabel *labelTimeModePM;
@property(nonatomic) CAShapeLayer *backgroundTimeMode;

@property(nonatomic) UIView *clockHour;
@property(nonatomic) UIView *clockMinute;
@property(nonatomic) UIView *clockHandView;
@property(nonatomic) CAShapeLayer *maskVisibleIndexLayer;
@property(nonatomic) CAShapeLayer *maskInvisibleIndexLayer;

@property(nonatomic) UIColor *headerTextColor;
@property(nonatomic) UIColor *headerBackgroundColor;
@property(nonatomic) UIColor *titleColor;
@property(nonatomic) UIColor *titleSelectedColor;
@property(nonatomic) UIColor *selectionColor;
@property(nonatomic) UIColor *selectionCenterColor;
@property(nonatomic) UIColor *backgroundPopupColor;
@property(nonatomic) UIColor *backgroundClockColor;
@end

@implementation MDTimePickerDialog {
  UIView *popupHolder;

  NSInteger currentHour;
  NSInteger currentMinute;

  NSInteger preHourTag;
  NSInteger preMinuteTag;

  NSString *currentTimeModeStr;

  CAShapeLayer *selectorCircleLayer;
  UIBezierPath *selectorCirclePath;
  UIBezierPath *selectorMinCirclePath;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self initDefaultTime];
    [self initialize];
  }

  return self;
}

- (instancetype)initWithHour:(NSInteger)hour andWithMinute:(NSInteger)minute {
  self = [super init];
  if (self) {

    currentHour = (int)hour % 24;
    currentMinute = (int)minute % 60;

    [self initialize];
  }

  return self;
}

- (void)initialize {
  [self initDefaultValues];
  [self initTheme];

  [self initComponents];
  [self initClockHandView];
  [self initClock];

  UIPanGestureRecognizer *panGesture =
      [[UIPanGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(rotateHand:)];
  panGesture.delegate = self;
  [panGesture setMaximumNumberOfTouches:1];
  [self addGestureRecognizer:panGesture];

  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(tapGestureHandler:)];
  [popupHolder addGestureRecognizer:tapGesture];

  [self updateHeaderView];
  [popupHolder bringSubviewToFront:_labelTimeModeAM];
  [popupHolder bringSubviewToFront:_labelTimeModePM];

  [self addTarget:self
                action:@selector(btnClick:)
      forControlEvents:UIControlEventTouchUpInside];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(deviceOrientationDidChange:)
             name:UIDeviceOrientationDidChangeNotification
           object:nil];
}

- (void)initDefaultTime {
  NSDate *currentDate = [NSDate date];
  currentHour = (int)currentDate.mdHour;
  currentMinute = (int)currentDate.mdMinute;

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setLocale:[NSLocale currentLocale]];
  [formatter setDateStyle:NSDateFormatterNoStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  NSString *dateString = [formatter stringFromDate:currentDate];
  NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
  NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];

  if (amRange.length != NSNotFound) {
    currentTimeModeStr = @"AM";
  } else if (pmRange.length != NSNotFound) {
    currentTimeModeStr = @"PM";
  } else {
    currentTimeModeStr = nil;
  }
}

- (void)initDefaultValues {
  if ([NSDateHelper prefers24Hour]) {
    _pickerClockMode = MDCalendarTimeMode24H;
  } else {
    _pickerClockMode = MDCalendarTimeMode12H;

    if (currentTimeModeStr == nil) {
      if (currentHour < 12) {
        currentTimeModeStr = @"AM";
      } else {
        currentTimeModeStr = @"PM";
      }
    }
    currentHour %= 12;
    if (currentHour == 0)
      currentHour = 12;
  }

  preHourTag = -1;
  preMinuteTag = -1;
}

- (void)initTheme {
  int theme = 1;
  if (theme == 0) { // light
    _headerTextColor = [UIColor whiteColor];
    _headerBackgroundColor = [UIColorHelper colorWithRGBA:@"#009688"];

    _titleColor = [UIColorHelper colorWithRGBA:@"#2F2F2F"];
    _titleSelectedColor = [UIColor whiteColor];
    _selectionColor = [UIColorHelper colorWithRGBA:@"#009688"];
    _selectionCenterColor = [UIColorHelper colorWithRGBA:@"#000302"];

    _backgroundPopupColor = [UIColor whiteColor];
    _backgroundClockColor = [UIColorHelper colorWithRGBA:@"#ECEFF1"];
  } else { // dark
    _headerTextColor = [UIColor whiteColor];
    _headerBackgroundColor = [UIColorHelper colorWithRGBA:@"#80CBC4"];

    _titleColor = [UIColor whiteColor];
    _titleSelectedColor = [UIColor whiteColor];
    _selectionColor = [UIColorHelper colorWithRGBA:@"#80CBC4"];
    _selectionCenterColor = [UIColor whiteColor];

    _backgroundPopupColor = [UIColorHelper colorWithRGBA:@"#263238"];
    _backgroundClockColor = [UIColorHelper colorWithRGBA:@"#364147"];
  }
}

- (void)initComponents {
  UIView *rootView = [MDDeviceHelper getMainView];
  [self setFrame:rootView.bounds];

  popupHolder = [[UIView alloc] init];
  popupHolder.layer.shadowOpacity = 0.5;
  popupHolder.layer.shadowRadius = 8;
  popupHolder.layer.shadowColor = [[UIColor blackColor] CGColor];
  popupHolder.layer.shadowOffset = CGSizeMake(0, 2.5);

  int vSpacing = rootView.bounds.size.height * 0.05;
  int hSpacing = rootView.bounds.size.width * 0.1;

  [popupHolder
      setFrame:CGRectMake(hSpacing, vSpacing, self.mdWidth - 2 * hSpacing,
                          self.mdHeight - 2 * vSpacing)];

  _buttonFont = [UIFontHelper robotoFontWithName:@"roboto-bold" size:15];

  MDButton *buttonOk = [[MDButton alloc]
      initWithFrame:CGRectMake(popupHolder.mdWidth -
                                   2 * kCalendarActionBarHeight,
                               popupHolder.mdHeight - kCalendarActionBarHeight,
                               2 * kCalendarActionBarHeight * 3.0 / 4.0,
                               kCalendarActionBarHeight * 3.0 / 4.0)
               type:Flat
        rippleColor:nil];
  [buttonOk setTitle:@"OK" forState:normal];
  [buttonOk setTitleColor:[UIColor blueColor] forState:normal];
  [buttonOk addTarget:self
                action:@selector(didSelect)
      forControlEvents:UIControlEventTouchUpInside];
  [buttonOk.titleLabel setFont:_buttonFont];
  [popupHolder addSubview:buttonOk];
  self.buttonOk = buttonOk;

  MDButton *buttonCancel = [[MDButton alloc]
      initWithFrame:CGRectMake(popupHolder.mdWidth -
                                   4 * kCalendarActionBarHeight,
                               popupHolder.mdHeight - kCalendarActionBarHeight,
                               2 * kCalendarActionBarHeight * 3.0 / 4.0,
                               kCalendarActionBarHeight * 3.0 / 4.0)
               type:Flat
        rippleColor:nil];
  [buttonCancel setTitle:@"CANCEL" forState:normal];
  [buttonCancel setTitleColor:[UIColor blueColor] forState:normal];
  [buttonCancel addTarget:self
                   action:@selector(didCancell)
         forControlEvents:UIControlEventTouchUpInside];
  [buttonCancel.titleLabel setFont:_buttonFont];
  [popupHolder addSubview:buttonCancel];
  self.buttonCancel = buttonCancel;

  [self.buttonCancel setTitleColor:_titleColor forState:UIControlStateNormal];
  [self.buttonOk setTitleColor:_titleColor forState:UIControlStateNormal];

  [self addTarget:self
                action:@selector(btnClick:)
      forControlEvents:UIControlEventTouchUpInside];

  [self initHeaderView];

  // time mode component
  if (_pickerClockMode == MDCalendarTimeMode12H) {
    _labelTimeModeAM = [[UILabel alloc]
        initWithFrame:CGRectMake(
                          40, kCalendarHeaderHeight + kCalendarClockHeight +
                                  (popupHolder.mdWidth - kCalendarClockHeight),
                          40, 40)];
    _labelTimeModeAM.textColor = _titleColor;
    _labelTimeModeAM.text = @"AM";
    _labelTimeModeAM.textAlignment = NSTextAlignmentCenter;

    _labelTimeModePM = [[UILabel alloc]
        initWithFrame:CGRectMake(
                          popupHolder.mdWidth - 80,
                          kCalendarHeaderHeight + kCalendarClockHeight +
                              (popupHolder.mdWidth - kCalendarClockHeight),
                          40, 40)];
    _labelTimeModePM.textColor = _titleColor;
    _labelTimeModePM.text = @"PM";
    _labelTimeModePM.textAlignment = NSTextAlignmentCenter;

    _backgroundTimeMode = [[CAShapeLayer alloc] init];
    _backgroundTimeMode.backgroundColor = [UIColor clearColor].CGColor;
    _backgroundTimeMode.frame =
        CGRectMake(50, kCalendarHeaderHeight + kCalendarClockHeight +
                           (popupHolder.mdWidth - kCalendarClockHeight),
                   40, 40);
    _backgroundTimeMode.path =
        [UIBezierPath bezierPathWithOvalInRect:_backgroundTimeMode.bounds]
            .CGPath;
    _backgroundTimeMode.fillColor = _selectionColor.CGColor;
    [popupHolder.layer insertSublayer:_backgroundTimeMode atIndex:0];

    [popupHolder addSubview:_labelTimeModeAM];
    [popupHolder addSubview:_labelTimeModePM];

    UITapGestureRecognizer *showTimeModeAMSelectorGesture =
        [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(changeTimeModeAM)];

    [_labelTimeModeAM addGestureRecognizer:showTimeModeAMSelectorGesture];
    [_labelTimeModeAM setUserInteractionEnabled:YES];

    UITapGestureRecognizer *showTimeModePMSelectorGesture =
        [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(changeTimeModePM)];

    [_labelTimeModePM addGestureRecognizer:showTimeModePMSelectorGesture];
    [_labelTimeModePM setUserInteractionEnabled:YES];

    if ([currentTimeModeStr isEqualToString:@"AM"]) {
      [self changeTimeModeAM];
    } else {
      [self changeTimeModePM];
    }
  }

  [popupHolder setBackgroundColor:_backgroundPopupColor];
  [self addSubview:popupHolder];
  [self setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
}

- (void)initHeaderView {
  _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, popupHolder.mdWidth,
                                                     kCalendarHeaderHeight)];

  _headerLabelHour = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, _header.mdWidth / 2, _header.mdHeight)];
  _headerLabelHour.font = [UIFontHelper robotoFontOfSize:43];
  _headerLabelHour.textAlignment = NSTextAlignmentRight;

  _headerLabelMinute = [[UILabel alloc]
      initWithFrame:CGRectMake(_header.mdWidth / 2, 0, _header.mdWidth / 2,
                               _header.mdHeight)];
  _headerLabelMinute.textAlignment = NSTextAlignmentLeft;
  _headerLabelMinute.font = [UIFontHelper robotoFontOfSize:43];

  [_headerLabelHour setTextColor:_headerTextColor];
  [_headerLabelMinute setTextColor:_headerTextColor];

  [_header addSubview:_headerLabelHour];
  [_header addSubview:_headerLabelMinute];
  [popupHolder addSubview:_header];
  [_header setBackgroundColor:_headerBackgroundColor];

  UITapGestureRecognizer *showClockHourSelectorGesture =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(showClockHour)];
  UITapGestureRecognizer *showClockMinuteSelectorGesture = [
      [UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(showClockMinute)];

  [_headerLabelHour addGestureRecognizer:showClockHourSelectorGesture];
  [_headerLabelHour setUserInteractionEnabled:YES];
  [_headerLabelMinute addGestureRecognizer:showClockMinuteSelectorGesture];
  [_headerLabelMinute setUserInteractionEnabled:YES];
}

- (void)initClock {
  // init hour clock
  _clockHour = [[UIView alloc]
      initWithFrame:CGRectMake(
                        (popupHolder.mdWidth - kCalendarClockHeight) / 2,
                        kCalendarHeaderHeight +
                            (popupHolder.mdWidth - kCalendarClockHeight) / 2,
                        kCalendarClockHeight, kCalendarClockHeight)];

  _backgroundColock = [[CAShapeLayer alloc] init];
  _backgroundColock.backgroundColor = [UIColor clearColor].CGColor;
  _backgroundColock.frame = _clockHour.frame;
  _backgroundColock.path =
      [UIBezierPath bezierPathWithOvalInRect:_backgroundColock.bounds].CGPath;
  _backgroundColock.fillColor = _backgroundClockColor.CGColor;
  [popupHolder.layer insertSublayer:_backgroundColock atIndex:0];

  double stepAngle = 2 * M_PI / 12;
  float x_point;
  float y_point;
  if (_pickerClockMode == MDCalendarTimeMode12H) {
    for (int i = 1; i < 13; i++) {
      UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
      [bt setFrame:CGRectMake(0, 0, kHourItemSize, kHourItemSize)];
      [bt setTag:(110 + i)];

      [bt setBackgroundColor:[UIColor clearColor]];
      [bt.layer setCornerRadius:bt.frame.size.width / 2];

      [bt.titleLabel setFont:[UIFontHelper robotoFontOfSize:15.0]];
      x_point = _clockHour.mdWidth / 2 +
                sin(stepAngle * i) *
                    (kCalendarClockHeight / 2 - kHourItemSize * 2.0 / 3.0);
      y_point = _clockHour.mdHeight / 2 -
                cos(stepAngle * i) *
                    (kCalendarClockHeight / 2 - kHourItemSize * 2.0 / 3.0);

      [bt setTitle:[NSString stringWithFormat:@"%d", i]
          forState:UIControlStateNormal];
      [bt setTitleColor:_titleColor forState:UIControlStateNormal];
      [_clockHour addSubview:bt];

      [bt setCenter:CGPointMake(x_point, y_point)];
      [bt addTarget:self
                    action:@selector(timeClicked:)
          forControlEvents:UIControlEventTouchUpInside];
      [bt.titleLabel setTextAlignment:NSTextAlignmentCenter];
      [self bringSubviewToFront:bt];
    }
  } else {
    for (int i = 1; i < 25; i++) {
      UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
      [bt setFrame:CGRectMake(0, 0, kHourItemSize, kHourItemSize)];
      [bt setTag:(110 + i)];

      [bt setBackgroundColor:[UIColor clearColor]];
      [bt.layer setCornerRadius:bt.frame.size.width / 2];

      if (i < 13) {
        [bt.titleLabel setFont:[UIFontHelper robotoFontOfSize:15.0]];

        x_point =
            _clockHour.mdWidth / 2 +
            sin(stepAngle * i) * (kCalendarClockHeight / 2 - kHourItemSize -
                                  kHourItemSize * 2.0 / 3.0);
        y_point =
            _clockHour.mdHeight / 2 -
            cos(stepAngle * i) * (kCalendarClockHeight / 2 - kHourItemSize -
                                  kHourItemSize * 2.0 / 3.0);
      } else {
        [bt.titleLabel setFont:[UIFontHelper robotoFontOfSize:11.0]];

        x_point = _clockHour.mdWidth / 2 +
                  sin(stepAngle * i) *
                      (kCalendarClockHeight / 2 - kHourItemSize * 2.0 / 3.0);
        y_point = _clockHour.mdHeight / 2 -
                  cos(stepAngle * i) *
                      (kCalendarClockHeight / 2 - kHourItemSize * 2.0 / 3.0);
      }

      [bt setTitle:[NSString stringWithFormat:@"%d", (i % 24)]
          forState:UIControlStateNormal];
      [bt setTitleColor:_titleColor forState:UIControlStateNormal];
      [_clockHour addSubview:bt];

      [bt setCenter:CGPointMake(x_point, y_point)];
      [bt addTarget:self
                    action:@selector(timeClicked:)
          forControlEvents:UIControlEventTouchUpInside];
      [bt.titleLabel setTextAlignment:NSTextAlignmentCenter];
      [self bringSubviewToFront:bt];
    }
  }

  _clockMinute = [[UIView alloc]
      initWithFrame:CGRectMake(
                        (popupHolder.mdWidth - kCalendarClockHeight) / 2,
                        kCalendarHeaderHeight +
                            (popupHolder.mdWidth - kCalendarClockHeight) / 2,
                        kCalendarClockHeight, kCalendarClockHeight)];
  for (int i = 1; i < 13; i++) {
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:CGRectMake(0, 0, kHourItemSize, kHourItemSize)];
    [bt setTag:110 + 24 + i];

    [bt setBackgroundColor:[UIColor clearColor]];
    [bt.layer setCornerRadius:bt.frame.size.width / 2];

    [bt.titleLabel setFont:[UIFontHelper robotoFontOfSize:15.0]];
    [bt setTitleColor:_titleColor forState:UIControlStateNormal];

    x_point = _clockHour.mdWidth / 2 +
              sin(stepAngle * i) *
                  (kCalendarClockHeight / 2 - kHourItemSize * 2.0 / 3.0);
    y_point = _clockHour.mdHeight / 2 -
              cos(stepAngle * i) *
                  (kCalendarClockHeight / 2 - kHourItemSize * 2.0 / 3.0);

    if (i * 5 == 60) {
      [bt setTitle:@"00" forState:UIControlStateNormal];
    } else {
      [bt setTitle:[NSString stringWithFormat:@"%02d", 5 * i]
          forState:UIControlStateNormal];
    }
    [_clockMinute addSubview:bt];

    [bt setCenter:CGPointMake(x_point, y_point)];
    [bt addTarget:self
                  action:@selector(timeClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [bt.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self bringSubviewToFront:bt];
  }

  [_clockHour setBackgroundColor:[UIColor clearColor]];
  [_clockMinute setBackgroundColor:[UIColor clearColor]];

  [popupHolder addSubview:_clockHour];
  [popupHolder addSubview:_clockMinute];

  _clockHour.hidden = NO;
  _clockMinute.hidden = YES;
}

- (void)initClockHandView {
  _clockHandView = [[UIView alloc]
      initWithFrame:CGRectMake(
                        (popupHolder.mdWidth - kCalendarClockHeight) / 2,
                        kCalendarHeaderHeight +
                            (popupHolder.mdWidth - kCalendarClockHeight) / 2,
                        kCalendarClockHeight, kCalendarClockHeight)];
  [_clockHandView.layer setCornerRadius:5.0];
  [_clockHandView setBackgroundColor:[UIColor clearColor]];
  [popupHolder addSubview:_clockHandView];

  NSEnumerator *enumerator =
      [_maskVisibleIndexLayer.sublayers reverseObjectEnumerator];
  for (CALayer *layer in enumerator) {
    [layer removeFromSuperlayer];
  }

  float padding = 4;
  // Shape layer mask - visible index
  _maskVisibleIndexLayer = [CAShapeLayer layer];
  [_maskVisibleIndexLayer setFillRule:kCAFillRuleEvenOdd];
  [_maskVisibleIndexLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
  [_clockHandView.layer addSublayer:_maskVisibleIndexLayer];

  UIBezierPath *centerCirclePath = [UIBezierPath bezierPath];

  CGPoint centerCirclePoint =
      CGPointMake(_clockHandView.mdWidth / 2, _clockHandView.mdHeight / 2);
  centerCirclePath =
      [UIBezierPath bezierPathWithArcCenter:centerCirclePoint
                                     radius:kSmallCircleRadius
                                 startAngle:0
                                   endAngle:DEGREES_TO_RADIANS(360)
                                  clockwise:NO];

  [centerCirclePath moveToPoint:centerCirclePoint];
  CGPoint line_Point =
      CGPointMake(centerCirclePoint.x,
                  centerCirclePoint.y - (kCalendarClockHeight) / 2 +
                      (kMainCircleRadius * 2 + kSmallCircleRadius) + padding);
  [centerCirclePath addLineToPoint:line_Point];
  selectorCirclePath = [UIBezierPath
      bezierPathWithArcCenter:CGPointMake(line_Point.x - 1.0f,
                                          line_Point.y - (kMainCircleRadius))
                       radius:kMainCircleRadius
                   startAngle:0
                     endAngle:DEGREES_TO_RADIANS(360)
                    clockwise:NO];

  selectorMinCirclePath = [UIBezierPath
      bezierPathWithArcCenter:CGPointMake(line_Point.x - 1.0f,
                                          line_Point.y + (kMainCircleRadius))
                       radius:kMainCircleRadius
                   startAngle:0
                     endAngle:DEGREES_TO_RADIANS(360)
                    clockwise:NO];
  CGMutablePathRef combinedPath =
      CGPathCreateMutableCopy(selectorCirclePath.CGPath);
  CGPathAddPath(combinedPath, NULL, selectorMinCirclePath.CGPath);

  selectorCircleLayer = [CAShapeLayer layer];
  selectorCircleLayer.path = selectorCirclePath.CGPath;
  [selectorCircleLayer setStrokeColor:_selectionColor.CGColor];
  selectorCircleLayer.lineWidth = 1;
  [selectorCircleLayer setFillColor:_selectionColor.CGColor];
  selectorCircleLayer.opacity = 1.0f;

  // Small Circle Layer
  CAShapeLayer *centerCircleLayer = [CAShapeLayer layer];
  centerCircleLayer.path = centerCirclePath.CGPath;
  [centerCircleLayer setStrokeColor:_selectionCenterColor.CGColor];
  centerCircleLayer.lineWidth = 1.0f;
  [centerCircleLayer setFillColor:_selectionCenterColor.CGColor];
  centerCircleLayer.opacity = 1.0f;

  [_maskVisibleIndexLayer addSublayer:centerCircleLayer];
  [_maskVisibleIndexLayer addSublayer:selectorCircleLayer];

  // mask layer - invisible index (minute)
  enumerator = [_maskInvisibleIndexLayer.sublayers reverseObjectEnumerator];
  for (CALayer *layer in enumerator) {
    [layer removeFromSuperlayer];
  }
  // Shape layer mask - visible index
  _maskInvisibleIndexLayer = [CAShapeLayer layer];
  [_maskInvisibleIndexLayer setFillRule:kCAFillRuleEvenOdd];
  [_maskInvisibleIndexLayer setFillColor:[[UIColor colorWithHue:0.0f
                                                     saturation:0.0f
                                                     brightness:0.0f
                                                          alpha:0.9f] CGColor]];
  [_maskInvisibleIndexLayer setBackgroundColor:[[UIColor clearColor] CGColor]];

  UIBezierPath *centerInvisibleIndexCirclePath = [UIBezierPath bezierPath];

  CGPoint centerInvisibleIndexCirclePoint =
      CGPointMake(_clockHandView.mdWidth / 2, _clockHandView.mdHeight / 2);
  centerInvisibleIndexCirclePath =
      [UIBezierPath bezierPathWithArcCenter:centerInvisibleIndexCirclePoint
                                     radius:kSmallCircleRadius
                                 startAngle:0
                                   endAngle:DEGREES_TO_RADIANS(360)
                                  clockwise:NO];

  [centerInvisibleIndexCirclePath moveToPoint:centerInvisibleIndexCirclePoint];
  line_Point = CGPointMake(
      centerInvisibleIndexCirclePoint.x,
      centerInvisibleIndexCirclePoint.y - (kCalendarClockHeight) / 2 +
          (kMainCircleRadius + kSmallCircleRadius) + padding);
  [centerInvisibleIndexCirclePath addLineToPoint:line_Point];
  UIBezierPath *selectorInvisibleIndexCirclePath = [UIBezierPath
      bezierPathWithArcCenter:CGPointMake(line_Point.x - 1.0f, line_Point.y)
                       radius:kMainCircleRadius
                   startAngle:0
                     endAngle:DEGREES_TO_RADIANS(360)
                    clockwise:NO];
  CAShapeLayer *selectorInvisibleIndexCircleLayer = [CAShapeLayer layer];
  selectorInvisibleIndexCircleLayer.path =
      selectorInvisibleIndexCirclePath.CGPath;
  [selectorInvisibleIndexCircleLayer
      setStrokeColor:[_selectionColor colorWithAlphaComponent:0.5f].CGColor];
  selectorInvisibleIndexCircleLayer.lineWidth = 0;
  [selectorInvisibleIndexCircleLayer
      setFillColor:[_selectionColor colorWithAlphaComponent:0.5f].CGColor];
  selectorInvisibleIndexCircleLayer.opacity = 1.0f;

  // small circle layer in selector layer
  UIBezierPath *smallSelectorInvisibleIndexCirclePath = [UIBezierPath
      bezierPathWithArcCenter:CGPointMake(line_Point.x - 1.0f, line_Point.y)
                       radius:kSmallCircleRadius * 2
                   startAngle:0
                     endAngle:DEGREES_TO_RADIANS(360)
                    clockwise:NO];
  CAShapeLayer *smallInvisibleIndexCircleLayer = [CAShapeLayer layer];
  smallInvisibleIndexCircleLayer.path =
      smallSelectorInvisibleIndexCirclePath.CGPath;
  [smallInvisibleIndexCircleLayer setStrokeColor:_selectionColor.CGColor];
  smallInvisibleIndexCircleLayer.lineWidth = 1.0f;
  [smallInvisibleIndexCircleLayer setFillColor:_selectionColor.CGColor];
  smallInvisibleIndexCircleLayer.opacity = 1.0f;

  // Small Circle Layer
  CAShapeLayer *centerInvisibleIndexCircleLayer = [CAShapeLayer layer];
  centerInvisibleIndexCircleLayer.path = centerInvisibleIndexCirclePath.CGPath;
  [centerInvisibleIndexCircleLayer
      setStrokeColor:_selectionCenterColor.CGColor];
  centerInvisibleIndexCircleLayer.lineWidth = 1.0f;
  [centerInvisibleIndexCircleLayer setFillColor:_selectionCenterColor.CGColor];
  centerInvisibleIndexCircleLayer.opacity = 0.5f;

  [_maskInvisibleIndexLayer addSublayer:selectorInvisibleIndexCircleLayer];
  [_maskInvisibleIndexLayer addSublayer:centerInvisibleIndexCircleLayer];
  [_maskInvisibleIndexLayer addSublayer:smallInvisibleIndexCircleLayer];

  [_clockHandView.layer addSublayer:_maskInvisibleIndexLayer];

  _clockHandView.transform =
      CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(currentHour * 30));
  _clockHandView.backgroundColor = [UIColor clearColor];
  _clockHandView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)updateHeaderView {
  if (currentMinute == 60)
    currentMinute = 0;

  if (_pickerClockMode == MDCalendarTimeMode12H) {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]
        initWithString:[NSString stringWithFormat:@":%02d %@",
                                                  (int)currentMinute,
                                                  currentTimeModeStr]];

    [attString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor whiteColor]
                      range:NSMakeRange(0, 3)];

    [attString addAttribute:NSFontAttributeName
                      value:[UIFontHelper robotoFontOfSize:43]
                      range:NSMakeRange(0, 3)];

    [attString addAttribute:NSFontAttributeName
                      value:[UIFontHelper robotoFontOfSize:15]
                      range:NSMakeRange(3, 3)];
    _headerLabelMinute.attributedText = attString;
  } else {
    _headerLabelMinute.text =
        [NSString stringWithFormat:@":%02d", (int)currentMinute];
  }

  _headerLabelHour.text = [NSString stringWithFormat:@"%02d", (int)currentHour];

  if (_clockHour.hidden == NO) {
    _maskInvisibleIndexLayer.hidden = YES;
    _maskVisibleIndexLayer.hidden = NO;

    [_headerLabelHour
        setTextColor:[_headerLabelHour.textColor colorWithAlphaComponent:1]];
    [_headerLabelMinute setTextColor:[_headerLabelMinute.textColor
                                         colorWithAlphaComponent:0.5]];
  } else {
    if (currentMinute % 5 == 0) {
      _maskInvisibleIndexLayer.hidden = YES;
      _maskVisibleIndexLayer.hidden = NO;
    } else {
      _maskInvisibleIndexLayer.hidden = NO;
      _maskVisibleIndexLayer.hidden = YES;
    }

    [_headerLabelHour
        setTextColor:[_headerLabelHour.textColor colorWithAlphaComponent:0.5]];
    [_headerLabelMinute
        setTextColor:[_headerLabelMinute.textColor colorWithAlphaComponent:1]];
  }

  if (preHourTag != -1) {
    [((UIButton *)[_clockHour viewWithTag:preHourTag])
        setTitleColor:_titleColor
             forState:UIControlStateNormal];
  }
  if (preMinuteTag != -1) {
    [((UIButton *)[_clockMinute viewWithTag:preMinuteTag])
        setTitleColor:_titleColor
             forState:UIControlStateNormal];
  }

  [((UIButton *)[_clockHour viewWithTag:(currentHour + 110)])
      setTitleColor:_titleSelectedColor
           forState:UIControlStateNormal];
  preHourTag = currentHour + 110;
  if (currentMinute % 5 == 0) {
    int tag = (int)(currentMinute == 0 ? (12 + 110 + 24)
                                       : currentMinute / 5 + 110 + 24);
    preMinuteTag = tag;
    [((UIButton *)[_clockMinute viewWithTag:tag])
        setTitleColor:_titleSelectedColor
             forState:UIControlStateNormal];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];

  UIView *rootView = [MDDeviceHelper getMainView];
  int vSpacing = rootView.bounds.size.height * 0.05;
  int hSpacing = rootView.bounds.size.width * 0.1;
  if ([[UIScreen mainScreen] bounds].size.width > 320) {
  } else {
    vSpacing /= 2;
    hSpacing /= 2;
  }

  [popupHolder
      setFrame:CGRectMake(hSpacing, vSpacing, self.mdWidth - 2 * hSpacing,
                          self.mdHeight - 2 * vSpacing)];

  UIInterfaceOrientation orientation =
      [[UIApplication sharedApplication] statusBarOrientation];
  switch (orientation) {
  case UIInterfaceOrientationPortrait:
  case UIInterfaceOrientationPortraitUpsideDown: {
    if (rootView.bounds.size.height < rootView.bounds.size.width) {
      self.frame = CGRectMake(0, 0, rootView.bounds.size.height,
                              rootView.bounds.size.width);
      [popupHolder
          setFrame:CGRectMake(hSpacing, vSpacing,
                              rootView.bounds.size.height - 2 * hSpacing,
                              rootView.bounds.size.width - 2 * vSpacing)];
    }
    // load the portrait view
    _header.frame =
        CGRectMake(0, 0, popupHolder.mdWidth, kCalendarHeaderHeight);
    _clockHour.center =
        CGPointMake((popupHolder.mdWidth - kCalendarClockHeight) / 2 +
                        kCalendarClockHeight / 2,
                    kCalendarHeaderHeight +
                        (popupHolder.mdHeight - kCalendarActionBarHeight -
                         kCalendarHeaderHeight - kCalendarClockHeight) /
                            2 -
                        15 + kCalendarClockHeight / 2);
  } break;

  case UIInterfaceOrientationLandscapeLeft:
  case UIInterfaceOrientationLandscapeRight: {
    if (rootView.bounds.size.height > rootView.bounds.size.width) {
      self.frame = CGRectMake(0, 0, rootView.bounds.size.height,
                              rootView.bounds.size.width);
      [popupHolder
          setFrame:CGRectMake(hSpacing, vSpacing,
                              rootView.bounds.size.height - 2 * hSpacing,
                              rootView.bounds.size.width - 2 * vSpacing)];
    }

    // load the landscape view
    float headerWidthRatio = 0.5;
    if ([[UIScreen mainScreen] bounds].size.width <= 320)
      headerWidthRatio = 0.4;
    _header.frame = CGRectMake(0, 0, popupHolder.mdWidth * headerWidthRatio,
                               popupHolder.mdHeight - kCalendarActionBarHeight);
    _clockHour.center =
        CGPointMake(popupHolder.mdWidth * headerWidthRatio +
                        (popupHolder.mdWidth * (1 - headerWidthRatio) -
                         kCalendarClockHeight) /
                            2 +
                        kCalendarClockHeight / 2,
                    (popupHolder.mdHeight - kCalendarActionBarHeight -
                     kCalendarClockHeight) /
                            2 +
                        kCalendarClockHeight / 2);

    if ([[UIScreen mainScreen] bounds].size.width <= 320) {
      _clockHour.center =
          CGPointMake(popupHolder.mdWidth * headerWidthRatio +
                          (popupHolder.mdWidth * (1 - headerWidthRatio) -
                           kCalendarClockHeight) /
                              2 +
                          kCalendarClockHeight / 2,
                      kCalendarClockHeight / 2 - 10);
    }

  } break;
  case UIInterfaceOrientationUnknown:
    break;
  }

  if ([[UIScreen mainScreen] bounds].size.width <= 320) {
    _headerLabelHour.frame =
        CGRectMake(0, 0, _header.mdWidth / 2 - 20, _header.mdHeight);
    _headerLabelMinute.frame = CGRectMake(
        _header.mdWidth / 2 - 20, 0, _header.mdWidth / 2, _header.mdHeight);
  } else {
    _headerLabelHour.frame =
        CGRectMake(0, 0, _header.mdWidth / 2, _header.mdHeight);
    _headerLabelMinute.frame = CGRectMake(
        _header.mdWidth / 2, 0, _header.mdWidth / 2, _header.mdHeight);
  }

  _clockMinute.center = _clockHour.center;
  _backgroundColock.frame = _clockHour.frame;
  _clockHandView.center = _clockHour.center;

  if (_pickerClockMode == MDCalendarTimeMode12H) {
    if ([[UIScreen mainScreen] bounds].size.width <= 320) {
      _labelTimeModeAM.center =
          CGPointMake(_clockHour.center.x - _clockHour.mdWidth / 2 + 15,
                      _clockHour.center.y + _clockHour.mdHeight / 2 + 3);
      _labelTimeModePM.center =
          CGPointMake(_clockHour.center.x + _clockHour.mdWidth / 2 - 15,
                      _clockHour.center.y + _clockHour.mdHeight / 2 + 3);
    } else {
      _labelTimeModeAM.center =
          CGPointMake(_clockHour.center.x - _clockHour.mdWidth / 2 + 15,
                      _clockHour.center.y + _clockHour.mdHeight / 2 + 15);
      _labelTimeModePM.center =
          CGPointMake(_clockHour.center.x + _clockHour.mdWidth / 2 - 15,
                      _clockHour.center.y + _clockHour.mdHeight / 2 + 15);
    }

    if ([currentTimeModeStr isEqualToString:@"AM"]) {
      _backgroundTimeMode.frame = _labelTimeModeAM.frame;
    } else {
      _backgroundTimeMode.frame = _labelTimeModePM.frame;
    }
  }

  _buttonCancel.mdLeft = popupHolder.mdWidth - 4 * kCalendarActionBarHeight;
  _buttonCancel.mdTop = popupHolder.mdHeight - kCalendarActionBarHeight;
  _buttonOk.mdLeft = popupHolder.mdWidth - 2 * kCalendarActionBarHeight;
  _buttonOk.mdTop = popupHolder.mdHeight - kCalendarActionBarHeight;
}

#pragma mark Popup Handle

- (void)show {
  [self addSelfToMainWindow];
  self.hidden = NO;
  [self showClockHour];
}

- (void)addSelfToMainWindow {
  UIView *rootView = [MDDeviceHelper getMainView];
  [self setFrame:rootView.bounds];
  [rootView addSubview:self];
}

#pragma mark Clock Hand Actions
- (void)rotateHand:(UIView *)view rotationDegree:(float)degree {
  [UIView animateWithDuration:0.5
      delay:0
      options:UIViewAnimationOptionCurveEaseInOut
      animations:^{
        view.transform = CGAffineTransformMakeRotation((degree) * (M_PI / 180));
      }
      completion:^(BOOL finished) {
        if (_clockHour.hidden == NO) {
          [self showClockMinute];
        }
      }];
}

- (void)rotateHand:(UIPanGestureRecognizer *)recognizer {
  UIView *currentView;
  if (_clockHour.hidden == NO) {
    currentView = _clockHour;
  } else {
    currentView = _clockMinute;
  }
  CGPoint translation = [recognizer locationInView:currentView];
  if (_clockHour.hidden == YES) {
    float minutesFloat = (atan2f((translation.x - currentView.mdHeight / 2),
                                 (translation.y - currentView.mdWidth / 2)) *
                              -(180 / M_PI) +
                          180) /
                         6;
    float roundedUp = lroundf(minutesFloat);
    if (roundedUp == 60)
      roundedUp = 00;
    currentMinute = roundedUp;
    float angle = ((int)(currentMinute)) * 6;
    _clockHandView.transform =
        CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(angle));
  } else {
    NSUInteger hours = (atan2f((translation.x - currentView.mdHeight / 2),
                               (translation.y - currentView.mdWidth / 2)) *
                            -(180 / M_PI) +
                        180) /
                       30;
    if (hours == 0)
      hours = 12;
    float r = sqrtf(powf(currentView.mdWidth / 2 - translation.x, 2) +
                    powf(currentView.mdHeight / 2 - translation.y, 2));

    if (_pickerClockMode == MDCalendarTimeMode24H) {
      if (r > kCalendarClockHeight / 2 - kHourItemSize) {
        selectorCircleLayer.path = selectorCirclePath.CGPath;
        hours += 12;
        if (hours == 24)
          hours = 0;
      } else {
        selectorCircleLayer.path = selectorMinCirclePath.CGPath;
      }
    }

    currentHour = (int)hours;
    float angle = (currentHour % 12) * 30;
    _clockHandView.transform =
        CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(angle));
  }

  [self updateHeaderView];
  if (recognizer.state == UIGestureRecognizerStateEnded) {
    if (_clockMinute.hidden == YES)
      [self showClockMinute];
  }
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)sender {
  UIView *currentView;
  if (_clockHour.hidden == NO) {
    currentView = _clockHour;
  } else {
    currentView = _clockMinute;
  }
  CGPoint translation = [sender locationInView:currentView];

  float angle;
  if (_clockHour.hidden == YES) {
    float minutesFloat =
        (atan2f((translation.x - currentView.frame.size.height / 2),
                (translation.y - currentView.frame.size.width / 2)) *
             -(180 / M_PI) +
         180) /
        6;
    float roundedUp = lroundf(minutesFloat);
    if (roundedUp == 60)
      roundedUp = 00;
    currentMinute = roundedUp;
    angle = ((int)(currentMinute)) * 6;
  } else {
    NSUInteger hours =
        (atan2f((translation.x - currentView.frame.size.height / 2),
                (translation.y - currentView.frame.size.width / 2)) *
             -(180 / M_PI) +
         180) /
        30;
    if (hours == 0)
      hours = 12;
    float r = sqrtf(powf(currentView.mdWidth / 2 - translation.x, 2) +
                    powf(currentView.mdHeight / 2 - translation.y, 2));

    if (_pickerClockMode == MDCalendarTimeMode24H) {
      if (r > kCalendarClockHeight / 2 - kHourItemSize) {
        selectorCircleLayer.path = selectorCirclePath.CGPath;
        hours += 12;
        if (hours == 24)
          hours = 0;
      } else {
        selectorCircleLayer.path = selectorMinCirclePath.CGPath;
      }
    }

    currentHour = (int)hours;
    angle = (currentHour % 12) * 30;
  }
  [self rotateHand:_clockHandView rotationDegree:angle];
  [self updateHeaderView];
}

- (void)timeClicked:(id)sender {
  UIButton *selectedButton = (UIButton *)sender;

  int tag = (int)selectedButton.tag;
  CGFloat degreesToRotate;
  if (_clockHour.hidden == NO) {
    currentHour = tag - 110;
    degreesToRotate = (currentHour % 12) * 30;
    if (_pickerClockMode == MDCalendarTimeMode24H) {
      if (currentHour > 12) {
        selectorCircleLayer.path = selectorCirclePath.CGPath;
      } else {
        selectorCircleLayer.path = selectorMinCirclePath.CGPath;
      }
    }

    if (preHourTag != -1) {
      [((UIButton *)[_clockHour viewWithTag:preHourTag])
          setTitleColor:_titleColor
               forState:UIControlStateNormal];
    }

    preHourTag = tag;
  } else {
    currentMinute = (tag - 110 - 24) * 5;
    degreesToRotate = (currentMinute / 5) * 30;
    if (preMinuteTag != -1) {
      [((UIButton *)[_clockMinute viewWithTag:preMinuteTag])
          setTitleColor:_titleColor
               forState:UIControlStateNormal];
    }

    preMinuteTag = tag;
  }

  [self rotateHand:_clockHandView rotationDegree:degreesToRotate];
  [self updateHeaderView];
}

#pragma mark Delagate & Actions

- (void)changeTimeModeAM {
  currentTimeModeStr = @"AM";
  _backgroundTimeMode.frame = _labelTimeModeAM.frame;
  [_labelTimeModeAM setTextColor:_titleSelectedColor];
  [_labelTimeModePM setTextColor:_titleColor];

  [self updateHeaderView];
}
- (void)changeTimeModePM {
  currentTimeModeStr = @"PM";
  _backgroundTimeMode.frame = _labelTimeModePM.frame;
  [_labelTimeModeAM setTextColor:_titleColor];
  [_labelTimeModePM setTextColor:_titleSelectedColor];

  [self updateHeaderView];
}

- (void)showClockHour {
  if (_clockHour.hidden == YES) {
    _clockHour.hidden = NO;
    _clockHour.alpha = 0.0;

    _clockHour.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    [UIView animateWithDuration:0.3 / 1.5
        animations:^{
          _clockHour.alpha = 0.2;
          _clockHour.transform =
              CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
        }
        completion:^(BOOL finished) {
          [UIView animateWithDuration:0.3 / 2
              animations:^{
                _clockHour.transform =
                    CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                _clockHour.alpha = 1.0;
              }
              completion:^(BOOL finished) {
                [UIView animateWithDuration:0.6 / 2
                    animations:^{
                      _clockHour.transform = CGAffineTransformIdentity;
                    }
                    completion:^(BOOL finished) {
                      [self updateHeaderView];
                      [UIView animateWithDuration:0.1
                                       animations:^{
                                         _clockHandView.transform =
                                             CGAffineTransformMakeRotation(
                                                 DEGREES_TO_RADIANS(
                                                     currentHour * 30));
                                       }];
                    }];
              }];
        }];

    _clockMinute.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    _clockMinute.alpha = 0.2;
    [UIView animateWithDuration:0.3 / 2
        animations:^{
          _clockMinute.transform =
              CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        }
        completion:^(BOOL finished) {
          [UIView animateWithDuration:0.3 / 2
                           animations:^{
                             _clockMinute.alpha = 0.0;
                             _clockMinute.transform = CGAffineTransformIdentity;
                             _clockMinute.hidden = YES;
                           }];
        }];

    if (_pickerClockMode == MDCalendarTimeMode24H) {
      if (currentHour > 12) {
        selectorCircleLayer.path = selectorCirclePath.CGPath;
      } else {
        selectorCircleLayer.path = selectorMinCirclePath.CGPath;
      }
    }
  }
}

- (void)showClockMinute {
  if (_clockHour.hidden == NO) {
    _clockMinute.alpha = 0.0;
    _clockMinute.hidden = NO;
    _clockMinute.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);

    [UIView animateWithDuration:0.3 / 1.5
        animations:^{
          _clockMinute.alpha = 0.2;
          _clockMinute.transform =
              CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
        }
        completion:^(BOOL finished) {
          [UIView animateWithDuration:0.3 / 2
              animations:^{
                _clockMinute.transform =
                    CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                _clockMinute.alpha = 1.0;
              }
              completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 / 2
                    animations:^{
                      _clockMinute.transform = CGAffineTransformIdentity;
                    }
                    completion:^(BOOL finished) {
                      [self updateHeaderView];
                      [UIView animateWithDuration:0.1
                                       animations:^{
                                         _clockHandView.transform =
                                             CGAffineTransformMakeRotation(
                                                 DEGREES_TO_RADIANS(
                                                     currentMinute / 5 * 30));
                                       }];

                    }];
              }];
        }];

    _clockHour.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    _clockHour.alpha = 0.2;
    [UIView animateWithDuration:0.3 / 2
        animations:^{
          _clockHour.transform =
              CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        }
        completion:^(BOOL finished) {
          [UIView animateWithDuration:0.3 / 2
                           animations:^{
                             _clockHour.transform = CGAffineTransformIdentity;
                             _clockHour.hidden = YES;
                             _clockHour.alpha = 0.0;
                           }];
        }];

    selectorCircleLayer.path = selectorCirclePath.CGPath;
  }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
  UIInterfaceOrientation orientation =
      [[UIApplication sharedApplication] statusBarOrientation];
  UIView *view = [MDDeviceHelper getMainView];
  switch (orientation) {
  case UIInterfaceOrientationPortrait:
  case UIInterfaceOrientationPortraitUpsideDown:
  case UIInterfaceOrientationLandscapeLeft:
  case UIInterfaceOrientationLandscapeRight: {
    self.frame =
        CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
  } break;
  case UIInterfaceOrientationUnknown:
    break;
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)btnClick:(id)sender {
  self.hidden = YES;
}

- (void)didSelect {
  if (_delegate &&
      [_delegate respondsToSelector:@selector(timePickerDialog:
                                                 didSelectHour:
                                                     andMinute:)]) {
    if (_pickerClockMode == MDCalendarTimeMode24H) {
      [_delegate timePickerDialog:self
                    didSelectHour:currentHour
                        andMinute:currentMinute];
    } else {
      if ([currentTimeModeStr isEqualToString:@"AM"]) {
        [_delegate timePickerDialog:self
                      didSelectHour:currentHour
                          andMinute:currentMinute];
      } else {
        [_delegate timePickerDialog:self
                      didSelectHour:(currentHour + 12) % 24
                          andMinute:currentMinute];
      }
    }
  }
  self.hidden = YES;
}

- (void)didCancell {
  self.hidden = YES;
}
@end