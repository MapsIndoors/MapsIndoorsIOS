//
//  MPDirectionsViewModel.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 02/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPDirectionsViewModel.h"
#import "MPDirectionsViewHeadlineModel.h"
#import "SectionModel.h"
#import "NSString+TRAVEL_MODE.h"
#import "UIColor+AppColor.h"
#import "UIColor+Comparison.h"
#import <VCMaterialDesignIcons/VCMaterialDesignIcons.h>
#import "LocalizedStrings.h"
#import "MPLocation+ReverseGeocoding.h"



@interface MPDirectionsViewModel ()

@property (nonatomic, strong) MPRoute*                      route;
@property (nonatomic, strong) RoutingData*                  routingData;
@property (nonatomic, strong) NSArray<SectionModel*>*       models;

@property (nonatomic) NSUInteger                            numberOfActionPoints;

@end


@implementation MPDirectionsViewModel

#pragma mark - Init

+ (instancetype) newWithRoute:(MPRoute*)route
                  routingData:(RoutingData*)routingData
                       models:(NSArray<SectionModel*>*)models
{
    return [[MPDirectionsViewModel alloc] initWithRoute:route routingData:routingData models:models];
}

- (instancetype) initWithRoute:(MPRoute*)route
                   routingData:(RoutingData*)routingData
                        models:(NSArray<SectionModel*>*)models
{
    self = [super init];
    if ( self ) {
        _route = route;
        _routingData = routingData;
        _models = models;
        _numberOfActionPoints = models.count + 1;
        _routeSegmentIndexShowingDirections = NSNotFound;
        _shouldShowInsideSteps = NO;
        
        [self transitAgenciesContributingToRoute];
    }
    return self;
}


#pragma mark - Action point support

- (NSString*) textForActionPointAtIndex:(NSUInteger)index {

    NSString*   text = @"";
    MPLocation* location = (index == 0)                              ? self.routingData.origin :
                           (index == (self.numberOfActionPoints -1)) ? self.routingData.destination :
                                                                       nil;
    
    if ( location ) {
        
        NSString*   addressForLocation = [Global getAddressForLocation:location];

        if ( location.venue ) {
            NSDictionary*   venueData = [MPVenueProvider getDataFromPoint:location.geometry];
            MPVenue*        venue     = [venueData objectForKey:@"venue"];
            MPBuilding*     building  = [venueData objectForKey:@"building"];
            NSString*       addressDetails = [location.venue copy];
            if ( venue ) {
                addressDetails = [venue.name copy];
                if (building && ![venue.name isEqualToString:building.name]) {
                    addressDetails = [NSString stringWithFormat:@"%@, %@", building.name, venue.name];
                }
                if ( location.floor ) {
                    SectionModel*       sectionModel = index == 0 ? self.models.firstObject : self.models.lastObject;
                    MPRouteLeg*         currentLeg = sectionModel.leg;
                    MPRouteCoordinate*  rc = (index == 0) ? currentLeg.start_location : currentLeg.end_location;

                    NSString*   floorString = [NSString stringWithFormat:kLangLevelVar, rc.floor_name ?: location.floor];
                    addressDetails = [floorString stringByAppendingFormat:@", %@", addressDetails];
                }
            }
            text = [[NSString stringWithFormat:@"%@ (%@)", [Global getAddressForLocation:location], addressDetails] stringByReplacingOccurrencesOfString:@"ESTIMATED: " withString:@""];
            
        } else {
            
            if ( location.mp_firstReverseGeocodedAddress.length ) {
                text = [NSString stringWithFormat:@"%@ (%@)", addressForLocation, location.mp_firstReverseGeocodedAddress];
            } else {
                text = addressForLocation;
            }
        }
        
    } else if ( (index > 0) && (index < self.models.count) ) {
        
        SectionModel*   sectionModel = self.models[index];
        MPRouteLeg*     currentLeg = sectionModel.leg;
        MPRouteStep*    currentStep  = [currentLeg.steps firstObject];
        SectionModel*   prevSectionModel = self.models[index-1];
        MPRouteLeg*     prevLeg = self.models[index-1].leg;
        
        if ( [sectionModel.step.travel_mode convertTo_TRAVEL_MODE] == TRANSIT ) {
            text = sectionModel.step.transit_details.departure_stop.name;

        } else if ( [prevSectionModel.step.travel_mode convertTo_TRAVEL_MODE] == TRANSIT ) {
            text = prevSectionModel.step.transit_details.arrival_stop.name;
            
        } else {
            
            switch ( [Global isEnter:currentLeg previousLeg:prevLeg] ) {
                case BuildingTransition_Enter:
                    text = [Global getBuildingLabelFromRouteLocation:currentLeg.end_location];
                    break;
                case BuildingTransition_Exit:
                    text = [Global getBuildingLabelFromRouteLocation:prevLeg.start_location];
                    break;
                case BuildingTransition_None:
                    break;
            }

            if ( text.length == 0 ) {
                
                if (sectionModel.travelMode == WALK && (prevSectionModel.travelMode == DRIVE || prevSectionModel.travelMode == BIKE)) {
                    text = sectionModel.leg.start_location.label;
                }
                else if ( [@[@"steps", @"elevator"] indexOfObject: currentStep.highway] != NSNotFound ) {
                    NSString*   fmt = NSLocalizedString(@"Level %@ to %@",);
                    text = [NSString stringWithFormat:fmt, currentStep.start_location.floor_name, currentStep.end_location.floor_name];
                }
            }
        }
    }
    
    return text;
}

