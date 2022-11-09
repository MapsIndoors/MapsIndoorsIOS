//
//  MPMapsIndoors.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 04/11/2016.
//  Copyright (c) 2016-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDefines.h"


@class MPDataSetCacheManager;
@class MPUserRole;
@protocol MPAuthDetails;
@protocol MPImageProvider;
@protocol MPLocationSource;
@protocol MPLocationsProvider;
@protocol MPMapsIndoorsDelegate;
@protocol MPPositionProvider;


/**
 Content synchronisation callback handler block

 @param error Error object.
 */
typedef void(^mpSyncContentHandlerBlockType)( NSError* _Nullable error );

/**
 Offline content availability callback handler block

 @param error Error object.
 */
typedef void(^mpOfflineDataHandlerBlockType)( NSError* _Nullable error);

/**
 Authentication details callback handler block

 @param authDetails MPAuthDetails object with necessary authentication information.
 @param error Error object.
 */
typedef void(^mpAuthDetailsHandlerBlockType)( id<MPAuthDetails> _Nullable authDetails, NSError* _Nullable error );


#define kMPNotificationPositionProviderReassign         @"MP_POSITION_PROVIDER_REASSIGNED"
#define kMPNotificationApiKeyInvalid                    @"MAPSINDOORS_API_KEY_INVALID"
#define kMPNotificationAppDataUpdate                    @"MP_APP_DATA_UPDATE"
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
+ (BOOL) provideAPIKey:(nonnull NSString*)mapsIndoorsAPIKey googleAPIKey:(nullable NSString*)googleAPIKey;

/// Provides the API key to MapsIndoors SDK after validating the key.
/// @param mapsIndoorsAPIKey The MapsIndoors API key
/// @param googleAPIKey The Google API key
/// @param completion Whether the API key and content key was successfully provided
+ (void) provideAPIKey:(nonnull NSString*)mapsIndoorsAPIKey googleAPIKey:(nullable NSString*)googleAPIKey completionBlock:(void (^_Nullable)(BOOL))completion;

/**
 Gets the current MapsIndoors API key.
 @return The MapsIndoors API key as a string value.
 */
+ (nullable NSString*) getMapsIndoorsAPIKey;
/**
 Gets the current Google API key.
 @return The Google API key as a string value.
 */
+ (nullable NSString*) getGoogleAPIKey;

/**
 Sets the language for the content provided by MapsIndoors.
 @param languageCode The language for which the content should be fetched. Uses the two-letter language code ISO 639-1.
 */
+ (void) setLanguage:(nonnull NSString*)languageCode;

/**
 Gets the current language for the content provided by MapsIndoors.
   @returns The language for which the content should be fetched. Uses the two-letter language code ISO 639-1.
 */
+ (nullable NSString*) getLanguage;

/**
 Fetch all neccesary content to be able to run MapsIndoors in offline environments.
 If you have registered custom location sources, they are not synchronized by this method - it is the responsibility of the provider of the custom location source to synchronize as appropriate.
 This method only synchronizes the current dataset - If you need to synchronize data for non-current datasets, please see @see dataSetCacheManager and MPDataSetCacheManager.synchronizeContent()
 @param  completionHandler Callback function that fires when content has been fetched or if this process resolves in an error. Note: Does not automtically retry fetch.
 */
+ (void)synchronizeContent: (nonnull mpSyncContentHandlerBlockType) completionHandler;

/**
 Register Location data sources.
 All registered location sources must have a unique sourceId.
 @param  sources The sources of Location data to use in the current session.
 */
+ (void)registerLocationSources: (nonnull NSArray<id<MPLocationSource>>*) sources;

/**
 Sets the offline mode for the content provided by MapsIndoors. True means that the SDK is not allowed to use network traffic. NB: This forces the implementation to be offline, even if there is no data available offline.
 @param offlineMode The offline mode. Can be true/offline false/online.
 */
+ (void) setOfflineMode:(BOOL)offlineMode;

/**
 Gets the current offline mode. True means that the SDK is not allowed to use network traffic.
 */
+ (BOOL) getOfflineMode;

/**
 Determine if enough data is available for a good user experience in offline mode.
 For results that are not dependent on timing of async calls, this is best used in the completion handler of +[MapsIndoors checkOfflineDataAvailabilityAsync:].

 @return YES if offline data is available, else NO.
 */
+ (BOOL) isOfflineDataAvailable;

/**
 Check availability of offline data.

 @param completion callback
 */
+ (void) checkOfflineDataAvailabilityAsync:(void(^_Nonnull)(void))completion;

/**
 Fetch authentication details needed to perform an Auth2 supported single signon flow in your application.

 @param completion callback
 */
+ (void) fetchAuthenticationDetails:(mpAuthDetailsHandlerBlockType _Nonnull)completion;


/**
 The position provider that MapsIndoors should use when user location services are needed.
 */
@property (class, nullable) id<MPPositionProvider> positionProvider;

/**
 The image provider that MapsIndoors should use when image ressources are needed. MapsIndoors will provide a default if this property is nil.
 */
@property (class, nullable) id<MPImageProvider> imageProvider;

/**
 The location provider that MapsIndoors should use.
 @deprecated Use MPLocationSource, setting MapsIndoors.sources instead
 */
@property (class, nullable) id<MPLocationsProvider> locationsProvider DEPRECATED_MSG_ATTRIBUTE("Use MPLocationSource, setting MapsIndoors.sources instead");

/**
 The currently registered location sources.
*/
@property (class, readonly, nullable) NSArray<id<MPLocationSource>>* sources;


/**
 Returns whether the current API key is valid or not.
 */
+ (BOOL) isAPIKeyValid;


/**
 Get the shared dataset cache manager.
 */
@property (class, readonly, nonnull) MPDataSetCacheManager*      dataSetCacheManager;

/**
 Get or set the user roles that should apply generally for querying routes and locations. The roles are applied in an OR fashion. This means that if for example a locations internal restrictions matches one or more of the given roles, the location will be included in response object. Setting the user roles will only work when online.
 */
@property (class, nonatomic, strong, nullable) NSArray<MPUserRole*>*       userRoles;

/**
  Gets or sets the event logging state. If enabled, the SDK will collect anonymous SDK usage data from the application. By default, the collection of usage event data is enabled, but in order for logs to be collected, the logging must also be enabled in the MapsIndoors CMS.
 */
@property (class, nonatomic) BOOL                                           eventLoggingDisabled;

/**
 Get or set the access token. Only relevant for datasets that requires authorised access.
 */
@property (class, nonatomic, strong, nullable) NSString*       accessToken;

/**
 Get or set the delegate object.
 */
@property (class, nonatomic, weak, nullable) id<MPMapsIndoorsDelegate>       delegate;

@end
