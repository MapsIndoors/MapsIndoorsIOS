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

#import "MDTextField.h"
#import "AutoResizeTextView.h"
#import "MDConstants.h"
#import "MDSuggestPopupView.h"
#import "AutoResizeTextView.h"
#import "UIColorHelper.h"
#import "UIFontHelper.h"

#define kMDLabelMoveUpAnimationKey @"upAnimation"
#define kMDLabelMoveDownAnimationKey @"downAnimation"
#define kMDLabelAnimationDuration .2f

#define kMDDividerHeight 1
#define kMDFocusedDividerHeight 2

#define kMDZeroPadding 0
#define kMDNormalPadding 8
#define kMDLargePadding 16
#define kMDExtraLargePadding 20

#pragma mark CustomTextField

@interface CustomTextField : UITextField
@property(nonatomic) UIColor *hintColor;
@end

@interface MDTextField ()
@property(nonatomic) AutoResizeTextView *textView;
@property(nonatomic) CustomTextField *textField;
@end

@implementation CustomTextField

- (instancetype)init {
  if (self = [super init]) {
    _hintColor = [UIColorHelper colorWithRGBA:kMDTextFieldHintTextColor];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _hintColor = [UIColorHelper colorWithRGBA:kMDTextFieldHintTextColor];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    _hintColor = [UIColorHelper colorWithRGBA:kMDTextFieldHintTextColor];
  }
  return self;
}

//- (void)setTintColor:(UIColor *)tintColor {
//  [super setTintColor:tintColor];
//
//  if ([self isFirstResponder]) {
//    [self resignFirstResponder];
//    [self becomeFirstResponder];
//  }
//}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
  CGRect caretRect = [super caretRectForPosition:position];
  caretRect.size.width = 1;
  return caretRect;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
  if ([self.placeholder
          respondsToSelector:@selector(drawInRect:
                                   withAttributes:)]) { // iOS7 and later
    NSDictionary *attributes = @{
      NSForegroundColorAttributeName : _hintColor,
      NSFontAttributeName : self.font
    };
    CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size
                                                         options:0
                                                      attributes:attributes
                                                         context:nil];
    [self.placeholder
           drawAtPoint:CGPointMake(0, (rect.size.height / 2) -
                                          boundingRect.size.height / 2)
        withAttributes:attributes];
  } else { // iOS 6
    [_hintColor setFill];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.placeholder drawInRect:rect
                        withFont:self.font
                   lineBreakMode:NSLineBreakByTruncatingTail
                       alignment:self.textAlignment];
#pragma clang diagnostic pop
  }
}

@end

#pragma mark DividerView
@interface DividerView : UIView
@property(nonatomic) BOOL enabled;
@property(nonatomic) UIColor *dividerColor;
@property(nonatomic) int dividerHeight;
@end

@implementation DividerView

- (void)setEnabled:(BOOL)enable {
  _enabled = enable;
  [self updateDividerLine];
}

- (void)setDividerColor:(UIColor *)dividerColor {
  _dividerColor = dividerColor;
  if ([[[self layer] sublayers] objectAtIndex:0]) {
    ((CAShapeLayer *)[[[self layer] sublayers] objectAtIndex:0]).fillColor =
        _dividerColor.CGColor;
  }
}

- (void)setDividerHeight:(int)dividerHeight {
  _dividerHeight = dividerHeight;
  [self updateDividerLine];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self updateDividerLine];
}

- (void)updateDividerLine {
  if (_dividerHeight > 0) {
    if (_enabled) {
      [self drawLineDivider];
    } else {
      [self drawDashedLineDivider];
    }
  }
}

