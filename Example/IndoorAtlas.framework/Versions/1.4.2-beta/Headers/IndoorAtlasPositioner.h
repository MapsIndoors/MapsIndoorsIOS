// IndoorAtlas iOS SDK
// IndoorAtlasPositioner.h

#import <Foundation/Foundation.h>
#import <IndoorAtlas/IndoorAtlasTypes.h>
@class IndoorAtlasFloorplan;
@class IndoorAtlasPositioner;

/**
 * Enum defining all possible states of <IndoorAtlasPositioner> instance.
 */
typedef enum IndoorAtlasPositioningState {
    kIndoorAtlasPositioningStateStopped,
    kIndoorAtlasPositioningStateConnecting,
    kIndoorAtlasPositioningStateReconnecting,
    kIndoorAtlasPositioningStateConnected,
    kIndoorAtlasPositioningStateLoading,
    kIndoorAtlasPositioningStateReady,
    kIndoorAtlasPositioningStateWaitingForFix,
    kIndoorAtlasPositioningStatePositioning,
    kIndoorAtlasPositioningStateBuffering,
    kIndoorAtlasPositioningStateHeavyBuffering
} IndoorAtlasPositioningState;

/**
 * IndoorAtlasPositionerState represents state change information for <IndoorAtlasPositioner>.
 *
 * See the [positioning guide](../docs/3. Positioning.html) for a state diagram.
 */
@interface IndoorAtlasPositionerState : NSObject

/**
 * @name Get detailed information about the state
 */

/**
 * Current state of the <IndoorAtlasPositioner> instance.
 *
 * Possible values are:
 *
 *    - kIndoorAtlasPositioningStateStopped
 *
 *      Positioner is stopped and disconnected from the server.
 *      This state may emit at any time.
 *
 *    - kIndoorAtlasPositioningStateConnecting
 *
 *      Positioner is connecting to the positioning server.
 *      This state only emits when connecting first time to the server.
 *
 *    - kIndoorAtlasPositioningStateReconnecting,
 *
 *      Positioner is reconnecting to the positioning server.
 *      This state may emit when switching from WiFi -> Mobile network or because of network problem.
 *
 *    - kIndoorAtlasPositioningStateConnected
 *
 *      Positioner is connected to the positioning server. Connection has not been prepared.
 *      This state only emits when connected first time to the server.
 *
 *    - kIndoorAtlasPositioningStateLoading
 *
 *      Server is preparing for positioning.
 *      This state only emits when connected to the server.
 *
 *    - kIndoorAtlasPositioningStateReady
 *
 *      Positioner is ready to start positioning.
 *      This state only emits when prepared.
 *
 *    - kIndoorAtlasPositioningStateWaitingForFix
 *
 *      Positioner has sent first positiong query and is waiting for a location fix.
 *      This state only emits when started.
 *
 *    - kIndoorAtlasPositioningStatePositioning
 *
 *      Positioner is receiving and sending positioning data.
 *      This state only emits when positioning is active.
 *
 *    - kIndoorAtlasPositioningStateBuffering
 *
 *      Positioning data is being buffered at the client, most likely because of network problem.
 *      The connection may still recover from this state to positioning.
 *      This state may emit during positioning.
 *
 *    - kIndoorAtlasPositioningStateHeavyBuffering
 *
 *      Positioning data is being heavily buffered at the client, most likely becuase of severe network problem.
 *      The connection may still recover from this state to positioning.
 *      This state may emit during positioning.
 */
@property (nonatomic, readonly) IndoorAtlasPositioningState state;

/**
 * Error causing the state change, nil if no error.
 */
@property (nonatomic, readonly) NSError *error;

@end

/**
 * IndoorAtlasPosition represents position information received from <IndoorAtlasPositioner>.
 */
@interface IndoorAtlasPosition : NSObject

/**
 * @name Getting position in different coordinate systems
 */

/**
 * WGS84 coordinate of position.
 * Accuracy of this coordinate depends on the floor plan placement.
 */
@property (nonatomic, readonly) IndoorAtlasCoordinate coordinate;

/**
 * Provides x and y coordinates of the position estimate in meters. Origin is the top-left corner of the image that was used in mapping.
 */
@property (nonatomic, readonly) IndoorAtlasPoint metricPoint;

/**
 * Pixel point of position in current floor plan. Origin is the top-left corner of the image that was used in mapping.
 */
@property (nonatomic, readonly) IndoorAtlasPixel pixelPoint;

/**
 * @name Getting direction
 */

/**
 * Direction is measured in degrees relative to top of the image that was used in mapping.
 */
@property (nonatomic, readonly) IndoorAtlasDirection course;

/**
 * @name Getting radius
 */

/**
 * Uncertainty radius of position in meters. Larger radius means less accurate position.
 * Convert the radius to pixels by multiplying it with the floor plan conversion property.
 */
@property (nonatomic, readonly) double radius;

@end

/**
 * IndoorAtlasPositionerDelegate declares methods for communicating with <IndoorAtlasPositioner>.
 *
 * See the [positioning guide](../docs/3. Positioning.html) for an example how to use the indoor positioning API.
 */
@protocol IndoorAtlasPositionerDelegate <NSObject>
@optional

/**
 * @name Listening state changes
 */

