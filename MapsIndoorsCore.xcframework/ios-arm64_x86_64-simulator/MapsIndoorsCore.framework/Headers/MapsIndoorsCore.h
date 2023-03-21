//
//  MapsIndoors.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 30/08/16.
//  Copyright  Daniel-Nielsen. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import <MapsIndoorsCore/UIColor+HexString.h>

#import <MapsIndoorsCore/MPSolutionInternal.h>
#import <MapsIndoorsCore/MPSolutionProvider.h>

#import <MapsIndoorsCore/MPAppData.h>
#import <MapsIndoorsCore/MPBuildingInternal.h>
#import <MapsIndoorsCore/MPBuildingInfo.h>
#import <MapsIndoorsCore/MPFloorInternal.h>
#import <MapsIndoorsCore/MPFloorSelectorControl.h>
#import <MapsIndoorsCore/MPLocationUpdate.h>
#import <MapsIndoorsCore/MPLocationProperty.h>
#import <MapsIndoorsCore/MPMapStyleInternal.h>

#import <MapsIndoorsCore/MPVenueInternal.h>
#import <MapsIndoorsCore/MPVenueProvider.h>
#import <MapsIndoorsCore/MPImageRenderer.h>
#import <MapsIndoorsCore/NSObject+MPLanguageSupport.h>

#import <MapsIndoorsCore/MPBuildingCollection.h>
#import <MapsIndoorsCore/MPCategoriesProvider.h>
#import <MapsIndoorsCore/MPCategories.h>
#import <MapsIndoorsCore/MPImageProvider.h>
#import <MapsIndoorsCore/MPPngImageProvider.h>
#import <MapsIndoorsCore/MPErrorCodes.h>
#import <MapsIndoorsCore/NSString+UrlRequest.h>
#import <MapsIndoorsCore/MPAppDataProvider.h>
#import <MapsIndoorsCore/MPMenuItem.h>
#import <MapsIndoorsCore/MPMIAPI.h>
#import <MapsIndoorsCore/MPVersion.h>
#import <MapsIndoorsCore/MPVersionConstants.h>
#import <MapsIndoorsCore/MPMapsIndoorsLegacy.h>

#import <MapsIndoorsCore/MPLocationSource.h>
#import <MapsIndoorsCore/MPLiveDomainType.h>
#import <MapsIndoorsCore/MPLiveUpdateTopicInternal.h>
#import <MapsIndoorsCore/MPMQTTSubscriptionClient.h>
#import <MapsIndoorsCore/MPLiveTopicCriteria.h>
#import <MapsIndoorsCore/MPLiveUpdateInternal.h>
#import <MapsIndoorsCore/MPOccupancyLiveUpdate.h>
#import <MapsIndoorsCore/MPAvailabilityLiveUpdate.h>
#import <MapsIndoorsCore/MPPositionLiveUpdate.h>
#import <MapsIndoorsCore/MPCountLiveUpdate.h>
#import <MapsIndoorsCore/MPTemperatureLiveUpdate.h>
#import <MapsIndoorsCore/MPCO2LiveUpdate.h>
#import <MapsIndoorsCore/MPHumidityLiveUpdate.h>
#import <MapsIndoorsCore/MPLiveDataManager.h>
#import <MapsIndoorsCore/MPLiveDataInfo.h>

#import <MapsIndoorsCore/MPDirectionsServiceInternal.h>
#import <MapsIndoorsCore/MPDistanceMatrixElements.h>
#import <MapsIndoorsCore/MPDistanceMatrixProvider.h>
#import <MapsIndoorsCore/MPDistanceMatrixResult.h>
#import <MapsIndoorsCore/MPDistanceMatrixRows.h>
#import <MapsIndoorsCore/MPMapRouteLegButton.h>
#import <MapsIndoorsCore/MPRouteInternal.h>
#import <MapsIndoorsCore/MPRouteBoundsInternal.h>
#import <MapsIndoorsCore/MPRouteCoordinateInternal.h>
#import <MapsIndoorsCore/MPRouteLegInternal.h>
#import <MapsIndoorsCore/MPRoutePropertyInternal.h>
#import <MapsIndoorsCore/MPRouteResultInternal.h>
#import <MapsIndoorsCore/MPRouteStepInternal.h>
#import <MapsIndoorsCore/MPRoutingProvider.h>
#import <MapsIndoorsCore/MPTransitAgencyInternal.h>
#import <MapsIndoorsCore/MPTransitDetailsInternal.h>
#import <MapsIndoorsCore/MPTransitLineInternal.h>
#import <MapsIndoorsCore/MPTransitStopInternal.h>
#import <MapsIndoorsCore/MPTransitTimeInternal.h>
#import <MapsIndoorsCore/MPTransitVehicleInternal.h>

#import <MapsIndoorsCore/MPLocationService.h>

#import <MapsIndoorsCore/MPDataSetCacheManagerInternal.h>
#import <MapsIndoorsCore/MPDataSetCacheInternal.h>
#import <MapsIndoorsCore/MPDataSetCacheItemInternal.h>
#import <MapsIndoorsCore/MPDataSetEnums.h>

#import <MapsIndoorsCore/MPBookingServiceInternal.h>

#import <MapsIndoorsCore/MPAuthClientInfoInternal.h>
#import <MapsIndoorsCore/MPMapsIndoorsLegacyDelegate.h>
#import <MapsIndoorsCore/MPLocationDataset.h>

#import <MapsIndoorsCore/MPLocationInternal.h>
#import <MapsIndoorsCore/MPTypeInternal.h>

#import <MapsIndoorsCore/MPGraphNode.h>
#import <MapsIndoorsCore/MPLocationCoordinate3D.h>
#import <MapsIndoorsCore/MPURITemplate.h>
#import <MapsIndoorsCore/MPTileCache.h>
#import <MapsIndoorsCore/NSString+MPPropertyClassification.h>
#import <MapsIndoorsCore/NSObject+GeometryProperties.h>
#import <MapsIndoorsCore/MPRouteNode.h>