- (void)drawLineDivider {
  if ([[[self layer] sublayers] objectAtIndex:0]) {
    self.layer.sublayers = nil;
  }
  CAShapeLayer *line = [CAShapeLayer layer];
  UIBezierPath *linePath = [UIBezierPath bezierPath];
  [linePath moveToPoint:CGPointMake(0, 0)];
  [linePath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
  [line setPath:linePath.CGPath];
  [line setLineWidth:_dividerHeight];
  [line setFillColor:[[UIColor clearColor] CGColor]];
  [line setStrokeColor:[_dividerColor CGColor]];
  [self.layer addSublayer:line];
}

- (void)drawDashedLineDivider {
  if ([[[self layer] sublayers] objectAtIndex:0]) {
    self.layer.sublayers = nil;
  }
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
  [shapeLayer setStrokeColor:[_dividerColor CGColor]];
  [shapeLayer setLineWidth:_dividerHeight];
  [shapeLayer setLineJoin:kCALineJoinRound];
  [shapeLayer
      setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],
                                                   [NSNumber numberWithInt:3],
                                                   nil]];

  // Setup the path
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, 0, 0);
  CGPathAddLineToPoint(path, NULL, self.bounds.size.width, 0);

  [shapeLayer setPath:path];
  CGPathRelease(path);

  [[self layer] addSublayer:shapeLayer];
}

@end

#pragma mark MDTextField
@interface MDTextField () <UITextFieldDelegate, UITextViewDelegate>
@property UILabel *labelView;
@property UIView *labelPlaceHolder;
@property UILabel *errorView;
@property UILabel *characterCountView;
@property DividerView *dividerHolder;
@end

@implementation MDTextField {
  MDSuggestPopupView *suggestView;
  NSMutableDictionary *viewsDictionary;
  NSArray *constraintsArray;
  BOOL exceedsCharacterLimits;
}
@dynamic enabled;
@synthesize text = _text;
@synthesize secureTextEntry = _secureTextEntry;

- (instancetype)init {
  if (self = [super init])
    [self initContent];
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder])
    [self initContent];
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame])
    [self initContent];
  return self;
}

