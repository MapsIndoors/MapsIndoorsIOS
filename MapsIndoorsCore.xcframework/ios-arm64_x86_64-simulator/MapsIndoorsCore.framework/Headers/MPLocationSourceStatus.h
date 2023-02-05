
#import <Foundation/Foundation.h>

/**
 * Available      Available status. The location source is expected to provide data but may not have data from all data sources yet;
 * Unavailable    unavailable but expected to provide data under normal circumstances;
 * Initialising   processing and expected to provide data when initialised;
 * Inactive       intentionally inactive and not expected to provide data;
 * Complete       The location service is ready to be used;
 */

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
typedef NS_ENUM(NSInteger, MPLocationSourceStatus)
{
    MPLocationSourceStatusAvailable,
    MPLocationSourceStatusUnavailable,
    MPLocationSourceStatusInitialising,
    MPLocationSourceStatusInactive,
    MPLocationSourceStatusComplete
};
