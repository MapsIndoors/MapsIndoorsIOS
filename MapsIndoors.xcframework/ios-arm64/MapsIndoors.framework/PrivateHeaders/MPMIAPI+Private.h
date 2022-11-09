//
//  MPMIAPI.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 19/09/2017.
//  Copyright © 2015-2017 MapsPeople A/S. All rights reserved.
//

#import "MPMIAPI.h"
#import "MPAuthDetails.h"

#define kMPMI_EndPointGraph      @"graph"
#define kMPMI_EndPointLocation   @"locations"
#define kMPMI_EndPointVenue      @"venues"
#define kMPMI_EndPointBuilding   @"buildings"
#define kMPMI_EndPointSolution   @"solutions"
#define kMPMI_EndPointAppData    @"appconfig"
#define kMPMI_EndPointCategory   @"categories"
#define kMPMI_EndPointTile       @"tiles"
#define kMPMI_EndPointUserRole   @"appuserroles"
#define kMPMI_EndPointRouteLayer @"routelayer"
#define kMPMI_EndPointDataSet    @"dataset"


NS_ASSUME_NONNULL_BEGIN


typedef void (^RefreshSessionCompletionBlock)(void);

@class MPUserRole;

@interface MPMIAPI (Private)

+ (instancetype) sharedInstance;

#pragma mark - Session info
@property (nonatomic, strong, readonly, nonnull) NSString*      currentBaseUrl;     // May change dynamically.
@property (nonatomic, strong, readonly, nullable) NSString*     sessionToken;
@property (nonatomic, strong, nullable) NSString*     accessToken;
@property (nonatomic, strong, readonly, nullable) id<MPAuthDetails>     authDetails;
@property (nonatomic, strong, readonly, nullable) NSError*      sessionTokenRefreshError;
@property (nonatomic, readonly) BOOL                            apiKeyValid;
@property (nonatomic, readonly) BOOL                            isAuthorised;
@property (nonatomic, readwrite) BOOL                           useDevEnvironment;

#pragma mark - API Endpoint getters
@property (nonatomic, strong, readonly, nonnull) NSString*      gatewayUrl;

@property (nonatomic, strong, readonly, nonnull) NSString*      datasetSizeSyncUrl;
@property (nonatomic, strong, readonly, nonnull) NSString*      graphSyncUrl;
@property (nonatomic, strong, readonly, nonnull) NSString*      locationSyncUrl;
@property (nonatomic, strong, readonly, nonnull) NSString*      venueSyncUrl;
@property (nonatomic, strong, readonly, nonnull) NSString*      buildingSyncUrl;
@property (nonatomic, strong, readonly, nonnull) NSString*      appDataSyncUrl;
@property (nonatomic, strong, readonly, nonnull) NSString*      solutionSyncUrl;
@property (nonatomic, strong, readonly, nonnull) NSString*      tileSyncUrl;
@property (nonatomic, strong, readonly, nonnull) NSString*      categorySyncUrl;
@property (nonatomic, strong, readonly, nonnull) NSString*      userRolesSyncUrl;
@property (nonatomic, strong, readonly, nullable) NSDictionary* proxySettings;

@property (nonatomic, strong, readonly, nonnull) NSString*      liveUpdateUrl;

- (nullable NSString*) graphSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
- (NSString*) locationSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
/// Method to validate the MP key
/// - Parameter apiKey: Pass the test MP API Key
- (NSString*) validateKeyURL:(NSString*)apiKey;
- (NSString*) locationSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language userRoles:(nullable NSArray<MPUserRole*>*) roles;
- (NSString*) venueSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
- (NSString*) buildingSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
- (NSString*) solutionSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
- (NSString*) appDataSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
- (NSString*) categorySyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
- (NSString*) tileSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
- (NSString*) userRolesSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
- (NSString*) routeLayerSyncUrlForSolutionId:(NSString*)solutionId language:(NSString*)language;
- (NSString*) dataSetSyncUrlForSolutionId:(NSString*)solutionId language:(nullable NSString*)language;
- (NSString*) liveDataUrl:(NSString*)endpoint apiKey:(nullable NSString*)apiKey;
- (NSString*) liveDataStateUrl:(NSString*)topic;
- (NSString*) loggingUrl:(NSString*)apiKey;

- (NSArray<NSString*>*) allEndpointUrlsForSyncingSolutionId:(NSString*)solutionId language:(nullable NSString*)language;

#pragma mark - Booking service related
- (NSString*) urlForFetchingBookableLocations:(NSString*)solutionId;
- (NSString*) urlForFetchingLocationsConfiguredForBooking:(NSString*)solutionId;
- (NSString*) urlForFetchingLocationBookings:(NSString*)solutionId;
- (NSString*) urlForFetchingUserBookings:(NSString*)solutionId;
- (NSString*) urlForBooking:(NSString*)solutionId;

#pragma mark - Private API
- (void) resolveBackendUrl;
- (void) refreshSessionWithCompletion:(nullable RefreshSessionCompletionBlock)completion;

- (BOOL) isMapsIndoorsBackendUrl:(nullable NSString*)url;
- (nullable NSString*) urlByNormalizingMapsIndoorsBackendUrls:(nullable NSString*)url;
- (BOOL) isEqualMapsIndoorsBackendUrl:(nullable NSString*)url1 toUrl:(nullable NSString*)url2;

@end


NS_ASSUME_NONNULL_END