- (NSString*) prefixTextForActionPointAtIndex:(NSUInteger)index {
    
    NSString*   text = nil;
    
    if ( index == 0 ) {
        text = NSLocalizedString(@"Start",);
    
    } else if ( index == (self.numberOfActionPoints -1) ) {
        text = NSLocalizedString(@"End",);
        
    } else {
        
        SectionModel*   sectionModel = self.models[index];
        MPRouteLeg*     currentLeg = sectionModel.leg;
        MPRouteStep*    currentStep  = [currentLeg.steps firstObject];
        SectionModel*   prevSectionModel = self.models[index-1];
        MPRouteLeg*     prevLeg = self.models[index-1].leg;
        
        if ( [sectionModel.step.travel_mode convertTo_TRAVEL_MODE] == TRANSIT ) {
            ;
            
        } else if ( [prevSectionModel.step.travel_mode convertTo_TRAVEL_MODE] == TRANSIT ) {
            ;
            
        } else {
            
            switch ( [Global isEnter:currentLeg previousLeg:prevLeg] ) {
                case BuildingTransition_Enter:
                    text = NSLocalizedString(@"Enter",);
                    break;
                case BuildingTransition_Exit:
                    text = NSLocalizedString(@"Exit",);
                    break;
                case BuildingTransition_None:
                    break;
            }
            
            if ( text.length == 0 ) {
                
                //Park
                if (sectionModel.travelMode == WALK && (prevSectionModel.travelMode == DRIVE || prevSectionModel.travelMode == BIKE)) {
                    text = NSLocalizedString(@"Park",);
                }
                else if ( currentStep.highway.length ) {
                    if ( [currentStep.highway isEqualToString:@"steps"] ) {
                        text = NSLocalizedString(@"Stairs",);
                    } else {    // "elevator", ...
                        text = [currentStep.highway localizedCapitalizedString];
                    }
                }
            }
        }
    }
    
    return text;
}

