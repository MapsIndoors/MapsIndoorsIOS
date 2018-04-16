//
//  MPDirectionsViewModel.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 02/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class MPRoute;
@class MPRouteStep;
@class RoutingData;
@class SectionModel;
@class MPDirectionsViewHeadlineModel;
@class MPTransitAgency;


typedef NS_ENUM(NSUInteger, RouteSectionType) {
    RouteSectionType_Unknown,
    
    RouteSectionType_Dots,
    RouteSectionType_LineNarrow,
    RouteSectionType_LineMedium,
    RouteSectionType_LineWide
};


@interface MPDirectionsViewModel : NSObject

+ (instancetype) newWithRoute:(MPRoute*)route
                  routingData:(RoutingData*)routingData
                       models:(NSArray<SectionModel*>*)models
                   originType:(NSString*)originType
              destinationType:(NSString*)destinationType;

- (instancetype) initWithRoute:(MPRoute*)route
                   routingData:(RoutingData*)routingData
                        models:(NSArray<SectionModel*>*)models
                    originType:(NSString*)originType
               destinationType:(NSString*)destinationType;

- (instancetype) init NS_UNAVAILABLE;


#pragma mark - Action point support

- (NSString*) textForActionPointAtIndex:(NSUInteger)index;
- (NSString*) prefixTextForActionPointAtIndex:(NSUInteger)index;
- (NSString*) imageNameForActionPointAtIndex:(NSUInteger)index;
- (UIColor*) colorForActionPointImageAtIndex:(NSUInteger)index;


#pragma mark - Route sections

- (RouteSectionType) routeSectionTypeForSectionAtIndex:(NSUInteger)index;
- (UIColor*) colorForRouteSectionAtIndex:(NSUInteger)index;
- (MPDirectionsViewHeadlineModel*) headlineModelForSectionAtIndex:(NSUInteger)index;


#pragma mark - Directions

- (BOOL) isDirectionsAvailableForRouteSegmentAtIndex:(NSUInteger)routeSegmentIndex;
- (NSArray<MPRouteStep*>*) stepsForRouteSegmentAtIndex:(NSUInteger)routeSegmentIndex;
@property (nonatomic) NSUInteger    routeSegmentIndexShowingDirections;


#pragma mark - Transit agency information

- (NSArray<MPTransitAgency*>*) transitAgenciesContributingToRoute;

@end

