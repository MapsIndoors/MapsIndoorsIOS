#import "LocalizationSystem.h"

#define kLangLang                           MPLocalizedString(@"Language", @"")
#define kLangLevel                          MPLocalizedString(@"Level", @"")
#define kLangLevelVar                       MPLocalizedString(@"Level %@", @"")
#define kLangGetDirections                  MPLocalizedString(@"Get directions", @"")
#define kLangChooseDestination              MPLocalizedString(@"Choose destination", @"")
#define kLangChooseOrigin                   MPLocalizedString(@"Choose starting point", @"")
#define kLangCategories                     MPLocalizedString(@"Categories", @"")
#define kLangSearch                         MPLocalizedString(@"Search", @"")
#define kLangSearchVar                      MPLocalizedString(@"Search %@", @"")
#define kLangShowOnMap                      MPLocalizedString(@"Show on map", @"")

#define kLangMinutes                        MPLocalizedString(@"%d min", @"")
#define kLangHours                          MPLocalizedString(@"%d h", @"")
#define kLangHoursMinutes                   MPLocalizedString(@"%d h %d min walk", @"")
#define kLangDays                           MPLocalizedString(@"%d d", @"")
#define kLangDaysHours                      MPLocalizedString(@"%d d %d h",@"")
#define kLangDaysHoursMinutes               MPLocalizedString(@"%d d %d h %d min",@"")

#define kLangByWalk                         MPLocalizedString(@"walk", @"")
#define kLangByCar                          MPLocalizedString(@"by car", @"")
#define kLangByCycling                      MPLocalizedString(@"by bike", @"")
#define kLangByTransit                      MPLocalizedString(@"by transit", @"")
#define kLangExit                           MPLocalizedString(@"Enter", @"")
#define kLangEnter                          MPLocalizedString(@"Exit", @"")


#define kLangEstimatedPosNearVar            MPLocalizedString(@"Estimated: %@", @"")
#define kLangFromPosVar                     MPLocalizedString(@"From %@", @"")
#define kLangNext                           MPLocalizedString(@"Next", @"")
#define kLangPrev                           MPLocalizedString(@"Previous", @"")
#define kLangMyPosition                     MPLocalizedString(@"My position", @"")
#define kLangSearchingForVar                MPLocalizedString(@"Searching for '%@'", @"")
#define kLangSelectVenue                    MPLocalizedString(@"Select Venue", @"")
#define kLangSearchResult                   MPLocalizedString(@"Search Result", @"")
#define kLangAvoidStairs                    MPLocalizedString(@"Avoid stairs", @"")
#define kLangCouldNotFindLocations          MPLocalizedString(@"Sorry, failed to get locations...", @"")
#define kLangCouldNotFindContent            MPLocalizedString(@"Sorry, failed to get app content...", @"")
#define kLangCouldNotFindLocationDetails    MPLocalizedString(@"Sorry, failed to get location details...", @"")
#define kLangCouldNotFindDirections         MPLocalizedString(@"Sorry, failed to get directions...", @"")
#define kLangFeedback                       MPLocalizedString(@"Got feedback?", @"")
#define kLangFeedbackSendEmail              MPLocalizedString(@"Send us an email", @"")
#define kLangPleaseEnableWIFI               MPLocalizedString(@"Please enable WIFI", @"")
#define kLangEnableWIFIToGetPositioning     MPLocalizedString(@"In order to determine your position WIFI must be enabled and the phone must be connected to the Wifi network", @"")

#define kLangSplashWelcome                  MPLocalizedString(@"Welcome to the map service of MapsPeople", @"")
#define kLangSplashLoading                  MPLocalizedString(@"Buildings and rooms are being loaded", @"")

#define kLangSearchNoMatch                  MPLocalizedString(@"No matches for \"%@\"", @"" )
#define kLangSearchNoLocations              MPLocalizedString(@"No locations to show", @"" )
#define kLangUseSearchToSearchFormat        MPLocalizedString(@"Use the search to search across\n%@", @"" )
#define kLangSearchLocationsIndoorsAndOutdoors  MPLocalizedString(@"Search for locations indoors and outdoors", @"" )

#define kLangNoRouteFound                   MPLocalizedString(@"No route found", @"" )

#define kLangCancel                         MPLocalizedString(@"Cancel",@"")

#define kLangReturnToVenue                  MPLocalizedString(@"RETURN TO VENUE",@"")
#define kLangZoomForMoreDetails             MPLocalizedString(@"Zoom for more details",@"")

// Location services alerts
#define kLangLocationServicesDisabled       MPLocalizedString(@"Location Services are disabled",@"")
#define kLangTurnOnLocationServices         MPLocalizedString(@"Please turn on your phone's location services from privacy settings for us to determine your location.",@"")
#define kLangTurnOnLocationServicesForApp   MPLocalizedString(@"Please turn on location services for %@ to determine your location.",@"")
#define kLangTurnOn                         MPLocalizedString(@"Turn On",@"")
#define kLangSettings                       MPLocalizedString(@"Settings",@"")

#define kLangClearMap                       MPLocalizedString(@"  Clear Map  ", @"")

#define kLangFind                           MPLocalizedString(@"Find", @"")

// Offline UI
#define kLangNoInternetUnableToUpdateMap    MPLocalizedString(@"No Internet, unable to update map",@"")
#define kLangOfflineTryToReconnect          MPLocalizedString(@"NO INTERNET - TRY TO RECONNECT",@"")
#define kLangInitOfflineWithDataAvailable   MPLocalizedString( @"No Internet - Previously loaded content available", @"" )
#define kLangInitOfflineDataUnavailable     MPLocalizedString( @"No Internet - Failed to get app content", @"" )
#define kLangNoInternet                     MPLocalizedString( @"No Internet", @"" )
#define kLangNoInternetMessage              MPLocalizedString( @"kLangNoInternetMessage", @"" )
#define kLangNoInternetNoGoogleResults      MPLocalizedString( @"No Internet - No Google results", @"" )

// Transit sources
#define kLangWebsite                        MPLocalizedString( @"Website", @"" )
#define kLangPhone                          MPLocalizedString( @"Phone", @"" )
#define kLangOpenInSafariQ                  MPLocalizedString( @"Open in Safari ?", @"" )
#define kLangOpen                           MPLocalizedString( @"Open", @"" )
#define kLangPhoneNumberCopiedToClipboard   MPLocalizedString( @"Phone number copied to clipboard", @"" )

// Directions
#define kLangTransitStopsFmt                MPLocalizedString( @"%d stops (%@)", @"" )
