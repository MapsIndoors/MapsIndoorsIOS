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

#ifndef iOSUILib_MDTimerPickerDialog_h
#define iOSUILib_MDTimerPickerDialog_h

#import <UIKit/UIKit.h>

@class MDTimePickerDialog;

typedef NS_OPTIONS(NSInteger, MDCalendarTimeMode) {
  MDCalendarTimeMode12H,
  MDCalendarTimeMode24H
};

@protocol MDCalendarTimePickerDialogDelegate <NSObject>

- (void)timePickerDialog:(MDTimePickerDialog *)timePickerDialog
           didSelectHour:(NSInteger)hour
               andMinute:(NSInteger)minute;

@end

@class MDButton;
@interface MDTimePickerDialog : UIButton <UIGestureRecognizerDelegate>

@property(nonatomic) id<MDCalendarTimePickerDialogDelegate> delegate;

@property(nonatomic) MDCalendarTimeMode timeMode;

@property(nonatomic) UIView *header;
@property(nonatomic) UILabel *headerLabelHour;
@property(nonatomic) UILabel *headerLabelMinute;
@property(nonatomic) UILabel *headerLabelTimeMode;

@property(nonatomic) MDButton *buttonOk;
@property(nonatomic) MDButton *buttonCancel;
@property(nonatomic) UIFont *buttonFont;

- (instancetype)initWithHour:(NSInteger)hour andWithMinute:(NSInteger)minute;
- (void)show;

@end
#endif
