//
//  MPBadgedIconConfiguration.h
//  MapsIndoorsUtilsXamarinIOS
//
//  Created by Daniel Nielsen on 28/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MPBagdePosition : NSObject
/// Static getter a top right position value.
@property (class, nonatomic, strong, readonly) MPBagdePosition* topRight;
/// Static getter a top left position value.
@property (class, nonatomic, strong, readonly) MPBagdePosition* topLeft;
/// Static getter a bottom right position value.
@property (class, nonatomic, strong, readonly) MPBagdePosition* bottomRight;
/// Static getter a bottom left position value.
@property (class, nonatomic, strong, readonly) MPBagdePosition* bottomLeft;

@property (nonatomic, readonly) CGPoint point;

- (instancetype) initWithX:(CGFloat)x y:(CGFloat)y;

@end


@interface MPBadgedIconConfiguration : NSObject

/// The source icon image.
@property (nonatomic, strong, readonly) UIImage* originalIcon;
/// The badge text that should be rendered inside the badge.
@property (nonatomic, strong, readonly) NSString* badgeText;
/// Set the badge text color.
@property (nonatomic, strong) UIColor* badgeTextColor;
/// Set the padding between the badge text and the edge of the badge. Default is 2 points.
@property (nonatomic) CGFloat badgePadding;
/// Set the background color for the badge. Default is DarkGray.
@property (nonatomic, strong) UIColor* badgeBackgroundColor;
/// Set the font that should be used when rendering the badge text. Default is system font with size 16.
@property (nonatomic, strong) UIFont* badgeFont;
/// Set the position of the badge. Default is top right.
@property (nonatomic, strong) MPBagdePosition* bagdePosition;

- (instancetype) initWithOriginalIcon:(UIImage*)originalIcon badgeText:(NSString*)badgeText;

@end

NS_ASSUME_NONNULL_END
