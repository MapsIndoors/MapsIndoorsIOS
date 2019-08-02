//
//  AppVariantData.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 19/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "AppVariantData.h"
#import "UIColor+AppColor.h"


@interface AppVariantData ()

@property (nonatomic, readwrite, strong) NSDictionary*      dict;

@end


@implementation AppVariantData

+ (instancetype) sharedAppVariantData {
    
    static AppVariantData* _sharedAppVariantData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAppVariantData = [AppVariantData new];
    });
    
    return _sharedAppVariantData;
}

- (NSDictionary*) dict {
    
    if ( _dict == nil ) {
        NSString*   path = [[NSBundle mainBundle] pathForResource:@"mapsindoors" ofType:@"plist"];
        _dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    
    return _dict;
}


#pragma mark - Readymade accessors:

- (NSString*) googleAPIKey          { return self.dict[ @"GoogleAPIKey"     ]; }
- (NSString*) mapsIndoorsAPIKey     { return self.dict[ @"MapsIndoorsAPIKey" ]; }
- (NSString*) appProviderName       { return self.dict[ @"AppProviderName"  ]; }
- (NSString*) appProviderUrl        { return self.dict[ @"AppProviderUrl"   ]; }
- (NSString*) appSupplierName       { return self.dict[ @"AppSupplierName"  ]; }
- (NSString*) appSupplierUrl        { return self.dict[ @"AppSupplierUrl"   ]; }
- (NSString*) googleMapsStyle       { return self.dict[ @"GoogleMapsStyle"  ]; }
- (NSString*) welcomeMessage        { return self.dict[ @"WelcomeMessage"   ]; }

- (UIColor*) primaryColor           { return [UIColor colorFromRGBA: self.dict[ @"PrimaryColor"           ] ]; }
- (UIColor*) darkPrimaryColor       { return [UIColor colorFromRGBA: self.dict[ @"DarkPrimaryColor"       ] ]; }
- (UIColor*) lightPrimaryColor      { return [UIColor colorFromRGBA: self.dict[ @"LightPrimaryColor"      ] ]; }
- (UIColor*) launchScreenColor      { return [UIColor colorFromRGBA: self.dict[ @"LaunchScreenColor"      ] ]; }
- (UIColor*) accentColor            { return [UIColor colorFromRGBA: self.dict[ @"AccentColor"            ] ]; }
- (UIColor*) statusBarColor         { return [UIColor colorFromRGBA: self.dict[ @"StatusBarColor"         ] ]; }
- (UIColor*) tertiaryHighlightColor { return [UIColor colorFromRGBA: self.dict[ @"TertiaryHighlightColor" ] ]; }

- (BOOL) shouldPreloadRouteOriginWithCurrentLocation {

    BOOL    shouldPreloadRouteOrigin = YES;
    id      shouldPreloadRouteOriginSetting = self.dict[ @"shouldPreloadRouteOriginWithCurrentLocation" ];

    if ( shouldPreloadRouteOriginSetting ) {
        shouldPreloadRouteOrigin = [shouldPreloadRouteOriginSetting boolValue];
    }

    return shouldPreloadRouteOrigin;
}

- (NSNotificationName) logoutNotificationName   { return self.dict[ @"logoutNotificationName" ]; }

@end
