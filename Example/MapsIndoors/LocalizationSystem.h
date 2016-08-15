

#import <Foundation/Foundation.h>

#define MPLocalizedString(key, comment) \
[[LocalizationSystem sharedLocalSystem] localizedStringForKey:(key) value:(comment)]

#define LocalizationSetLanguage(language) \
[[LocalizationSystem sharedLocalSystem] setLanguage:(language)]

#define LocalizationGetLanguage \
[[LocalizationSystem sharedLocalSystem] getLanguage]

#define LocalizationReset \
[[LocalizationSystem sharedLocalSystem] resetLocalization]

@interface LocalizationSystem : NSObject {
	NSString *language;
}

// you really shouldn't care about this functions and use the MACROS
+ (LocalizationSystem *)sharedLocalSystem;

//gets the string localized
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment;

//sets the language
- (void) setLanguage:(NSString*) language;

//gets the current language
- (NSString*) getLanguage;

//resets this system.
- (void) resetLocalization;

@end
