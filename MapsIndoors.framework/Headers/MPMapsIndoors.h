//
//  MPMapsIndoors.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 04/11/2016.
//  Copyright (c) 2016-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MPImageProvider.h"
#import "MPPositionProvider.h"


@protocol MPLocationsProvider;


typedef void(^mpSyncContentHandlerBlockType)(NSError* error);
typedef void(^mpOfflineDataHandlerBlockType)(NSError* error);


@interface MapsIndoors : NSObject

/**
 Provides your Solution Id to the MapsIndoors SDK for iOS. This key is generated for your solution.
 @param solutionId The MapsIndoors content key
 @return YES if the Solution Id was successfully provided
 */
+ (BOOL) provideSolutionId:(NSString*)solutionId DEPRECATED_MSG_ATTRIBUTE("Use +provideApiKey:googleAPIKey:contentKey: instead");

/**
 Provides your API key and content key to the MapsIndoors SDK. These keys are unique for your MapsIndoors solution and are used to identify and authorise use of the data provided by MapsIndoors.

 @param apiKey The MapsIndoors API key
 @param solutionId The MapsIndoors content key
 @return Whether the API key and content key was successfully provided
 */
+ (BOOL) provideAPIKey:(NSString*)mapsIndoorsAPIKey googleAPIKey:(NSString*)googleAPIKey contentKey:(NSString*)solutionId;

/**
 Gets the current MapsIndoors solution id.
 @param  The solution id as a string value.
 */
+ (NSString*) getSolutionId;
+ (NSString*) getMapsIndoorsAPIKey;
+ (NSString*) getGoogleAPIKey;

/**
 Sets the language for the content provided by MapsIndoors.
 @param  language The language for which the content should be fetched. Uses the two-letter language code ISO 639-1.
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
 */
+ (void)fetchDataForOfflineUse: (mpOfflineDataHandlerBlockType) completionHandler DEPRECATED_MSG_ATTRIBUTE("Use the +synchronizeContent method instead");
/**
 Fetch all neccesary content to be able to run MapsIndoors in offline environments
 @param  completionHandler Callback function that fires when content has been fetched or if this process resolves in an error. Note: Does not automtically retry fetch.
 */
+ (void)synchronizeContent: (mpSyncContentHandlerBlockType) completionHandler;

/**
 Sets the offline mode for the content provided by MapsIndoors. NB: This forces the implementation to be offline, even if there is no data available offline.
 @param  offlineMode The offline mode. Can be true/offline false/offline.
 */
+ (void) setOfflineMode:(BOOL)offline;

/**
 Gets the current offline mode.
 */
+ (BOOL) getOfflineMode;

/**
 Determine if enough data is available for a good user experience in iffline mode.

 @return YES if offline data is available, else NO.
 */
+ (BOOL) isOfflineDataAvailable;

/**
 Check availability of offline data.

 @param completion callback
 */
+ (void) checkOfflineDataAvailabilityAsync:(void(^)())completion;

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
 Set the font that MapsIndoors should use when rendering labels on the map, and enable or disable white halo for improved visibility.
 */
+ (void)setMapLabelFont:(UIFont *)mapLabelFont showHalo: (BOOL) showHalo;
/**
 Returns whether halo is enabled for map labels.
 */
+ (BOOL)isMapLabelHaloEnabled;

@end
