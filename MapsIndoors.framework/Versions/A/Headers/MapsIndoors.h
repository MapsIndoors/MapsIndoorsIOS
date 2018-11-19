//
//  MapsIndoors.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 30/08/16.
//  Copyright  Daniel-Nielsen. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import <MapsIndoors/UIColor+HexString.h>
#import <MapsIndoors/MPAppData.h>
#import <MapsIndoors/MPBuilding.h>
#import <MapsIndoors/MPBuildingDataset.h>
#import <MapsIndoors/MPCategoryUIBarButtonItem.h>
#import <MapsIndoors/MPContactModule.h>
#import <MapsIndoors/MPFloor.h>
#import <MapsIndoors/MPFloorButton.h>
#import <MapsIndoors/MPFloorSelectorControl.h>
#import <MapsIndoors/MPFloorTileLayer.h>
#import <MapsIndoors/MPPersistentCacheGMSTileLayer.h>
#import <MapsIndoors/MPGeometry.h>
#import <MapsIndoors/MPInfoSnippetView.h>
#import <MapsIndoors/MPLatLng.h>
#import <MapsIndoors/MPLatLngBounds.h>
#import <MapsIndoors/MPLayerType.h>
#import <MapsIndoors/MPLineGeometry.h>
#import <MapsIndoors/MPLoadIndicator.h>
#import <MapsIndoors/MPLocation.h>
#import <MapsIndoors/MPLocationDataset.h>
#import <MapsIndoors/MPLocationDisplayRule.h>
#import <MapsIndoors/MPLocationDisplayRuleset.h>
#import <MapsIndoors/MPLocationProperty.h>
#import <MapsIndoors/MPLocationPropertyTableCell.h>
#import <MapsIndoors/MPLocationPropertyView.h>
#import <MapsIndoors/MPLocationsProvider.h>
#import <MapsIndoors/MPLocationView.h>
#import <MapsIndoors/MPMapControl.h>
#import <MapsIndoors/MPMapStyle.h>
#import <MapsIndoors/MPPoint.h>
#import <MapsIndoors/MPVector.h>
#import <MapsIndoors/MPLocationCoordinate3D.h>
#import <MapsIndoors/MPURITemplate.h>
#import <MapsIndoors/MPVenue.h>
#import <MapsIndoors/MPVenueCollection.h>
#import <MapsIndoors/MPVenueProvider.h>
#import <MapsIndoors/NSString+FontAwesome.h>
#import <MapsIndoors/NSURL+QueryParser.h>
#import <MapsIndoors/UIFont+FontAwesome.h>
#import <MapsIndoors/UIFont+RegisterURL.h>
#import <MapsIndoors/MPLocationQuery.h>
#import <MapsIndoors/MPMapExtend.h>
#import <MapsIndoors/MPPositionProvider.h>
#import <MapsIndoors/MPImageRenderer.h>
#import <MapsIndoors/MPMyLocationButton.h>
#import <MapsIndoors/MPBeacon.h>
#import <MapsIndoors/MPBeaconProvider.h>
#import <MapsIndoors/NSObject+MPLanguageSupport.h>

#import <MapsIndoors/FAImageView.h>
#import <MapsIndoors/MPBeaconCollection.h>
#import <MapsIndoors/MPBuildingCollection.h>
#import <MapsIndoors/MPBuildingReference.h>
#import <MapsIndoors/MPMapButtonControl.h>
#import <MapsIndoors/NSString+CustomFont.h>
#import <MapsIndoors/UIFont+CustomFont.h>
#import <MapsIndoors/MPCategoriesProvider.h>
#import <MapsIndoors/MPCategories.h>
#import <MapsIndoors/MPImageProvider.h>
#import <MapsIndoors/MPPngImageProvider.h>
#import <MapsIndoors/MPErrorCodes.h>
#import <MapsIndoors/MPMarkerView.h>
#import <MapsIndoors/NSString+UrlRequest.h>
#import <MapsIndoors/UIImage+MapsIndoorsBundle.h>
#import <MapsIndoors/MPMessage.h>
#import <MapsIndoors/MPMessageDataset.h>
#import <MapsIndoors/MPMessageProvider.h>
#import <MapsIndoors/MPStringCache.h>
#import <MapsIndoors/MPAppDataProvider.h>
#import <MapsIndoors/MPMenuItem.h>
#import <MapsIndoors/MPMIAPI.h>
#import <MapsIndoors/MPVersion.h>
#import <MapsIndoors/MPVersionConstants.h>
#import <MapsIndoors/MPNotificationsHelper.h>
#import <MapsIndoors/MPMapsIndoors.h>

#import <MapsIndoors/MPLocationsObserver.h>
#import <MapsIndoors/MPLocationSource.h>

#import <MapsIndoors/MPDirectionsRenderer.h>
#import <MapsIndoors/MPDirectionsService.h>
#import <MapsIndoors/MPDirectionsQuery.h>
#import <MapsIndoors/MPDistanceMatrixElements.h>
#import <MapsIndoors/MPDistanceMatrixProvider.h>
#import <MapsIndoors/MPDistanceMatrixResult.h>
#import <MapsIndoors/MPDistanceMatrixRows.h>
#import <MapsIndoors/MPMapRouteLegButton.h>
#import <MapsIndoors/MPRoute.h>
#import <MapsIndoors/MPRouteBounds.h>
#import <MapsIndoors/MPRouteCoordinate.h>
#import <MapsIndoors/MPRouteInfo.h>
#import <MapsIndoors/MPRouteInstructions.h>
#import <MapsIndoors/MPRouteLeg.h>
#import <MapsIndoors/MPRouteProperty.h>
#import <MapsIndoors/MPRouteResult.h>
#import <MapsIndoors/MPRouteStep.h>
#import <MapsIndoors/MPRoutingControl.h>
#import <MapsIndoors/MPRoutingProvider.h>
#import <MapsIndoors/MPTransitAgency.h>
#import <MapsIndoors/MPTransitDetails.h>
#import <MapsIndoors/MPTransitLine.h>
#import <MapsIndoors/MPTransitStop.h>
#import <MapsIndoors/MPTransitTime.h>
#import <MapsIndoors/MPTransitVehicle.h>

#import <MapsIndoors/MPJSONAPI.h>
#import <MapsIndoors/MPJSONHTTPClient.h>
#import <MapsIndoors/MPJSONKeyMapper.h>
#import <MapsIndoors/MPJSONModel.h>
#import <MapsIndoors/MPJSONModelClassProperty.h>
#import <MapsIndoors/MPJSONModelError.h>
#import <MapsIndoors/MPJSONValueTransformer.h>

#import <MapsIndoors/MPLocationService.h>
#import <MapsIndoors/MPQuery.h>
#import <MapsIndoors/MPFilter.h>