- (NSString*) imageNameForActionPointAtIndex:(NSUInteger)index {

    NSString*       imageName;
    
    if ( index == 0 ) {
        // No image for origin action point
        
    } else if ( index == (self.numberOfActionPoints -1) ) {
        // No image for destination action point
        
    } else {
        SectionModel*    currentSectionModel = self.models[index];
        SectionModel*    previousSectionModel = self.models[index-1];
        MPRouteLeg*     currentLeg  = currentSectionModel.leg;
        MPRouteLeg*     previousLeg = previousSectionModel.leg;
        
        if ( previousLeg ) {
            
            switch ([Global isEnter:currentLeg previousLeg:previousLeg] ) {
                case BuildingTransition_Enter:
                    imageName = @"enter64";
                    break;
                case BuildingTransition_Exit:
                    imageName = @"exit64";
                    break;
                case BuildingTransition_None:
                    break;
            }
            
            if (imageName == nil) {
                
                if (currentSectionModel.travelMode == WALK && (previousSectionModel.travelMode == DRIVE || previousSectionModel.travelMode == BIKE)) {
                    imageName = @"Parking";
                }
                
            }
            
        }
        
        if ( !imageName ) {
            
            MPRouteStep*    firstStep   = [currentLeg.steps firstObject];

            if ( [firstStep.highway isEqualToString:@"steps"] ) {
                imageName = @"stairs64";
                
            } else if ( [firstStep.highway isEqualToString:@"elevator"] ) {
                imageName = @"lift64";
            }
        }
    }
        
    return imageName;
}

- (UIColor*) colorForActionPointImageAtIndex:(NSUInteger)index {
    
    UIColor* actionPointColor = [self colorForRouteSectionAtIndex:index];
    
    if ( index > 0 ) {
        if ( [actionPointColor isEqual:[UIColor appPrimaryColor]] ) {
            actionPointColor  = [self colorForRouteSectionAtIndex:index -1];
        }
    }
    
    return actionPointColor;
}


#pragma mark - Route sections

- (RouteSectionType) routeSectionTypeForSectionAtIndex:(NSUInteger)index {
    
    SectionModel*       section     = self.models[index];
    RouteSectionType    sectionType = RouteSectionType_Unknown;
    MPRouteStep*        currentStep = section.step;
    TRAVEL_MODE         effectiveTravelMode = currentStep ? [currentStep.travel_mode convertTo_TRAVEL_MODE] : section.travelMode;
    
    if ( (section.legType == MPRouteLegTypeMapsIndoors) && ([@"OutsideOnVenue" isEqualToString:currentStep.routeContext] == NO) ) {
        effectiveTravelMode = [currentStep.travel_mode convertTo_TRAVEL_MODE];
    }

    switch ( effectiveTravelMode ) {
        case WALK:
            sectionType = section.isOutside ? RouteSectionType_Dots : RouteSectionType_LineNarrow;
            break;
        case BIKE:
        case DRIVE:
            sectionType = RouteSectionType_LineMedium;
            break;
        case TRANSIT:
            switch ( section.legType ) {
                case MPRouteLegTypeGoogle:
                    sectionType = [section.step.travel_mode convertTo_TRAVEL_MODE] == WALK ? RouteSectionType_Dots : RouteSectionType_LineWide;
                    break;
                case MPRouteLegTypeMapsIndoors:
                    sectionType = RouteSectionType_LineNarrow;
                    break;
            }
            break;
    }
    
    return sectionType;
}

- (UIColor*) colorForRouteSectionAtIndex:(NSUInteger)index {

    UIColor*        sectionColor = [UIColor appPrimaryColor];
    SectionModel*   section      = self.models[index];
    
    if ( [self.routingData.travelMode convertTo_TRAVEL_MODE] == TRANSIT ) {
        if ( section.legType == MPRouteLegTypeGoogle ) {
            if ( section.step.transit_details.line.color ) {
                sectionColor = [UIColor colorFromHexString:section.step.transit_details.line.color];
                if ( [sectionColor isWhiteColor] ) {
                    sectionColor = [UIColor colorWithWhite:0.9 alpha:1];;
                }
            }
        }
    }
    
    return sectionColor;
}

