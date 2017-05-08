//
//  MPRoutingControl.h
//  Indoor
//
//  Created by Daniel Nielsen on 10/10/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPRouteStep.h"
#import "MPRoute.h"
#import "MPInfoSnippetView.h"

/**
 * Delegate protocol specification that specify an event method that fires when offline tile database is ready.
 */
@protocol MPRouteActionDelegate <NSObject>

/**
 * Event method that fires when an route action is performed.
 * @param The route action.
 */
@required
- (void) onRouteActionPerform: (MPRouteStep*)action;
- (void) onRouteActionDisplay: (MPRouteStep*)action;
- (void) onRouteEnd;
@end


@interface MPRoutingControl : UIView

@property (weak) id <MPRouteActionDelegate> delegate;
@property int currentActionIndex;
@property int currentRouteLegIndex;
@property MPRoute* route;
@property UIView* parent;
@property UIButton* nextButton;
@property UIButton* cancelButton;
@property MPInfoSnippetView* infoView;
@property MPLocation* destination;
@property int currentTotalDistance;
@property NSMutableArray* actionLocations;
@property NSMutableArray* actions;
@property MPLocation* currentActionLocation;
@property GMSMapView* map;

+ (UIImage*) actionIcon;
+ (void) setActionIcon:(UIImage*)value;

- (id)initOnMap:(GMSMapView*)map;
- (id)initOnView:(UIView*)view;

- (void)addToView:(UIView*)view;
- (void)turnByTurn:(MPRoute*)route;
- (void)routeOverview:(MPRoute*)route;
- (void)routeOverview:(MPRoute*)route floor:(NSNumber*)floor;
- (void)notifyNewTurn:(id)caller;
- (void)doTurn;
- (void)doTurn:(int)positionIndex;
- (void)showAction:(MPRouteStep*)action;
- (void)showActionByMarker:(GMSMarker*)marker;
- (void)close;
- (MPRouteStep*)getAction:(int)positionIndex routeLegIndex:(int)legIndex;

@end
