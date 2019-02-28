//
//  MPMapsIndoors.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 04/11/2016.
//  Copyright (c) 2016-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDefines.h"


@protocol MPImageProvider;
@protocol MPPositionProvider;
@protocol MPLocationsProvider;
@protocol MPLocationSource;


/**
 Content synchronisation callback handler block

 @param error Error object.
 */
typedef void(^mpSyncContentHandlerBlockType)(NSError* error);

/**
 Offline content availability callback handler block

 @param error Error object.
 */
typedef void(^mpOfflineDataHandlerBlockType)(NSError* error);


#define kMPNotificationPositionProviderReassign         @"MP_POSITION_PROVIDER_REASSIGNED"
#define kMPNotificationApiKeyInvalid                    @"MAPSINDOORS_API_KEY_INVALID"
#define kMPNotificationMarkerOverlapResolutionUpdate    @"MP_MARKER_OVERLAP_RESOLUTION_UPDATE"
#define kMPNotificationAppDataValueKey                  @"kMPNotificationAppDataValueKey"
#define kMPNotificationAppDataErrorKey                  @"kMPNotificationAppDataErrorKey"


/**
 Main class for initialisation, configuration and content synchronisation.
 */
@interface MapsIndoors : NSObject

/**
 Provides your API key and content key to the MapsIndoors SDK. These keys are unique for your MapsIndoors solution and are used to identify and authorise use of the data provided by MapsIndoors.

 @param mapsIndoorsAPIKey The MapsIndoors API key
 @param googleAPIKey The Google API key.
 @return Whether the API key and content key was successfully provided
 */
+ (BOOL) provideAPIKey:(NSString*)mapsIndoorsAPIKey googleAPIKey:(NSString*)googleAPIKey;

/**
 Gets the current MapsIndoors API key.
 @return The MapsIndoors API key as a string value.
 */
+ (NSString*) getMapsIndoorsAPIKey;
/**
 Gets the current Google API key.
 @return The Google API key as a string value.
 */
+ (NSString*) getGoogleAPIKey;

/**
 Sets the language for the content provided by MapsIndoors.
 @param languageCode The language for which the content should be fetched. Uses the two-letter language code ISO 639-1.
 */
+ (void) setLanguage:(NSString*)languageCode;

/**
 Gets the current language for the content provided by MapsIndoors.
   @returns The language for which the content should be fetched. Uses the two-letter language code ISO 639-1.
 */
+ (NSString*) getLanguage;

/**
 Fetch all neccesary content to be able to run MapsIndoors in offline environments
 @param  completionHandler Callback function that fires when content has been fetched or if this process resolves in an error. Note: Does not automtically retry fetch.
 @deprecated
 */
+ (void)synchronizeContent: (mpSyncContentHandlerBlockType) completionHandler;

/**
 Register Location data sources.
 All registered location sources must have a unique sourceId.
 @param  sources The sources of Location data to use in the current session.
 */
+ (void)registerLocationSources: (NSArray<id<MPLocationSource>>*) sources;

/**
 Sets the offline mode for the content provided by MapsIndoors. NB: This forces the implementation to be offline, even if there is no data available offline.
 @param offlineMode The offline mode. Can be true/offline false/online.
 */
+ (void) setOfflineMode:(BOOL)offlineMode;

/**
 Gets the current offline mode.
 */
+ (BOOL) getOfflineMode;

/**
 Determine if enough data is available for a good user experience in offline mode.

 @return YES if offline data is available, else NO.
 */
+ (BOOL) isOfflineDataAvailable;

/**
 Check availability of offline data.

 @param completion callback
 */
+ (void) checkOfflineDataAvailabilityAsync:(void(^)(void))completion;

/**
 The font that MapsIndoors should use when rendering labels on the map.
 */
@property (class) UIFont* mapLabelFont;

/**
 The color that MapsIndoors should use when rendering labels on the map.
 */
@property (class) UIColor* mapLabelColor;

/**
 The position provider that MapsIndoors should use when user location services are needed.
 */
@property (class) id<MPPositionProvider> positionProvider;

/**
 Default map icon size
 */
@property(class) CGSize mapIconSize;

/**
 The image provider that MapsIndoors should use when image ressources are needed. MapsIndoors will provide a default if this property is nil.
 */
@property(class) id<MPImageProvider> imageProvider;

/**
 The location provider that MapsIndoors should use.
 */
@property (class) id<MPLocationsProvider> locationsProvider;

/**
 The currently registered location sources.
*/
@property (class, readonly) NSArray<id<MPLocationSource>>* sources;

/**
 Set the font that MapsIndoors should use when rendering labels on the map, and enable or disable white halo for improved visibility.
 */
+ (void)setMapLabelFont:(UIFont *)mapLabelFont showHalo: (BOOL) showHalo;

/**
 Returns whether halo is enabled for map labels.
 */
+ (BOOL)isMapLabelHaloEnabled;

/**
 Returns whether the current API key is valid or not.
 */
+ (BOOL) isAPIKeyValid;

/**
 Controls whether overlapping map markers can be resolved by grouping some of the overlapping items.
 Default value is NO;
 When set to YES, the default behavior is to group MPLocation's of the same type.
 */
@property(class) BOOL   locationClusteringEnabled;


@end