/**
 * Positioning state changed.
 * Use this delegate method to handle positioner state changes and errors.
 *
 * @param positioner <IndoorAtlasPositioner> instance that emitted this delegate event.
 * @param state <IndoorAtlasPositionerState> instance containing state information and possible error.
 */
- (void)indoorAtlasPositioner:(IndoorAtlasPositioner*)positioner stateChanged:(IndoorAtlasPositionerState*)state;

/**
 * @name Listening position changes
 */

/**
 * Device position changed.
 *
 * @param positioner <IndoorAtlasPositioner> instance that emitted this delegate event.
 * @param position <IndoorAtlasPosition> instance containing position information.
 */
- (void)indoorAtlasPositioner:(IndoorAtlasPositioner*)positioner positionChanged:(IndoorAtlasPosition*)position;

@end

/**
 * Instance for positioner parameters.
 */
@interface IndoorAtlasPositionerParameters : NSObject

/**
 * Set motion mode.
 *
 * Possible values are:
 *
 *    - nil
 *
 *      Default positioner mode.
 *
 *    - "shopping_cart"
 *
 *      Motion mode for shopping cart.
 */
@property (nonatomic, assign) NSString  *motionMode;

@end

/**
 * IndoorAtlasPositioner provides API for starting and stopping the positioning session and requesting positioning events through <IndoorAtlasPositionerDelegate>.
 *
 * See the [positioning guide](../docs/3. Positioning.html) for an example how to use the indoor positioning API.
 */
@interface IndoorAtlasPositioner : NSObject

/**
 * @name Setting and Getting the Delegate
 */

/**
 * Set positioner delegate.
 *
 * @param delegate Instance implementing <IndoorAtlasPositionerDelegate>.
 */
@property (nonatomic, weak) id<IndoorAtlasPositionerDelegate> delegate;

/**
 * @name Getting the active floor plan object
 */

/**
 * Active <IndoorAtlasFloorplan> instance.
 */
@property (nonatomic, readonly) IndoorAtlasFloorplan *floorplan;

/**
 * @name Latency
 */

/**
 * Latest send-reply roundtrip to positioning server in milliseconds.
 * Latency is calculated only during positioning.
 *
 * Zero if positioning is not active.
 */
@property (nonatomic, readonly) float latency;

/**
 * @name Starting and stopping indoor positioning
 */

/**
 * Connect positioner to the positioning server. Connecting does not prepare or start positioning.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStateConnecting.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStateConnected.
 */
- (void)connect;

/**
 * Prepare positioning.
 * Positioning server loads map data and initializes positioning session.
 * Preparing does not start the positioning.
 *
 * This method will call connect automatically, if not already connected.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStateLoading.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStateReady.
 */
- (void)prepare;

/**
 * Prepare positioning with parameters.
 * Positioning server loads map data and initializes positioning session.
 * Preparing does not start the positioning.
 *
 * See <IndoorAtlasPositionerParameters> for parameters.
 *
 * This method will call connect automatically, if not already connected.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStateLoading.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStateReady.
 *
 * @param parameters Session initialization parameters.
 */
- (void)prepareWithParameters:(IndoorAtlasPositionerParameters*)parameters;

/**
 * Start indoor positioning.
 *
 * This method will call prepare automatically, if not already prepared.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStateWaitingForFix.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStatePositioning.
 *
 * Fake positioning data is used in simulator.
 */
- (void)start;

/**
 * Start indoor positioning with parameters.
 * Parameters will be ignored if the positioner has already been prepared.
 *
 * See <IndoorAtlasPositionerParameters> for parameters.
 *
 * This method will call prepare automatically, if not already prepared.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStateWaitingForFix.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStatePositioning.
 *
 * Fake positioning data is used in simulator.
 *
 * @param parameters Session initialization parameters.
 */
- (void)startWithParameters:(IndoorAtlasPositionerParameters*)parameters;

/**
 * Stop indoor positioning.
 *
 * This method will emit <[IndoorAtlasPositionerDelegate indoorAtlasPositioner:stateChanged:]> with kIndoorAtlasPositioningStateStopped.
 */
- (void)stop;

/**
 * @name Explicit position
 */

/**
 * Submit explicit pixel position on the floor plan image.
 *
 * @param pixel Pixel for position.
 * @param radius Defines easing value in pixels for the explicit position. Good value is 3 meters converted to pixels.
 */
- (void)submitExplicitPixelPosition:(IndoorAtlasPixel)pixel withRadius:(double)radius;

/**
 * Submit explicit metric position on the floor plan.
 *
 * @param metric Metric point for position.
 * @param radius Defines easing value in meters for the explicit position. Good value is 3 meters.
 */
- (void)submitExplicitMetricPosition:(IndoorAtlasPoint)metric withRadius:(double)radius;

/**
 * Submit explicit coordinate (WGS84) position to all active positioning sessions.
 *
 * Coordinate position accuracy depends on the floor plan placement.
 *
 * @param coordinate Coordinate for position.
 * @param radius Radius (accuracy) of the position in meters.
 */
- (void)submitExplicitCoordinatePosition:(IndoorAtlasCoordinate)coordinate withRadius:(double)radius;

@end

// vim: set ts=8 sw=4 tw=0 ft=objc :
