//
//  MPBadgedIcon.h
//  MapsIndoorsUtilsXamarinIOS
//
//  Created by Daniel Nielsen on 28/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MPBadgedIconConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// Renders a new image with a circular or pill shaped text badge on top of it with given configuration.
@interface MPBadgedIcon : NSObject

/// Renders a new image with a circular or pill shaped text badge on top of it with given configuration.
/// - Parameter config: The configuration to use for the badge.
/// - Returns: The rendered image with a badge.
+ (nullable UIImage*)badgedIconWithConfig:(MPBadgedIconConfiguration*)config NS_SWIFT_NAME(badgedIcon(config:));

@end

NS_ASSUME_NONNULL_END