- (void)initContent {
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
    [self setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];

  self.normalColor = [UIColorHelper colorWithRGBA:kMDTextFieldNormalColor];
  self.disabledColor = [UIColorHelper colorWithRGBA:kMDTextFieldNormalColor];
  self.highlightColor =
      [UIColorHelper colorWithRGBA:kMDTextFieldHighlightColor];
  self.errorColor = [UIColorHelper colorWithRGBA:kMDTextFieldErrorColor];
  self.textColor = [UIColorHelper colorWithRGBA:kMDTextFieldTextColor];
  self.hintColor = [UIColorHelper colorWithRGBA:kMDTextFieldHintTextColor];
  self.labelsFont = [UIFontHelper robotoFontOfSize:12];
  if (_labelsFont == nil) {
    _labelsFont = [UIFont systemFontOfSize:12];
  }
  _inputTextFont = [UIFontHelper robotoFontOfSize:16];
  if (_inputTextFont == nil) {
    _inputTextFont = [UIFont systemFontOfSize:16];
  }

  _labelView =
      [[UILabel alloc] initWithFrame:CGRectMake(0, 16, self.bounds.size.width,
                                                _labelsFont.lineHeight)];
  [_labelView setFont:_labelsFont];
  [_labelView setTextColor:_normalColor];
  [_labelView setNumberOfLines:1];
  [_labelView.layer setAnchorPoint:CGPointMake(0, 0)];

  _labelPlaceHolder =
      [[UIView alloc] initWithFrame:CGRectMake(0, 16, self.bounds.size.width,
                                               _labelsFont.lineHeight)];

  _dividerHolder = [[DividerView alloc]
      initWithFrame:CGRectMake(0, 67, self.bounds.size.width, 2)];
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
    [_dividerHolder setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
  [_dividerHolder setDividerColor:_normalColor];

  _errorView = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 77, self.bounds.size.width, 15)];
  [_errorView setFont:_labelsFont];
  [_errorView setTextColor:_errorColor];
  [_errorView setHidden:YES];

  _characterCountView = [[UILabel alloc]
      initWithFrame:CGRectMake(self.bounds.size.width - 50, 77, 50, 15)];
  [_characterCountView setFont:_labelsFont];
  [_characterCountView setTextColor:_normalColor];
  [_characterCountView setTextAlignment:NSTextAlignmentRight];
  [_characterCountView
      setContentCompressionResistancePriority:UILayoutPriorityRequired
                                      forAxis:UILayoutConstraintAxisHorizontal];

  _textField = [[CustomTextField alloc] init];
  [_textField setTintColor:self.highlightColor];
  [_textField setFont:self.inputTextFont];
  [_textField setDelegate:self];
  [_textField setTextColor:self.textColor];
  [_textField setHintColor:self.hintColor];
  [_textField setHidden:YES];
  [_textField setContentHuggingPriority:UILayoutPriorityDefaultLow
                                forAxis:UILayoutConstraintAxisHorizontal];

  _textView = [[AutoResizeTextView alloc] init];

  [_textView setTintColor:self.highlightColor];
  [_textView setFont:self.inputTextFont];
  [_textView setDelegate:self];
  [_textView setTextColor:self.textColor];
  [_textView setPlaceholderColor:self.hintColor];
  [_textView setHolder:self];

  [_textField addTarget:self
                 action:@selector(updateText:)
       forControlEvents:UIControlEventEditingChanged];

  _labelView.translatesAutoresizingMaskIntoConstraints = NO;
  _labelPlaceHolder.translatesAutoresizingMaskIntoConstraints = NO;
  _textField.translatesAutoresizingMaskIntoConstraints = NO;
  _textView.translatesAutoresizingMaskIntoConstraints = NO;
  _dividerHolder.translatesAutoresizingMaskIntoConstraints = NO;
  _errorView.translatesAutoresizingMaskIntoConstraints = NO;
  _characterCountView.translatesAutoresizingMaskIntoConstraints = NO;
  self.translatesAutoresizingMaskIntoConstraints = NO;

  [self addSubview:_labelPlaceHolder];
  [self addSubview:_dividerHolder];
  [self addSubview:_textField];
  [self addSubview:_textView];
  [_dividerHolder setEnabled:YES];
  [self addSubview:_errorView];
  [self addSubview:_characterCountView];
  [self.layer addSublayer:_labelView.layer];

  viewsDictionary = [@{
    @"labelView" : self.labelView,
    @"labelHolder" : self.labelPlaceHolder,
    @"errorView" : self.errorView,
    @"characterCountView" : self.characterCountView,
    @"dividerHolder" : _dividerHolder,
    @"inputView" : [self getInputView],
    @"textField" : self.textField,
    @"textView" : self.textView,
  } mutableCopy];

  NSArray *textFieldHeightConstraint = [NSLayoutConstraint
      constraintsWithVisualFormat:
          [NSString stringWithFormat:@"V:[textField(%i)]",
                                     (int)ceil(_inputTextFont.lineHeight)]
                          options:0
                          metrics:nil
                            views:viewsDictionary];

  [_textField addConstraints:textFieldHeightConstraint];
  _textViewHeightConstraint = [[NSLayoutConstraint
      constraintsWithVisualFormat:
          [NSString stringWithFormat:@"V:[textView(%i)]",
                                     (int)ceil(_inputTextFont.lineHeight)]
                          options:0
                          metrics:nil
                            views:viewsDictionary] objectAtIndex:0];

  [_textView addConstraint:_textViewHeightConstraint];

  NSArray *constraint_V = [NSLayoutConstraint
      constraintsWithVisualFormat:
          [NSString stringWithFormat:@"V:[labelHolder(%i)]",
                                     (int)ceil(_labelView.font.lineHeight)]
                          options:0
                          metrics:nil
                            views:viewsDictionary];
  [_labelPlaceHolder addConstraints:constraint_V];

  constraint_V = [NSLayoutConstraint
      constraintsWithVisualFormat:[NSString
                                      stringWithFormat:@"V:[dividerHolder(%i)]",
                                                       kMDFocusedDividerHeight]
                          options:0
                          metrics:nil
                            views:viewsDictionary];
  [_dividerHolder addConstraints:constraint_V];

  [_dividerHolder setDividerHeight:kMDDividerHeight];

  NSArray *constraint_H =
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[labelHolder]-0-|"
                                              options:0
                                              metrics:nil
                                                views:viewsDictionary];
  [super addConstraints:constraint_H];

  constraint_H = [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-0-[dividerHolder]-0-|"
                          options:0
                          metrics:nil
                            views:viewsDictionary];
  [super addConstraints:constraint_H];

  [self relayout];
  suggestView = [[MDSuggestPopupView alloc] initWithTextField:self];
  self.maxCharacterCount = 0;
}

