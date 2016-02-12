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

#import "MDButton.h"
#import "MDRippleLayer.h"
#import "MDConstants.h"
#import "UIColorHelper.h"

@interface MDButton ()

@property MDRippleLayer *mdLayer;

@end

@implementation MDButton
@dynamic enabled;

- (instancetype)init {
  if (self = [super init])
    [self initLayer];
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder])
    [self initLayer];
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame])
    [self initLayer];
  return self;
}

- (id)initWithFrame:(CGRect)frame
               type:(enum MDButtonType)buttonType
        rippleColor:(UIColor *)rippleColor {
  if (self = [super initWithFrame:frame]) {
    [self initLayer];
    self.mdButtonType = buttonType;
    if (rippleColor)
      self.rippleColor = rippleColor;
  }
  return self;
}

- (void)initLayer {
  _rippleColor = [UIColor colorWithWhite:0.5 alpha:1];
  if (self.backgroundColor == nil) {
    self.backgroundColor =
        [UIColorHelper colorWithRGBA:kMDButtonBackgroundColor];
  }
  self.layer.cornerRadius = 2.5;
  _mdLayer = [[MDRippleLayer alloc] initWithSuperView:self];
  _mdLayer.effectColor = _rippleColor;
  _mdLayer.rippleScaleRatio = 1;
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

#pragma mark setters
- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
}

- (void)setRippleColor:(UIColor *)rippleColor {
  _rippleColor = rippleColor;
  _mdLayer.effectColor = _rippleColor;
}

- (void)setType:(int)type {
  switch (type) {
  case 1:
    [self setMdButtonType:Flat];
    break;
  case 2:
    [self setMdButtonType:FloatingAction];
    break;
  default:
    [self setMdButtonType:Raised];
  }
}

- (void)setMdButtonType:(enum MDButtonType)mdButtonType {
  _mdButtonType = mdButtonType;
  [self setupButtonType];
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  [self setupButtonType];
}

#pragma mark private methods
- (void)setupButtonType {
  if (self.enabled) {
    switch (_mdButtonType) {
    case Raised:
      _mdLayer.enableElevation = true;
      _mdLayer.restingElevation = 2;
      break;
    case Flat:
      _mdLayer.enableElevation = false;
      self.backgroundColor = [UIColor clearColor];
      break;
    case FloatingAction: {
      float size = MIN(self.bounds.size.width, self.bounds.size.height);
      self.layer.cornerRadius = size / 2;

      _mdLayer.restingElevation = 6;
      _mdLayer.enableElevation = true;
    }
    }
  } else {
    _mdLayer.enableElevation = false;
  }
}

@end
