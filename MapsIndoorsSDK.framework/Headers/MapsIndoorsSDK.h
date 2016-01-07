//
//  MapsIndoorsSDK.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 29/10/15.
//  Copyright © 2015 Daniel Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

//! Project version number for MapsIndoorsSDK.
FOUNDATION_EXPORT double MapsIndoorsSDKVersionNumber;

//! Project version string for MapsIndoorsSDK.
FOUNDATION_EXPORT const unsigned char MapsIndoorsSDKVersionString[];

#import <MapsIndoorsSDK/UIColor+HexString.h>
#import <MapsIndoorsSDK/MPAppData.h>
#import <MapsIndoorsSDK/MPAppMode.h>
#import <MapsIndoorsSDK/MPBuilding.h>
#import <MapsIndoorsSDK/MPBuildingDataset.h>
#import <MapsIndoorsSDK/MPCategoryUIBarButtonItem.h>
#import <MapsIndoorsSDK/MPContactModule.h>
#import <MapsIndoorsSDK/MPFloor.h>
#import <MapsIndoorsSDK/MPFloorButton.h>
#import <MapsIndoorsSDK/MPFloorSelectorControl.h>
#import <MapsIndoorsSDK/MPFloorTileLayer.h>
#import <MapsIndoorsSDK/MPPersistentCacheGMSTileLayer.h>
#import <MapsIndoorsSDK/MPGeometry.h>
#import <MapsIndoorsSDK/MPInfoSnippetView.h>
#import <MapsIndoorsSDK/MPLatLng.h>
#import <MapsIndoorsSDK/MPLatLngBounds.h>
#import <MapsIndoorsSDK/MPLayerType.h>
#import <MapsIndoorsSDK/MPLineGeometry.h>
#import <MapsIndoorsSDK/MPLoadIndicator.h>
#import <MapsIndoorsSDK/MPLocation.h>
#import <MapsIndoorsSDK/MPLocationDataset.h>
#import <MapsIndoorsSDK/MPLocationDisplayRule.h>
#import <MapsIndoorsSDK/MPLocationDisplayRuleset.h>
#import <MapsIndoorsSDK/MPLocationProperty.h>
#import <MapsIndoorsSDK/MPLocationPropertyTableCell.h>
#import <MapsIndoorsSDK/MPLocationPropertyView.h>
#import <MapsIndoorsSDK/MPLocationsProvider.h>
#import <MapsIndoorsSDK/MPLocationTableViewController.h>
#import <MapsIndoorsSDK/MPLocationView.h>
#import <MapsIndoorsSDK/MPMapControl.h>
#import <MapsIndoorsSDK/MPMapStyle.h>
#import <MapsIndoorsSDK/MPOnlineTileLayer.h>
#import <MapsIndoorsSDK/MPOpeningHours.h>
#import <MapsIndoorsSDK/MPOpeningHoursModule.h>
#import <MapsIndoorsSDK/MPPoint.h>
#import <MapsIndoorsSDK/MPRouteStep.h>
#import <MapsIndoorsSDK/MPRoute.h>
#import <MapsIndoorsSDK/MPRouteInfo.h>
#import <MapsIndoorsSDK/MPRouteLeg.h>
#import <MapsIndoorsSDK/MPRoutingControl.h>
#import <MapsIndoorsSDK/MPRoutingProvider.h>
#import <MapsIndoorsSDK/MPSite.h>
#import <MapsIndoorsSDK/MPTokenSet.h>
#import <MapsIndoorsSDK/MPUIViewController.h>
#import <MapsIndoorsSDK/MPURITemplate.h>
#import <MapsIndoorsSDK/MPVector.h>
#import <MapsIndoorsSDK/MPVenue.h>
#import <MapsIndoorsSDK/MPVenueCollection.h>
#import <MapsIndoorsSDK/MPVenueProvider.h>
#import <MapsIndoorsSDK/NSString+FontAwesome.h>
#import <MapsIndoorsSDK/NSURL+QueryParser.h>
#import <MapsIndoorsSDK/UIFont+FontAwesome.h>
#import <MapsIndoorsSDK/UIFont+RegisterURL.h>
#import <MapsIndoorsSDK/MPLocationQuery.h>
#import <MapsIndoorsSDK/MPMapExtend.h>
#import <MapsIndoorsSDK/MPPositionProvider.h>
#import <MapsIndoorsSDK/MPBeaconPositionProvider.h>
#import <MapsIndoorsSDK/MPDistanceMatrixProvider.h>
#import <MapsIndoorsSDK/MPDirectionsService.h>
#import <MapsIndoorsSDK/MPImageRenderer.h>
#import <MapsIndoorsSDK/MPDirectionsRenderer.h>
#import <MapsIndoorsSDK/MPMapRouteLegButton.h>
#import <MapsIndoorsSDK/MPMyLocationButton.h>
#import <MapsIndoorsSDK/MPBeacon.h>
#import <MapsIndoorsSDK/MPDouble.h>
#import <MapsIndoorsSDK/PositionCalculator.h>

#import <MapsIndoorsSDK/FAImageView.h>
#import <MapsIndoorsSDK/MPBeaconCollection.h>
#import <MapsIndoorsSDK/MPBuildingCollection.h>
#import <MapsIndoorsSDK/MPBuildingReference.h>
#import <MapsIndoorsSDK/MPMapButtonControl.h>
#import <MapsIndoorsSDK/MPRouteInstructions.h>
#import <MapsIndoorsSDK/MPRouteResult.h>
#import <MapsIndoorsSDK/NSString+CustomFont.h>
#import <MapsIndoorsSDK/UIFont+CustomFont.h>


