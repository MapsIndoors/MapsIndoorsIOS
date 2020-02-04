//
//  AppVariantData.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 19/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppVariantData : NSObject

@property (nonatomic, readonly, strong) NSDictionary*   dict;       // Raw dict when direct access is needed (none of the readymade accessors below will do).

// Base data:
@property (nonatomic, readonly, strong) NSString*       googleAPIKey;
@property (nonatomic, readonly, strong) NSString*       mapsIndoorsAPIKey;
@property (nonatomic, readonly, strong) NSString*       appProviderName;
@property (nonatomic, readonly, strong) NSString*       appProviderUrl;
@property (nonatomic, readonly, strong) NSString*       appSupplierName;
@property (nonatomic, readonly, strong) NSString*       appSupplierUrl;
@property (nonatomic, readonly, strong) NSString*       googleMapsStyle;
@property (nonatomic, readonly, strong) NSString*       welcomeMessage;
@property (nonatomic, readonly, strong) NSString*       imageNameForBlueDot;
@property (nonatomic, readonly, strong) NSString*       imageNameForBlueDotWithHeading;

// Theming:
@property (nonatomic, readonly, strong) UIColor*        primaryColor;
@property (nonatomic, readonly, strong) UIColor*        darkPrimaryColor;
@property (nonatomic, readonly, strong) UIColor*        lightPrimaryColor;
@property (nonatomic, readonly, strong) UIColor*        launchScreenColor;
@property (nonatomic, readonly, strong) UIColor*        accentColor;
@property (nonatomic, readonly, strong) UIColor*        statusBarColor;
@property (nonatomic, readonly, strong) UIColor*        tertiaryHighlightColor;
@property (nonatomic, readonly, strong) Class           customFloorSelectorClass;

// Behaviours:
@property (nonatomic, readonly) BOOL                    shouldPreloadRouteOriginWithCurrentLocation;
@property (nonatomic, readonly) NSNotificationName      logoutNotificationName;
@property (nonatomic, readonly) BOOL                    mapShouldTrackUserLocationOnAppLaunch;

// Methods:
+ (instancetype) sharedAppVariantData;

@end
