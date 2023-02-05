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

#import <MapsIndoorsCore/MPSolution.h>
#import <MapsIndoorsCore/MPSolutionProvider.h>

#import <MapsIndoorsCore/MPAppData.h>
#import <MapsIndoorsCore/MPBuilding.h>
#import <MapsIndoorsCore/MPContactModule.h>
#import <MapsIndoorsCore/MPFloor.h>
#import <MapsIndoorsCore/MPFloorSelectorControl.h>
#import <MapsIndoorsCore/MPGeometry.h>
#import <MapsIndoorsCore/MPLatLng.h>
#import <MapsIndoorsCore/MPLatLngBounds.h>
#import <MapsIndoorsCore/MPLayerType.h>
#import <MapsIndoorsCore/MPLineGeometry.h>
#import <MapsIndoorsCore/MPLocation.h>
#import <MapsIndoorsCore/MPLocationBaseType.h>
#import <MapsIndoorsCore/MPLocationUpdate.h>
#import <MapsIndoorsCore/MPLocationProperty.h>
#import <MapsIndoorsCore/MPFilterBehavior.h>
#import <MapsIndoorsCore/MPSelectionBehavior.h>
#import <MapsIndoorsCore/MPMapBehavior.h>
#import <MapsIndoorsCore/MPMapStyle.h>

#import <MapsIndoorsCore/MPPoint.h>
#import <MapsIndoorsCore/MPVector.h>
#import <MapsIndoorsCore/MPVenue.h>
#import <MapsIndoorsCore/MPVenueProvider.h>
#import <MapsIndoorsCore/NSURL+QueryParser.h>
#import <MapsIndoorsCore/MPLocationQuery.h>
#import <MapsIndoorsCore/MPMapExtend.h>
#import <MapsIndoorsCore/MPPositionProvider.h>
#import <MapsIndoorsCore/MPImageRenderer.h>
#import <MapsIndoorsCore/MPMyLocationButton.h>
#import <MapsIndoorsCore/NSObject+MPLanguageSupport.h>

#import <MapsIndoorsCore/MPBuildingCollection.h>
#import <MapsIndoorsCore/NSString+CustomFont.h>
#import <MapsIndoorsCore/MPCategoriesProvider.h>
#import <MapsIndoorsCore/MPCategories.h>
#import <MapsIndoorsCore/MPImageProvider.h>
#import <MapsIndoorsCore/MPPngImageProvider.h>
#import <MapsIndoorsCore/MPErrorCodes.h>
#import <MapsIndoorsCore/NSString+UrlRequest.h>
#import <MapsIndoorsCore/UIImage+MapsIndoorsBundle.h>
#import <MapsIndoorsCore/MPMessage.h>
#import <MapsIndoorsCore/MPMessageDataset.h>
#import <MapsIndoorsCore/MPMessageProvider.h>
#import <MapsIndoorsCore/MPAppDataProvider.h>
#import <MapsIndoorsCore/MPMenuItem.h>
#import <MapsIndoorsCore/MPMIAPI.h>
#import <MapsIndoorsCore/MPVersion.h>
#import <MapsIndoorsCore/MPVersionConstants.h>
#import <MapsIndoorsCore/MPMapsIndoorsLegacy.h>

#import <MapsIndoorsCore/MPLocationsObserver.h>
#import <MapsIndoorsCore/MPLocationSource.h>
#import <MapsIndoorsCore/MPLiveDomainType.h>
#import <MapsIndoorsCore/MPLiveUpdateTopic.h>
#import <MapsIndoorsCore/MPWirelessPositionTopic.h>
#import <MapsIndoorsCore/MPMQTTSubscriptionClient.h>
#import <MapsIndoorsCore/MPSubscriptionTopic.h>
#import <MapsIndoorsCore/MPLiveTopicCriteria.h>
#import <MapsIndoorsCore/MPLiveUpdate.h>
#import <MapsIndoorsCore/MPOccupancyLiveUpdate.h>
#import <MapsIndoorsCore/MPAvailabilityLiveUpdate.h>
#import <MapsIndoorsCore/MPPositionLiveUpdate.h>
#import <MapsIndoorsCore/MPCountLiveUpdate.h>
#import <MapsIndoorsCore/MPTemperatureLiveUpdate.h>
#import <MapsIndoorsCore/MPCO2LiveUpdate.h>
#import <MapsIndoorsCore/MPHumidityLiveUpdate.h>
#import <MapsIndoorsCore/MPLiveDataManager.h>
#import <MapsIndoorsCore/MPLiveDataInfo.h>

#import <MapsIndoorsCore/MPDirectionsService.h>
#import <MapsIndoorsCore/MPDirectionsQuery.h>
#import <MapsIndoorsCore/MPDistanceMatrixElements.h>
#import <MapsIndoorsCore/MPDistanceMatrixProvider.h>
#import <MapsIndoorsCore/MPDistanceMatrixResult.h>
#import <MapsIndoorsCore/MPDistanceMatrixRows.h>
#import <MapsIndoorsCore/MPMapRouteLegButton.h>
#import <MapsIndoorsCore/MPRoute.h>
#import <MapsIndoorsCore/MPRouteBounds.h>
#import <MapsIndoorsCore/MPRouteCoordinate.h>
#import <MapsIndoorsCore/MPRouteLeg.h>
#import <MapsIndoorsCore/MPRouteProperty.h>
#import <MapsIndoorsCore/MPRouteResult.h>
#import <MapsIndoorsCore/MPRouteStep.h>
#import <MapsIndoorsCore/MPRoutingProvider.h>
#import <MapsIndoorsCore/MPTransitAgency.h>
#import <MapsIndoorsCore/MPTransitDetails.h>
#import <MapsIndoorsCore/MPTransitLine.h>
#import <MapsIndoorsCore/MPTransitStop.h>
#import <MapsIndoorsCore/MPTransitTime.h>
#import <MapsIndoorsCore/MPTransitVehicle.h>

#import <MapsIndoorsCore/MPLocationService.h>
#import <MapsIndoorsCore/MPQuery.h>
#import <MapsIndoorsCore/MPFilter.h>

#import <MapsIndoorsCore/MPDataSetCacheManager.h>
#import <MapsIndoorsCore/MPDataSetCache.h>
#import <MapsIndoorsCore/MPDataSetCacheItem.h>
#import <MapsIndoorsCore/MPDataSetEnums.h>
#import <MapsIndoorsCore/MPDataSetCacheManagerDelegate.h>
#import <MapsIndoorsCore/MPDataSetCacheManagerSizeDelegate.h>

#import <MapsIndoorsCore/MPGeometryQueryProtocol.h>
#import <MapsIndoorsCore/MPPolygonGeometry.h>
#import <MapsIndoorsCore/MPGeometryHelper.h>
#import <MapsIndoorsCore/MPGeometryContainmentMetadata.h>

#import <MapsIndoorsCore/MPUserRole.h>

#import <MapsIndoorsCore/MPBookingService.h>
#import <MapsIndoorsCore/MPBooking.h>
#import <MapsIndoorsCore/MPBookableQuery.h>
#import <MapsIndoorsCore/MPBookingsQuery.h>
#import <MapsIndoorsCore/MPBookingAuthConfig.h>

#import <MapsIndoorsCore/MPAuthDetails.h>
#import <MapsIndoorsCore/MPAuthClientInfo.h>
#import <MapsIndoorsCore/MPMapsIndoorsLegacyDelegate.h>
#import <MapsIndoorsCore/MPLocationDataset.h>
