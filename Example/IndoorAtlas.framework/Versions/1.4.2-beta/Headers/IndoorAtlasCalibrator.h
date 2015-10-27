// IndoorAtlas iOS SDK
// IndoorAtlasCalibrator.h

#import <Foundation/Foundation.h>

/**
 * Enum defining all possible states of <IndoorAtlasBackgroundCalibratorDelegate> protocol.
 */
typedef enum IndoorAtlasBackgroundCalibratorState {
    kIndoorAtlasBackgroundCalibratorStateStopped,
    kIndoorAtlasBackgroundCalibratorStateRunning,
} IndoorAtlasBackgroundCalibratorState;

/**
 * Enum defining quality values for calibration.
 */
typedef enum IndoorAtlasCalibrationQuality {
    kIndoorAtlasCalibrationQualityPoor = 0,
    kIndoorAtlasCalibrationQualityOk,
    kIndoorAtlasCalibrationQualityExcellent,
} IndoorAtlasCalibrationQuality;

/**
 * IndoorAtlasBackgroundCalibratorDelegate is the communication protocol for background calibrator.
 *
 * See the [calibration guide](../docs/2. Calibration.html) for an example how to use the background calibrator API.
 */
@protocol IndoorAtlasBackgroundCalibratorDelegate <NSObject>
@optional

/**
 * @name Communication
 */

/**
 * Report background calibration state change.
 *
 * @param state State of the background calibration.
 *
 * Possible values are:
 *
 *    - kIndoorAtlasBackgroundCalibratorStatusStopped
 *
 *      Background calibration is stopped.
 *
 *    - kIndoorAtlasBackgroundCalibratorStatusRunning
 *
 *      Background calibration is running.
 */
- (void)indoorAtlasBackgroundCalibratorStateChanged:(IndoorAtlasBackgroundCalibratorState)state;

/**
 * Report background calibration quality change.
 *
 * @param quality Quality of the calibration.
 *
 * Possible values are:
 *
 *    - kIndoorAtlasCalibrationQualityPoor
 *    - kIndoorAtlasCalibrationQualityOk
 *    - kIndoorAtlasCalibrationQualityExcellent
 */
- (void)indoorAtlasBackgroundCalibratorQualityChanged:(IndoorAtlasCalibrationQuality)quality;

/**
 * Report background calibration progress.
 *
 * @param progress Background calibration progress (0..1).
 *
 * @warning Deprecated, use <indoorAtlasBackgroundCalibratorQualityChanged:> instead.
 */
- (void)indoorAtlasBackgroundCalibratorProgress:(float)progress __deprecated_msg("use indoorAtlasBackgroundCalibratorQuality: instead");

@end

/**
 * IndoorAtlasBackgroundCalibrator allows communication with the background calibration.
 *
 * See the [calibration guide](../docs/2. Calibration.html) for an example how to use the background calibrator API.
 */
@interface IndoorAtlasBackgroundCalibrator : NSObject

/**
 * @name Getting state
 */

/**
 * Current state of background calibrator.
 */
+ (IndoorAtlasBackgroundCalibratorState)state;

/**
 * Current quality of calibration.
 */
+ (IndoorAtlasCalibrationQuality)quality;

/**
 * @name Receiving background calibration events
 */

/**
 * Set background calibrator delegate.
 * There can be only single delegate listening to background calibrator events.
 *
 * When the delegate is set <[IndoorAtlasBackgroundCalibratorDelegate indoorAtlasBackgroundCalibratorStateChanged:]> will emit immediately with current state.
 *
 * @param delegate Instance that implements <IndoorAtlasBackgroundCalibratorDelegate>.
 */
+ (void)setDelegate:(id<IndoorAtlasBackgroundCalibratorDelegate>)delegate;

@end

/* vim: set ts=8 sw=4 tw=0 ft=objc :*/
