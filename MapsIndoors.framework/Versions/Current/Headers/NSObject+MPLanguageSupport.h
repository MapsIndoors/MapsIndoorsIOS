//
//  NSObject+MPLanguageSupport.h
//  MapsIndoorsSDK
//
//  Created by Michael Bech Hansen on 22/05/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSNotificationName kNotificationMapsIndoorsLanguageChanged;


@interface NSObject (MPLanguageSupport)

- (void) mi_setLanguage:(NSString*)languageCode;
- (NSString*) mi_getLanguage;

- (void) mi_setDefaultLanguage:(NSString*)languageCode;
- (NSString*) mi_getDefaultLanguage;

- (void) mi_setAvailableLanguages:(NSArray<NSString*>*)languageCodes;
- (NSArray<NSString*>*) mi_getAvailableLanguages;

- (BOOL) mi_isLanguageAvailable:(NSString*)languageCode;
- (void) mi_switchToDefaultLanguage;

@end