- (MPDirectionsViewHeadlineModel*) headlineModelForSectionAtIndex:(NSUInteger)index {
   
    MPDirectionsViewHeadlineModel*  headlineModel;
    
    if ( index < self.models.count ) {
        
        headlineModel = [MPDirectionsViewHeadlineModel new];
        
        SectionModel*   sectionModel = self.models[index];
        MPRouteLeg*     currentLeg = sectionModel.leg;
        MPRouteStep*    currentStep = sectionModel.step;
        TRAVEL_MODE     effectiveTravelMode = currentStep ? [currentStep.travel_mode convertTo_TRAVEL_MODE] : sectionModel.travelMode;
        
        if ( (sectionModel.legType == MPRouteLegTypeMapsIndoors) && ([@"OutsideOnVenue" isEqualToString:currentStep.routeContext] == NO) ) {
            currentStep = currentLeg.steps.firstObject;
            effectiveTravelMode = [currentStep.travel_mode convertTo_TRAVEL_MODE];
        }
        
        headlineModel.iconColor = [UIColor appSecondaryTextColor];
        
        switch ( effectiveTravelMode ) {
            case TRANSIT:
                headlineModel.text = currentStep.transit_details.line.short_name;
                headlineModel.textColor = currentStep.transit_details.line.text_color ? [UIColor colorFromHexString:currentStep.transit_details.line.text_color] : [UIColor whiteColor];
                headlineModel.color = currentStep.transit_details.line.color ? [UIColor colorFromHexString:currentStep.transit_details.line.color] : [UIColor grayColor];
                if ( [headlineModel.color isWhiteColor] ) {
                    headlineModel.color = [UIColor colorWithWhite:0.9 alpha:1];
                    headlineModel.textColor = [UIColor blackColor];
                }
                headlineModel.materialDesignIconCode = VCMaterialDesignIconCode.md_bus;
                if ( currentStep.transit_details.line.vehicle.local_icon ) {
                    headlineModel.imageUrl = [NSString stringWithFormat:@"https:%@", currentStep.transit_details.line.vehicle.local_icon];
                }
                
                headlineModel.primaryTextRight = currentStep.transit_details.headsign;
                headlineModel.detailText = [NSString stringWithFormat:kLangTransitStopsFmt, [currentStep.transit_details.num_stops intValue], [Global getDurationString:[currentStep.duration doubleValue]]];
                headlineModel.detailTextColor = [UIColor darkGrayColor];
                break;
                
            case WALK:
                headlineModel.materialDesignIconCode = VCMaterialDesignIconCode.md_walk;
                break;
                
            case BIKE:
                headlineModel.materialDesignIconCode = VCMaterialDesignIconCode.md_bike;
                break;
                
            case DRIVE:
                headlineModel.materialDesignIconCode = VCMaterialDesignIconCode.md_car;
                break;
        }
        
        if ( [currentStep.travel_mode convertTo_TRAVEL_MODE] != TRANSIT ) {
            
            BOOL    canExpand = YES;
            double  distance, duration;
            
            if ( sectionModel.legType == MPRouteLegTypeMapsIndoors ) {
                distance = [currentLeg.distance doubleValue];
                duration = [currentLeg.duration doubleValue];
                canExpand = self.shouldShowInsideSteps || sectionModel.isOutside;
            } else {
                distance = currentStep ? [currentStep.distance doubleValue] : [currentLeg.distance doubleValue];
                duration = currentStep ? [currentStep.duration doubleValue] : [currentLeg.duration doubleValue];

                if ( currentStep && ([currentStep.travel_mode convertTo_TRAVEL_MODE] == TRANSIT) ) {
                    canExpand = NO;
                }
            }
            
            headlineModel.travelModeText = [Global getTravelModeString:effectiveTravelMode];
            headlineModel.primaryTextRight = [NSString stringWithFormat:@"%@ (%@)", [Global getDistanceString:distance], [Global getDurationString:duration]];
            
            if ( canExpand ) {
                headlineModel.detailText = (index != self.routeSegmentIndexShowingDirections) ? NSLocalizedString(@"▼ Directions",) : NSLocalizedString(@"▲ Directions",);
                headlineModel.detailTextColor = [UIColor appTertiaryHighlightColor];
            }
        }
    }
    
    return headlineModel;
}


#pragma mark - Directions

