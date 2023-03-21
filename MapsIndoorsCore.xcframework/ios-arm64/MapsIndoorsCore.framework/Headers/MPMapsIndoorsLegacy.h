//
//  MPMapsIndoors.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 04/11/2016.
//  Copyright (c) 2016-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class MPDataSetCacheManagerInternal;
@class MPSolutionInternal;
@class MPUserRole;
@protocol MPAuthDetails;
@protocol MPImageProviderProtocol;
@protocol MPLocationSource;
@protocol MPLocationsProvider;
@protocol MPMapsIndoorsLegacyDelegate;
@protocol MPPositionProvider;

/**
 Content synchronisation callback handler block

 - Parameter error: Error object.
 */
typedef void(^mpSyncContentHandlerBlockType)( NSError* _Nullable error );

/**
 Offline content availability callback handler block

 - Parameter error: Error object.
 */
typedef void(^mpOfflineDataHandlerBlockType)( NSError* _Nullable error);

/**
 Authentication details callback handler block

 - Parameter authDetails: MPAuthDetails object with necessary authentication information.
 - Parameter error: Error object.
 */
typedef void(^mpAuthDetailsHandlerBlockType)( id<MPAuthDetails> _Nullable authDetails, NSError* _Nullable error );


#define kMPNotificationPositionProviderReassign         @"MP_POSITION_PROVIDER_REASSIGNED"
#define kMPNotificationApiKeyInvalid                    @"MAPSINDOORS_API_KEY_INVALID"
#define kMPNotificationAppDataUpdate                    @"MP_APP_DATA_UPDATE"
#define kMPNotificationAppDataValueKey                  @"kMPNotificationAppDataValueKey"
#define kMPNotificationAppDataErrorKey                  @"kMPNotificationAppDataErrorKey"


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 [DEPRECATED]
 Main class for initialisation, configuration and content synchronisation.
 */
@interface MapsIndoorsLegacy : NSObject

/**
 Provides your API key and content key to the MapsIndoors SDK. These keys are unique for your MapsIndoors solution and are used to identify and authorise use of the data provided by MapsIndoors.

 - Parameter mapsIndoorsAPIKey: The MapsIndoors API key
 - Returns: Whether the API key and content key was successfully provided
 */
+ (void)provideAPIKey:(NSString*)mapsIndoorsAPIKey completion:(void(^_Nonnull)(void))completion;

/**
 Reset MapsIndoors API key, to facilitate the "log out" functionality of the POC app.
 */
+ (void) __unProvideAPIKey;

/**
 Gets the current MapsIndoors API key.
 - Returns: The MapsIndoors API key as a string value.
 */
+ (nullable NSString*) getMapsIndoorsAPIKey;

/**
 Sets the language for the content provided by MapsIndoors.
 - Parameter languageCode: The language for which the content should be fetched. Uses the two-letter language code ISO 639-1.
 */
+ (void)setLanguage:(NSString*)languageCode;

/**
 Gets the current language for the content provided by MapsIndoors.
   @returns The language for which the content should be fetched. Uses the two-letter language code ISO 639-1.
 */
+ (NSString*)getLanguage;

/**
 Fetch all neccesary content to be able to run MapsIndoors in offline environments.
 If you have registered custom location sources, they are not synchronized by this method - it is the responsibility of the provider of the custom location source to synchronize as appropriate.
 This method only synchronizes the current dataset - If you need to synchronize data for non-current datasets, please see ``dataSetCacheManager`` and ``MPDataSetCacheManager/synchronizeContent``
 - Parameter completionHandler: Callback function that fires when content has been fetched or if this process resolves in an error. Note: Does not automtically retry fetch.
 */
+ (void)synchronizeContent:(mpSyncContentHandlerBlockType)completionHandler;

/**
 Determine if enough data is available for a good user experience in offline mode.
 For results that are not dependent on timing of async calls, this is best used in the completion handler of +[MapsIndoors checkOfflineDataAvailabilityAsync:].

 - Returns: YES if offline data is available, else NO.
 */
+ (BOOL) isOfflineDataAvailable;

/**
 Check availability of offline data.

 - Parameter completion: callback
 */
+ (void) checkOfflineDataAvailabilityAsync:(void(^_Nonnull)(void))completion;

/**
 Fetch authentication details needed to perform an Auth2 supported single signon flow in your application.

 - Parameter completion: callback
 */
+ (void) fetchAuthenticationDetails:(mpAuthDetailsHandlerBlockType _Nonnull)completion;


/**
 The position provider that MapsIndoors should use when user location services are needed.
 */
@property (class, nullable) id<MPPositionProvider> positionProvider;

/**
 The image provider that MapsIndoors should use when image ressources are needed. MapsIndoors will provide a default if this property is nil.
 */
@property (class, nullable) id<MPImageProviderProtocol> imageProvider;

/**
 Returns whether the current API key is valid or not.
 */
+ (BOOL) isAPIKeyValid;


/**
 Get the shared dataset cache manager.
 */
@property (class, readonly) MPDataSetCacheManagerInternal* dataSetCacheManager;

/**
 Get or set the user roles that should apply generally for querying routes and locations. The roles are applied in an OR fashion. This means that if for example a locations internal restrictions matches one or more of the given roles, the location will be included in response object. Setting the user roles will only work when online.
 */
@property (class, nonatomic, strong, nullable) NSArray<MPUserRole*>* userRoles;

/**
  Gets or sets the event logging state. If enabled, the SDK will collect anonymous SDK usage data from the application. By default, the collection of usage event data is enabled, but in order for logs to be collected, the logging must also be enabled in the MapsIndoors CMS.
 */
@property (class, nonatomic) BOOL eventLoggingDisabled;

/**
 Get or set the access token. Only relevant for datasets that requires authorised access.
 */
@property (class, nonatomic, strong, nullable) NSString*       accessToken;

/**
 Get or set the delegate object.
 */
@property (class, nonatomic, weak, nullable) id<MPMapsIndoorsLegacyDelegate>       delegate;


/// The MPSolution for the current API Key/language.
///
/// Is `nil` if no data is present for the current API Key/language set
@property (class, nullable, readonly) MPSolutionInternal* solution;

@end

NS_ASSUME_NONNULL_END
