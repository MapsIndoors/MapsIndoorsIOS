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

#import <UIKit/UIKit.h>

#define kMDTabBarHeight 48
#define kMDIndicatorHeight 2

@class MDTabBar;

@protocol MDTabBarDelegate <NSObject>
- (void)tabBar:(MDTabBar *)tabBar
    didChangeSelectedIndex:(NSUInteger)selectedIndex;

@end

IB_DESIGNABLE
@interface MDTabBar : UIControl

@property(nonatomic) IBInspectable UIColor *textColor;
@property(nonatomic) IBInspectable UIColor *backgroundColor;
@property(nonatomic) IBInspectable UIColor *indicatorColor;
@property(nonatomic) IBInspectable UIColor *rippleColor;

@property(nonatomic) UIFont *textFont;
@property(nonatomic) NSUInteger selectedIndex;
@property(nonatomic, weak) id<MDTabBarDelegate> delegate;
@property(nonatomic, readonly) NSInteger numberOfItems;

- (void)setItems:(NSArray *)items;

- (void)insertItem:(id)item atIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)removeItemAtIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)replaceItem:(id)item atIndex:(NSUInteger)index;

- (NSMutableArray *)tabs;

- (void)moveIndicatorToFrame:(CGRect)frame withAnimated:(BOOL)animated;

@end