- (BOOL) isDirectionsAvailableForRouteSegmentAtIndex:(NSUInteger)routeSegmentIndex {
    
    BOOL            directionsAvailable = NO;
    
    if ( (routeSegmentIndex) < self.models.count ) {
        
        SectionModel*   sectionModel = self.models[routeSegmentIndex];
        MPRouteStep*    currentStep = sectionModel.step;
        
        if ( [currentStep.travel_mode convertTo_TRAVEL_MODE] != TRANSIT ) {
            
            directionsAvailable = YES;
            
            if ( sectionModel.legType == MPRouteLegTypeMapsIndoors ) {
                directionsAvailable = self.shouldShowInsideSteps || sectionModel.isOutside;
            } else {
                if ( currentStep && ([currentStep.travel_mode convertTo_TRAVEL_MODE] == TRANSIT) ) {
                    directionsAvailable = NO;
                }
            }
        }
    }
    
    return directionsAvailable;
}

- (NSArray<MPRouteStep*>*) stepsForRouteSegmentAtIndex:(NSUInteger)routeSegmentIndex {

    NSArray<MPRouteStep*>*  steps;
    
    if ( [self isDirectionsAvailableForRouteSegmentAtIndex:routeSegmentIndex] ) {
        
        SectionModel*   sectionModel = self.models[routeSegmentIndex];
        MPRouteLeg*     leg = sectionModel.leg;
        MPRouteStep*    step = sectionModel.step;
        
        if ( [Global.routingData.travelMode convertTo_TRAVEL_MODE] == TRANSIT ) {
            
            steps = (step.steps == nil) ? leg.steps : step.steps;
        }
        else
        {
            steps = leg.steps;
        }
    }

    return steps;
}

- (void) setRouteSegmentIndexShowingDirections:(NSUInteger)routeSegmentIndexShowingDirections {

    if ( [self isDirectionsAvailableForRouteSegmentAtIndex:routeSegmentIndexShowingDirections] == NO ) {
        routeSegmentIndexShowingDirections = NSNotFound;
    }
    
    if ( _routeSegmentIndexShowingDirections != routeSegmentIndexShowingDirections ) {
        _routeSegmentIndexShowingDirections = routeSegmentIndexShowingDirections;
    }
}


#pragma mark - Transit agency information

- (void) addAgencies:(NSArray<MPTransitAgency*>*)agencies toDict:(NSMutableDictionary<NSString*,MPTransitAgency*>*)agenciesDict {

    for ( MPTransitAgency* agency in agencies ) {
        NSString*   agencyKey = [NSString stringWithFormat:@"%@\n%@\n%@", agency.name, agency.url, agency.phone];
        
        if ( [agenciesDict objectForKey:agencyKey] == nil ) {
            agenciesDict[ agencyKey ] = agency;
        }
    }
}

- (NSArray<MPTransitAgency*>*) transitAgenciesContributingToRoute {
    
    NSMutableDictionary<NSString*,MPTransitAgency*>*     agencies = [NSMutableDictionary dictionary];
    
    for ( SectionModel* sectionModel in self.models ) {
        
        if ( sectionModel.step.transit_details.line.agencies.count ) {
            [self addAgencies:sectionModel.step.transit_details.line.agencies toDict:agencies];
        }
        
        for ( MPRouteStep* step in sectionModel.leg.steps ) {
            if ( step.transit_details.line.agencies.count ) {
                [self addAgencies:step.transit_details.line.agencies toDict:agencies];
            }
        }
    }
    
    NSArray<MPTransitAgency*>*  result = [agencies.allValues sortedArrayUsingComparator:^NSComparisonResult(MPTransitAgency* _Nonnull obj1, MPTransitAgency* _Nonnull obj2) {
        return [obj1.name caseInsensitiveCompare:obj2.name];
    }];
    
    return result;
}

#pragma mark - Overall route info

