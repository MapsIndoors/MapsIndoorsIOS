//
//  MPRoutingControl.h
//  Indoor
//
//  Created by Daniel Nielsen on 10/10/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDefines.h"
#import "MPRouteStep.h"
#import "MPRoute.h"
#import "MPInfoSnippetView.h"

/**
 Delegate protocol
 */
MP_DEPRECATED_ATTRIBUTE
@protocol MPRouteActionDelegate <NSObject>

/**
 Event method that fires when an route action is performed.
 @param  The route action.
 */
@required
- (void) onRouteActionPerform: (nonnull MPRouteStep*)action;
- (void) onRouteActionDisplay: (nonnull MPRouteStep*)action;
- (void) onRouteEnd;
@end


MP_DEPRECATED_ATTRIBUTE
@interface MPRoutingControl : UIView

@property (nonatomic, weak, nullable) id <MPRouteActionDelegate> delegate;
@property (nonatomic) int currentActionIndex;
@property (nonatomic) int currentRouteLegIndex;
@property (nonatomic, strong, nullable) MPRoute* route;
@property (nonatomic, strong, nullable) UIView* parent;
@property (nonatomic, strong, nullable) UIButton* nextButton;
@property (nonatomic, strong, nullable) UIButton* cancelButton;
@property (nonatomic, strong, nullable) MPInfoSnippetView* infoView;
@property (nonatomic, strong, nullable) MPLocation* destination;
@property (nonatomic) int currentTotalDistance;
@property (nonatomic, strong, nullable) NSMutableArray* actionLocations;
@property (nonatomic, strong, nullable) NSMutableArray* actions;
@property (nonatomic, strong, nullable) MPLocation* currentActionLocation;
@property (nonatomic, strong, nullable) GMSMapView* map;

+ (nullable UIImage*) actionIcon;
+ (void) setActionIcon:(nullable UIImage*)value;

- (nullable instancetype) initOnMap:(nonnull GMSMapView*)map;
- (nullable instancetype)initOnView:(nonnull UIView*)view;

- (void)addToView:(nonnull UIView*)view;
- (void)turnByTurn:(nonnull MPRoute*)route;
- (void)routeOverview:(nonnull MPRoute*)route;
- (void)routeOverview:(nonnull MPRoute*)route floor:(nullable NSNumber*)floor;
- (void)notifyNewTurn:(nonnull id)caller;
- (void)doTurn;
- (void)doTurn:(int)positionIndex;
- (void)showAction:(nonnull MPRouteStep*)action;
- (void)showActionByMarker:(nonnull GMSMarker*)marker;
- (void)close;
- (nullable MPRouteStep*)getAction:(int)positionIndex routeLegIndex:(int)legIndex;

@end