- (UIView *)getInputView {
  if (_singleLine) {
    return _textField;
  } else {
    return _textView;
  }
}

- (void)updateText:(id)sender {
  if ([sender isKindOfClass:[CustomTextField class]]) {
    self.text = _textField.text;
  }
}

#pragma mark override from uiview

- (BOOL)canBecomeFirstResponder {
  return [[self getInputView] canBecomeFirstResponder];
}
- (BOOL)becomeFirstResponder {
  return [[self getInputView] becomeFirstResponder];
  //    if (_singleLine) {
  //      return [_textField becomeFirstResponder];
  //    } else {
  //      return [_textView becomeFirstResponder];
  //    }
}
- (BOOL)canResignFirstResponder {
  return [[self getInputView] canResignFirstResponder];
}

- (BOOL)resignFirstResponder {
  UIView *input = [self getInputView];
  if (input.isFirstResponder) {
    return [input resignFirstResponder];
  }

  return YES;
}

- (BOOL)isFirstResponder {
  return [[self getInputView] isFirstResponder];
}
#pragma mark Setters
- (void)setLabel:(NSString *)label {

  if ((!_label.length && label.length) || (_label.length && !label.length)) {
    _label = label;
    [self relayout];
  } else {
    _label = label;
  }

  [_labelView setText:label];
}

- (void)setFloatingLabel:(BOOL)floatingLabel {
  _floatingLabel = floatingLabel;
  if (floatingLabel) {
    [self setPlaceholder:nil];

  } else {
    [self setPlaceholder:_hint];
  }
  [self calculateLabelFrame];
}

- (void)setHint:(NSString *)hint {
  _hint = hint;
  if (!_floatingLabel || _label.length == 0) {
    [self setPlaceholder:hint];
  }
}

- (void)setHighlightLabel:(BOOL)highlightLabel {
  _highlightLabel = highlightLabel;
  [self updateState];
}

- (void)setErrorMessage:(NSString *)errorMessage {
  _errorMessage = errorMessage;
  [_errorView setText:_errorMessage];
  [self relayout];
}

- (void)setHasError:(BOOL)hasError {
  _hasError = hasError;
  [self updateState];
}

- (void)setNormalColor:(UIColor *)normalColor {
  _normalColor = normalColor;
  [self updateState];
}

- (void)setHighlightColor:(UIColor *)highlightColor {
  _highlightColor = highlightColor;
  [self updateState];
}

- (void)setErrorColor:(UIColor *)errorColor {
  _errorColor = errorColor;
  [self updateState];
}

- (void)setTextColor:(UIColor *)textColor {
  _textColor = textColor;
  [_textField setTextColor:textColor];
  [_textView setTextColor:textColor];
}

- (void)setEnabled:(BOOL)enable {
  [super setEnabled:enable];
  _textField.enabled = enable;
  _textView.editable = enable;
  _textView.selectable = enable;
  _dividerHolder.enabled = enable;
  [self updateState];
}

- (void)setHintColor:(UIColor *)hintColor {
  _hintColor = hintColor;
  _textField.hintColor = hintColor;
  _textView.placeholderColor = hintColor;
}

- (void)setSingleLine:(BOOL)singleLine {
  _singleLine = singleLine;
  _textView.hidden = singleLine;
  _textField.hidden = !singleLine;

  [self relayout];
}

- (void)setFullWidth:(BOOL)fullWidth {
  _fullWidth = fullWidth;
  [self relayout];
}

- (void)setMaxVisibleLines:(int)maxVisibleLines {
  _maxVisibleLines = maxVisibleLines;
  [_textView setMaxVisibleLines:maxVisibleLines];
}

- (void)setMinVisibleLines:(int)minVisibleLines {
  _minVisibleLines = minVisibleLines;
  [_textView setMinVisibleLines:minVisibleLines];
}