- (NSArray<NSNumber*>*) travelModes {
    
    NSMutableSet*   modes = [NSMutableSet set];

    for ( int ix=0; ix < self.models.count; ++ix ) {
        
        SectionModel*       section     = self.models[ix];
        MPRouteLeg*         currentLeg  = section.leg;
        MPRouteStep*        currentStep = section.step;
        TRAVEL_MODE         effectiveTravelMode = currentStep ? [currentStep.travel_mode convertTo_TRAVEL_MODE] : section.travelMode;

        if ( (section.legType == MPRouteLegTypeMapsIndoors) && ([@"OutsideOnVenue" isEqualToString:currentStep.routeContext] == NO) ) {
            currentStep = currentLeg.steps.firstObject;
            effectiveTravelMode = [currentStep.travel_mode convertTo_TRAVEL_MODE];
        }
        
        [modes addObject:@(effectiveTravelMode)];

    }
    return [modes allObjects];
}


#pragma mark - Accessibility

- (NSString*) accessibilityDescriptionForTravelModeAtRouteSectionIndex:(NSUInteger)index {
    
    NSString*  s;
    
    if ( index < self.models.count ) {
        
        SectionModel*   sectionModel = self.models[index];
        MPRouteLeg*     currentLeg = sectionModel.leg;
        MPRouteStep*    currentStep = sectionModel.step;
        TRAVEL_MODE     effectiveTravelMode = currentStep ? [currentStep.travel_mode convertTo_TRAVEL_MODE] : sectionModel.travelMode;
        NSString*       travelModeString;
        
        if ( (sectionModel.legType == MPRouteLegTypeMapsIndoors) && ([@"OutsideOnVenue" isEqualToString:currentStep.routeContext] == NO) ) {
            currentStep = currentLeg.steps.firstObject;
            effectiveTravelMode = [currentStep.travel_mode convertTo_TRAVEL_MODE];
        }

        switch ( effectiveTravelMode ) {
            case TRANSIT:
                s = [NSString stringWithFormat: kLangRouteSectionDescrPublicTransportAccLabel
                                              , currentStep.transit_details.num_stops
                                              , currentStep.transit_details.headsign
                                              , currentStep.transit_details.line.short_name
                                              ];
                break;

            case WALK:
                travelModeString = kLangRouteSectionDescrWalkAccLabel;
                break;

            case BIKE:
                travelModeString = kLangRouteSectionDescrCycleccLabel;
                break;

            case DRIVE:
                travelModeString = kLangRouteSectionDescrDriveAccLabel;
                break;
        }
        
        if ( [currentStep.travel_mode convertTo_TRAVEL_MODE] != TRANSIT ) {
            
            double  distance, duration;
            
            if ( sectionModel.legType == MPRouteLegTypeMapsIndoors ) {
                distance = [currentLeg.distance doubleValue];
                duration = [currentLeg.duration doubleValue];
            } else {
                distance = sectionModel.travelMode != TRANSIT ? [currentLeg.distance doubleValue] : [currentStep.distance doubleValue];
                duration = sectionModel.travelMode != TRANSIT ? [currentLeg.duration doubleValue] : [currentStep.duration doubleValue];
            }
            
            s = [NSString stringWithFormat:@"%@ %@", travelModeString, [Global getDistanceString:distance]];
        }
    }
    
    return [s copy];
}

- (NSString*) accessibilityDescriptionForRouteSectionAtIndex:(NSUInteger)index {
    
    NSMutableString*    s = [NSMutableString string];
    NSString*           actionPointText = [self textForActionPointAtIndex:index];
    NSString*           nextActionPointText = ((index+1) < self.numberOfActionPoints) ? [self textForActionPointAtIndex:index+1] : nil;

    if ( index == 0 ) {
        [s appendFormat:kLangStartRouteFromAccLabel, actionPointText];
    } else {
        [s appendFormat:kLangContinueRouteFromAccLabel, actionPointText];
    }
    
    if ( index < (self.models.count -1) ) {
        [s appendFormat:kLangContinueRouteAgainstAccLabel, nextActionPointText];
    } else {
        [s appendFormat:kLangContinueRouteAgainstDestAccLabel, nextActionPointText];
    }
    
    NSString*   travelDescr = [self accessibilityDescriptionForTravelModeAtRouteSectionIndex:index];
    if ( travelDescr.length) {
        [s appendFormat:@"%@, ", travelDescr];
    }
    
    return [s copy];
}

@end
