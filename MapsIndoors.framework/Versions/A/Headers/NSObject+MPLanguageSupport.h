//
//  NSObject+MPLanguageSupport.h
//  MapsIndoorsSDK
//
//  Created by Michael Bech Hansen on 22/05/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSNotificationName _Nonnull kNotificationMapsIndoorsLanguageChanged;


@interface NSObject (MPLanguageSupport)

- (void) mi_setLanguage:(nonnull NSString*)languageCode;
- (nullable NSString*) mi_getLanguage;

- (void) mi_setDefaultLanguage:(nonnull NSString*)languageCode;
- (nullable NSString*) mi_getDefaultLanguage;

- (void) mi_setAvailableLanguages:(nonnull NSArray<NSString*>*)languageCodes;
- (nullable NSArray<NSString*>*) mi_getAvailableLanguages;

- (BOOL) mi_isLanguageAvailable:(nonnull NSString*)languageCode;
- (void) mi_switchToDefaultLanguage;

@end
