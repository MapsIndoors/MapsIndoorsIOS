//
//  MPDirectionsView.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 01/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPRoute;
@class RoutingData;
@class SectionModel;
@protocol MPDirectionsViewDelegate;
@class MPTransitAgency;


@interface MPDirectionsView : UIView

@property (nonatomic, weak) id<MPDirectionsViewDelegate>    delegate;

@property (nonatomic, strong) UIView*                       headerViewInVerticalMode;     // "table" header (used in vertical mode only)
@property (nonatomic, strong) NSArray<UIAccessibilityElement*>*             headerAccessibilityElementsInVerticalMode;

@property (nonatomic) BOOL                                  verticalLayout;
@property (nonatomic, weak, readonly) UIScrollView*         scrollView;

@property (nonatomic) int                                   heightInHorizontalMode;
@property (nonatomic) int                                   widthInVerticalMode;

@property (nonatomic) CGSize                                actionPointSize;
@property (nonatomic) int                                   verticalLegHeight;
@property (nonatomic) int                                   horizontalLegWidth;

@property (nonatomic) CGSize                                sizeFittingRoute;

@property (nonatomic) NSUInteger                            focusedRouteSegment;
@property (nonatomic) BOOL                                  canFocusNextRouteSegment;
@property (nonatomic) BOOL                                  canFocusPrevRouteSegment;
@property (nonatomic) BOOL                                  shouldDimNonFocusedRouteSegments;
@property (nonatomic) BOOL                                  shouldHighlightFocusedRouteSegment;
@property (nonatomic) NSUInteger                            numberOfRouteSegments;
@property (nonatomic, strong) NSString*                     accessibilityLabelForFocusedRouteSegment;
- (NSString*) accessibilityLabelForRouteSegmentAtIndex:(NSUInteger)routeSegementIndex;

@property (nonatomic) BOOL                                  shouldShowInsideSteps;      /// Determine if steps are shown for indoor parts of the route.  Defaults to NO.


- (void) loadRoute:(MPRoute*)route
        withModels:(NSArray<SectionModel*>*)models
       routingData:(RoutingData*)routingData;

- (void) routeUpdated:(MPRoute*)route;

- (BOOL) focusNextRouteSegment;
- (BOOL) focusPrevRouteSegment;

- (void) toggleDirectionsDisplayForRouteSegment:(NSUInteger)routeSegmentIndex;
- (void) collapseDirectionsDisplayIfShowing;

- (NSArray<UIImage*>*) imagesForActionPoints;
- (NSArray<UIImage*>*) imagesForLegActionPoints;

- (NSArray<NSNumber*>*) travelModes;    // Really NSArray<TRAVEL_MODE>

- (void) onDynamicContentSizeChanged;

@end


@protocol MPDirectionsViewDelegate <NSObject>

@required
- (void) directionsView:(MPDirectionsView*)directionsView didSelectRouteSegmentAtIndex:(NSUInteger)index sectionModel:(SectionModel*)sectionModel;
- (void) directionsView:(MPDirectionsView*)directionsView didSelectDirectionsForRouteSegmentAtIndex:(NSUInteger)index sectionModel:(SectionModel*)sectionModel;
- (void) directionsView:(MPDirectionsView*)directionsView didChangeFocusedRouteSegment:(NSUInteger)routeSegmentIndex;

@optional
- (void) directionsView:(MPDirectionsView*)directionsView didRequestDisplayTransitSources:(NSArray<MPTransitAgency*>*)transitSources;

@end
