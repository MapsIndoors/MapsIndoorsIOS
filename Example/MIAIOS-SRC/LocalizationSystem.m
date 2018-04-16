//
//  LocalizationSystem.m
//  Battle of Puppets
//
//  Created by Juan Albero Sanchis on 27/02/10.
//  Copyright Aggressive Mediocrity 2010. All rights reserved.
//

#import "LocalizationSystem.h"
#import <MapsIndoors/MapsIndoors.h>

@implementation LocalizationSystem

//Singleton inst
static LocalizationSystem *_sharedLocalSystem = nil;

//Current application bungle to get the languages.
static NSBundle *bundle = nil;

+ (LocalizationSystem *)sharedLocalSystem
{
	@synchronized([LocalizationSystem class])
	{
		if (!_sharedLocalSystem){
			_sharedLocalSystem = [[self alloc] init];
		}
		return _sharedLocalSystem;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([LocalizationSystem class])
	{
		NSAssert(_sharedLocalSystem == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedLocalSystem = [super alloc];
		return _sharedLocalSystem;
	}
	// to avoid compiler warning
	return nil;
}


- (id)init
{
    if ((self = [super init])) 
    {
		//empty.
		bundle = [NSBundle mainBundle];
	}
    return self;
}

// Gets the current localized string as in AMLocalizedString.
//
// example calls:
// AMLocalizedString(@"Text to localize",@"Alternative text, in case hte other is not find");
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment
{
	return [bundle localizedStringForKey:key value:comment table:nil];
}


// Sets the desired language of the ones you have.
// example calls:
// LocalizationSetLanguage(@"Italian");
// LocalizationSetLanguage(@"German");
// LocalizationSetLanguage(@"Spanish");
// 
// If this function is not called it will use the default OS language.
// If the language does not exists y returns the default OS language.
- (void) setLanguage:(NSString*) l{
	NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
	
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:l, nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [MapsIndoors setLanguage:l];

	if (path == nil)
		//in case the language does not exists
		[self resetLocalization];
	else
		bundle = [NSBundle bundleWithPath:path];
}

// Just gets the current setted up language.
// returns "es","fr",...
//
// example call:
// NSString * currentL = LocalizationGetLanguage;
- (NSString*) getLanguage{

	NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];

	NSString *preferredLang = [languages objectAtIndex:0];

    NSArray* langComponents = [preferredLang componentsSeparatedByString:@"-"];
    
	return [langComponents objectAtIndex:0];
}

// Resets the localization system, so it uses the OS default language.
//
// example call:
// LocalizationReset;
- (void) resetLocalization
{
	bundle = [NSBundle mainBundle];
}


@end
