//
//  NSString+FontAwesome.h
//
//  Copyright (c) 2012 Alex Usbergo. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//

#import <Foundation/Foundation.h>
#import "UIFont+CustomFont.h"

static NSString * _Nonnull const kCustomFontFamilyName = @"icomoon";

/**
 @abstract CustomIcon Icons.
 */
typedef NS_ENUM(NSInteger, CustomFontIcon) {
    bicycle,
    car,
    hospital,
    mansilhouette,
    vehicle,
    wheelchair,
    home,
    _clock,
    playO2,
    tag,
    tags,
    bookmark,
    image,
    airplane,
    levels,
    truck,
    mail,
    building,
    navigation,
    university,
    bus,
    motorbike,
    train,
    play,
    film,
    playO,
    compass
};



@interface NSString (CustomFont)

/**
 @abstract Returns the correct enum for a font-awesome icon.
 @discussion The list of identifiers can be found here: http://fortawesome.github.com/Font-Awesome/#all-icons 
 */
+ (CustomFontIcon)customEnumForIconIdentifier:(nonnull NSString*)string;

/**
 @abstract Returns the font-awesome character associated to the icon enum passed as argument 
 */
+ (nullable NSString*)customIconStringForEnum:(CustomFontIcon)value;

/* 
 @abstract Returns the font-awesome character associated to the font-awesome identifier.
 @discussion The list of identifiers can be found here: http://fortawesome.github.com/Font-Awesome/#all-icons
 */
+ (nullable NSString*)customIconStringForIconIdentifier:(nonnull NSString*)identifier;

@end
