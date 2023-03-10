//
//  MPError.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 05/02/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#define kMPErrorCodeLocationsCacheNotBuilt                          100100
#define kMPErrorCodeLocationsCacheNotAvailableForMapExtend          100130
#define kMPErrorCodeLocationsNotFound                               100110
#define kMPErrorCodeLocationDetailsNotFound                         100120

#define kMPErrorCodeVenueDetailsNotFound                            100200
#define kMPErrorCodeVenuesNotFound                                  100210

#define kMPErrorCodeBuildingDetailsNotFound                         100300
#define kMPErrorCodeBuildingsNotFound                               100310

#define kMPErrorCodeSolutionDetailsNotFound                         100400
#define kMPErrorCodeSolutionsNotFound                               100410

#define kMPErrorCodeMessagesNotFound                                100500
#define kMPErrorCodeMessageDetailsNotFound                          100510

#define kMPErrorCodeDirectionsRouteNotFound                         100610
#define kMPErrorCodeDirectionsMatrixNotFound                        100620
#define kMPErrorCodeDirectionsOriginAndDestinationTooCloseOrTheSame 100630

#define kMPErrorCodeCategoriesNotFound                              100710
#define kMPErrorCodeAppDataNotFound                                 100810
#define kMPErrorCodeUserRolesNotFound                               100910

#define kMPErrorCodeOfflineContentNotFound                          101010

#define kMPErrorCodeImageAssetNotFound                              101110

#define kMPErrorCodeParameterAssert                                 101200

#define kMPErrorCodeTilePackagesNotFound                            101210

#define kMPErrorCodeHttpError                                       101300

#define kMPErrorCodeRouteNetworkNotFound                            101400

#define kMPErrorCodeInvalidApiKey                                   101500
#define kMPErrorCodeInvalidGraphId                                  101510
#define kMPErrorCodeInvalidSolutionId                               101520

#define kMPErrorCodeSynchronizeContentCancelled                     101600
#define kMPErrorCodeSynchronizeContentDataLoadingError              101610
#define kMPErrorCodeSynchronizeContentDataLoadingErrorKey           @"syncContent::underlyingError"
#define kMPErrorCodeSaveDataError                                   101620
#define kMPErrorCodeSynchronizeContentDataNotAvailableOffline       101620

#define kMPErrorCodeLiveDataSubscriptionFailedNotActive             102000

#define kMPErrorCodeDependingConnectionWasLost                      103000

#define kMPErrorCodeRouteLayerNotFound                              103010

#define kMPErrorCodeNotAuthorised                                   104000

#define kMPMapsIndoorsDomain @"com.mapspeople.MapsIndoors"

#define MPMakeErrorWithCode(cODE,uSRiNFOdICT)   [NSError errorWithDomain:kMPMapsIndoorsDomain code:cODE userInfo:uSRiNFOdICT]
