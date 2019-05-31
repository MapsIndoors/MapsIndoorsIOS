
#import <Foundation/Foundation.h>

/**
 * Available      available and expected to provide data;
 * Unavailable    unavailable but expected to provide data under normal circumstances;
 * Initialising   processing and expected to provide data when initialised;
 * Inactive       intentionally inactive and not expected to provide data;
 */
typedef NS_ENUM(NSInteger, MPLocationSourceStatus)
{
    MPLocationSourceStatusAvailable,
    MPLocationSourceStatusUnavailable,
    MPLocationSourceStatusInactive,
    MPLocationSourceStatusInitialising,
};