- (void)setMaxCharacterCount:(int)maxCharacterCount {
  _maxCharacterCount = maxCharacterCount;
  if (_maxCharacterCount > 0) {
    _characterCountView.hidden = NO;

    [self updateTextLength:[self getTextLength]];
  } else {
    _characterCountView.hidden = YES;
  }

  [self relayout];
}

- (void)setSuggestionsDictionary:(NSArray *)suggestionsDictionary {
  _suggestionsDictionary = suggestionsDictionary;
  suggestView.suggestionsDictionary = suggestionsDictionary;
  // Auto change default setting so that suggestView can show
  self.autoComplete = YES;
  self.singleLine = YES;
}

- (void)setText:(NSString *)text {
  _text = text;
  _textField.text = text;
  _textView.text = text;
  [self updateTextLength:text.length];
  if ([_delegate respondsToSelector:@selector(textFieldDidChange:)]) {
    [_delegate textFieldDidChange:self];
  }
  [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (void)setPlaceholder:(NSString *)placeholder {
  _textField.placeholder = placeholder;
  _textView.placeholder = placeholder;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
  _secureTextEntry = secureTextEntry;
  _textField.secureTextEntry = secureTextEntry;
  _textView.secureTextEntry = secureTextEntry;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
  _returnKeyType = returnKeyType;
  _textField.returnKeyType = returnKeyType;
  _textView.returnKeyType = returnKeyType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
  _keyboardType = keyboardType;
  _textField.keyboardType = keyboardType;
  _textView.keyboardType = keyboardType;
}

#pragma mark getters
- (NSString *)text {
  if (_singleLine) {
    return _textField.text;
  } else {
    return _textView.text;
  }
}

#pragma mark Private methods
- (void)relayout {
  if (constraintsArray)
    [self removeConstraints:constraintsArray];

  [viewsDictionary setObject:[self getInputView] forKey:@"inputView"];

  NSMutableArray *constraintsMutableArray = [NSMutableArray array];

  if (_fullWidth) {
    _labelView.hidden = YES;
    NSMutableString *constraintsString = [NSMutableString
        stringWithFormat:@"V:|-%i-[inputView]", kMDExtraLargePadding];
    if (_maxCharacterCount > 0) {
      if (_singleLine) {
        [constraintsString appendFormat:@"-%i-[dividerHolder]-%i-|",
                                        kMDExtraLargePadding, kMDZeroPadding];
        [constraintsMutableArray
            addObjectsFromArray:
                [NSLayoutConstraint
                    constraintsWithVisualFormat:
                        [NSString stringWithFormat:@"V:[characterCountView]-%i-"
                                                   @"[dividerHolder]",
                                                   kMDExtraLargePadding]
                                        options:0
                                        metrics:nil
                                          views:viewsDictionary]];
        [constraintsMutableArray
            addObjectsFromArray:
                [NSLayoutConstraint
                    constraintsWithVisualFormat:
                        [NSString
                            stringWithFormat:@"H:|-%i-[inputView]-%i-["
                                             @"characterCountView(45)]-%i-|",
                                             kMDLargePadding, kMDNormalPadding,
                                             kMDLargePadding]
                                        options:0
                                        metrics:nil
                                          views:viewsDictionary]];
      } else {
        [constraintsString appendFormat:@"-%i-[characterCountView(%i)]-%i-["
                                        @"dividerHolder]-%i-|",
                                        kMDNormalPadding,
                                        (int)ceil(_labelsFont.lineHeight),
                                        kMDExtraLargePadding, kMDZeroPadding];
        [constraintsMutableArray
            addObjectsFromArray:
                [NSLayoutConstraint
                    constraintsWithVisualFormat:
                        [NSString
                            stringWithFormat:@"H:[characterCountView]-%i-|",
                                             kMDLargePadding]
                                        options:0
                                        metrics:nil
                                          views:viewsDictionary]];
        [constraintsMutableArray
            addObjectsFromArray:
                [NSLayoutConstraint
                    constraintsWithVisualFormat:
                        [NSString stringWithFormat:@"H:|-%i-[inputView]-%i-|",
                                                   kMDLargePadding,
                                                   kMDLargePadding]
                                        options:0
                                        metrics:nil
                                          views:viewsDictionary]];
      }

    } else {
      [constraintsString appendFormat:@"-%i-[dividerHolder]-%i-|",
                                      kMDExtraLargePadding, kMDZeroPadding];
      [constraintsMutableArray
          addObjectsFromArray:
              [NSLayoutConstraint
                  constraintsWithVisualFormat:
                      [NSString stringWithFormat:@"H:|-%i-[inputView]-%i-|",
                                                 kMDLargePadding,
                                                 kMDLargePadding]
                                      options:0
                                      metrics:nil
                                        views:viewsDictionary]];
    }

    [constraintsMutableArray
        addObjectsFromArray:[NSLayoutConstraint
                                constraintsWithVisualFormat:constraintsString
                                                    options:0
                                                    metrics:nil
                                                      views:viewsDictionary]];
  } else {
    _labelView.hidden = NO;
    NSMutableString *constraintsString =
        [NSMutableString stringWithFormat:@"V:|-%i-", kMDLargePadding];
    if (_label.length) {
      [constraintsString appendFormat:@"[labelHolder]-%i-", kMDNormalPadding];
    }

    [constraintsString
        appendFormat:@"[inputView]-%i-[dividerHolder]", kMDNormalPadding];

    if (_maxCharacterCount <= 0 && !_errorMessage.length) {
      [constraintsString appendFormat:@"-%i-|", kMDNormalPadding];
    } else {
      if (_errorMessage.length) {
        [constraintsString appendFormat:@"-%i-[errorView]-%i-|",
                                        kMDNormalPadding, kMDNormalPadding];

        [constraintsMutableArray
            addObjectsFromArray:
                [NSLayoutConstraint
                    constraintsWithVisualFormat:
                        [NSString stringWithFormat:@"H:|-%i-[errorView]",
                                                   kMDZeroPadding]
                                        options:0
                                        metrics:nil
                                          views:viewsDictionary]];
      }

      if (_maxCharacterCount > 0) {
        [constraintsMutableArray
            addObjectsFromArray:
                [NSLayoutConstraint
                    constraintsWithVisualFormat:
                        [NSString stringWithFormat:@"V:[dividerHolder]-%i-["
                                                   @"characterCountView]-%i-|",
                                                   kMDNormalPadding,
                                                   kMDNormalPadding]
                                        options:0
                                        metrics:nil
                                          views:viewsDictionary]];

        [constraintsMutableArray
            addObjectsFromArray:
                [NSLayoutConstraint
                    constraintsWithVisualFormat:
                        [NSString stringWithFormat:@"H:[errorView]-5-["
                                                   @"characterCountView]-%i-|",
                                                   kMDZeroPadding]
                                        options:0
                                        metrics:nil
                                          views:viewsDictionary]];
      }
    }

    [constraintsMutableArray
        addObjectsFromArray:[NSLayoutConstraint
                                constraintsWithVisualFormat:constraintsString
                                                    options:0
                                                    metrics:nil
                                                      views:viewsDictionary]];
    [constraintsMutableArray
        addObjectsFromArray:
            [NSLayoutConstraint
                constraintsWithVisualFormat:
                    [NSString stringWithFormat:@"H:|-%i-[inputView]-%i-|",
                                               kMDZeroPadding, kMDZeroPadding]
                                    options:0
                                    metrics:nil
                                      views:viewsDictionary]];
  }

  constraintsArray = constraintsMutableArray;

  [self addConstraints:constraintsArray];
  [self calculateLabelFrame];
}

- (void)updateState {
  if (self.enabled) {
    if (_hasError || exceedsCharacterLimits) {
      [self setViewState:ERROR];
      if (!_fullWidth) {
        [[self getInputView] setTintColor:_errorColor];
      }
      if (_hasError)
        _errorView.hidden = NO;
    } else {
      [[self getInputView] setTintColor:_highlightColor];
      if ([[self getInputView] isFirstResponder]) {
        [self setViewState:HIGHLIGHT];
      } else {
        [self setViewState:NORMAL];
      }
      _errorView.hidden = YES;
    }
  } else {
    [self setViewState:DISABLED];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self calculateLabelFrame];
}

- (void)calculateLabelFrame {
  if (!_floatingLabel || [self getTextLength] > 0 ||
      [self getInputView].isFirstResponder) {
    CGRect frame = _labelPlaceHolder.frame;
    [_labelView
        setFrame:CGRectMake(frame.origin.x, frame.origin.y,
                            self.bounds.size.width, _labelsFont.lineHeight)];
    [_labelView setFont:_labelsFont];
  } else {
    CGRect frame = [self getInputView].frame;
    [_labelView
        setFrame:CGRectMake(frame.origin.x, frame.origin.y,
                            self.bounds.size.width, _inputTextFont.lineHeight)];
    [_labelView setFont:_inputTextFont];
  }
}

- (void)updateTextLength:(NSUInteger)textLength {
  if (self.enabled) {
    [_characterCountView
        setText:[NSString stringWithFormat:@"%lu / %i",
                                           (unsigned long)textLength,
                                           _maxCharacterCount]];
    if (_maxCharacterCount > 0 && textLength > _maxCharacterCount) {
      exceedsCharacterLimits = YES;
      [self setViewState:ERROR];
      [_characterCountView setTextColor:_errorColor];
    } else {
      exceedsCharacterLimits = NO;
      if (!_hasError) {
        if ([self getInputView].isFirstResponder)
          [self setViewState:HIGHLIGHT];
        else
          [self setViewState:NORMAL];
      }

      [_characterCountView setTextColor:_normalColor];
    }
  }
}

- (void)setViewState:(enum ViewState)state {
  switch (state) {
  case NORMAL:
    if (!_fullWidth) {
      [_dividerHolder setDividerColor:_normalColor];
      [_dividerHolder setDividerHeight:kMDDividerHeight];
    }
    [_labelView setTextColor:_normalColor];
    [self updateTextColor:_textColor];
    break;
  case HIGHLIGHT:
    if (!_fullWidth) {
      [_dividerHolder setDividerHeight:kMDFocusedDividerHeight];
      [_dividerHolder setDividerColor:_highlightColor];
    }
    if (_highlightLabel) {
      [_labelView setTextColor:_highlightColor];
    }
    [self updateTextColor:_textColor];
    break;
  case ERROR:
    if (!_fullWidth) {
      [_dividerHolder setDividerHeight:kMDFocusedDividerHeight];
      [_dividerHolder setDividerColor:_errorColor];
    }
    if (_highlightLabel) {
      [_labelView setTextColor:_errorColor];
    }
    [self updateTextColor:_textColor];
    break;
  case DISABLED:
    [_dividerHolder setDividerHeight:kMDDividerHeight];
    [_dividerHolder setDividerColor:_normalColor];
    [self updateTextColor:_disabledColor];
    break;

  default:
    break;
  }
}

- (void)updateTextColor:(UIColor *)color {
  _textField.textColor = color;
  _textView.textColor = color;
}

- (void)inputTextDidBeginEditing:(NSUInteger)textLength {
  if (_hasError)
    [self setViewState:ERROR];
  else if (_maxCharacterCount > 0 && textLength > _maxCharacterCount) {
    [self setViewState:ERROR];
    [_characterCountView setTextColor:_errorColor];
  } else
    [self setViewState:HIGHLIGHT];

  if (_floatingLabel && (textLength == 0) && !_fullWidth) {
    CABasicAnimation *scaleAnim =
        [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim.toValue = [NSNumber
        numberWithFloat:_labelsFont.lineHeight / _inputTextFont.lineHeight];

    CABasicAnimation *moveAnim =
        [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnim.fromValue =
        [NSValue valueWithCGPoint:[self getInputView].frame.origin];
    moveAnim.toValue =
        [NSValue valueWithCGPoint:_labelPlaceHolder.frame.origin];

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = kMDLabelAnimationDuration;
    groupAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [groupAnimation setValue:kMDLabelMoveUpAnimationKey forKey:@"id"];
    groupAnimation.removedOnCompletion = false;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.animations =
        [NSArray arrayWithObjects:scaleAnim, moveAnim, nil];

    groupAnimation.delegate = self;

    [_labelView.layer addAnimation:groupAnimation forKey:nil];
  }
}

- (void)inputTextDidEndEditing:(NSUInteger)textLength {
  if (_hasError)
    [self setViewState:ERROR];
  else
    [self setViewState:NORMAL];

  if (_floatingLabel && (textLength == 0) && !_fullWidth) {
    CABasicAnimation *scaleAnim =
        [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim.toValue = [NSNumber
        numberWithFloat:_inputTextFont.lineHeight / _labelsFont.lineHeight];

    CABasicAnimation *moveAnim =
        [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnim.fromValue =
        [NSValue valueWithCGPoint:_labelPlaceHolder.frame.origin];
    moveAnim.toValue =
        [NSValue valueWithCGPoint:[self getInputView].frame.origin];

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = kMDLabelAnimationDuration;
    groupAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [groupAnimation setValue:kMDLabelMoveDownAnimationKey forKey:@"id"];
    groupAnimation.removedOnCompletion = false;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.animations =
        [NSArray arrayWithObjects:scaleAnim, moveAnim, nil];

    groupAnimation.delegate = self;
    [_labelView.layer addAnimation:groupAnimation forKey:nil];
  }
}

- (CGRect)getInputViewFrameOnWindow {
  return [self convertRect:[self getInputView].frame toView:nil];
}

#pragma mark CAAnimationDelegate implement
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if ([[anim valueForKey:@"id"] isEqualToString:kMDLabelMoveUpAnimationKey]) {
    [_labelView setFont:_labelsFont];
    _labelView.layer.frame = _labelPlaceHolder.frame;
  } else if ([[anim valueForKey:@"id"]
                 isEqualToString:kMDLabelMoveDownAnimationKey]) {
    [_labelView setFont:_inputTextFont];
    CGRect frame = [self getInputView].frame;
    _labelView.layer.frame =
        CGRectMake(frame.origin.x, frame.origin.y, self.bounds.size.width,
                   _inputTextFont.lineHeight);
  }

  [_labelView.layer removeAllAnimations];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  if ([_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
    return [_delegate textFieldShouldBeginEditing:self];
  }
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self inputTextDidBeginEditing:_textField.text.length];
  if ([_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
    [_delegate textFieldDidBeginEditing:self];
  }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  if ([_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
    return [_delegate textFieldShouldEndEditing:self];
  }
  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [self inputTextDidEndEditing:_textField.text.length];
  if ([_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
    [_delegate textFieldDidEndEditing:self];
  }
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  BOOL shouldChange = YES;
  if ([_delegate respondsToSelector:@selector(textField:
                                        shouldChangeCharactersInRange:
                                                    replacementString:)]) {
    shouldChange = [_delegate textField:self
          shouldChangeCharactersInRange:range
                      replacementString:string];
  }
  if (shouldChange) {
    NSString *newText =
        [_textField.text stringByReplacingCharactersInRange:range
                                                 withString:string];
    [suggestView textView:self didChangeText:newText];
  }
  return shouldChange;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  BOOL shouldReturn = YES;
  if ([_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
    shouldReturn = [_delegate textFieldShouldReturn:self];
  }
  //  if (shouldReturn)
  //    [textField resignFirstResponder];
  return shouldReturn;
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  if ([_delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
    return [_delegate textFieldShouldBeginEditing:self];
  }
  return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
  [self inputTextDidBeginEditing:textView.text.length];
  if ([_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
    [_delegate textFieldDidBeginEditing:self];
  }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  if ([_delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
    return [_delegate textFieldShouldEndEditing:self];
  }
  return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
  [self inputTextDidEndEditing:textView.text.length];
  if ([_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
    [_delegate textFieldDidEndEditing:self];
  }
}
- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  if ([_delegate respondsToSelector:@selector(textField:
                                        shouldChangeCharactersInRange:
                                                    replacementString:)]) {
    return [_delegate textField:self
        shouldChangeCharactersInRange:range
                    replacementString:text];
  }
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  self.text = textView.text;
}

#pragma mark BaseTextInput methods
- (NSUInteger)getTextLength {
  return _textField.text.length;
}

@end
