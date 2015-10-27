// IndoorAtlas iOS SDK
// IndoorAtlasErrors.h

/**
 * Error code constants.
 */
typedef enum IndoorAtlasErrorCode {
    kIndoorAtlasErrorRequestCanceled = 1,
    kIndoorAtlasErrorRequestTimedOut,
    kIndoorAtlasErrorBadResponse,
    kIndoorAtlasErrorBadRequest,
    kIndoorAtlasErrorContentUnavailable,
    kIndoorAtlasErrorServiceUnavailable,
    kIndoorAtlasErrorSDKVersionMismatch,
    kIndoorAtlasErrorPermissionDenied,
    kIndoorAtlasErrorInvalidCredentials,

    kIndoorAtlasErrorCalibrationFailed,

    kIndoorAtlasErrorNotCalibrated,
    kIndoorAtlasErrorCouldNotGetPosition,

    kIndoorAtlasErrorProxyAuthenticationUnsupported,

    kIndoorAtlasErrorNoNetwork = 1001,
    kIndoorAtlasErrorSensorError = 1002,
    kIndoorAtlasErrorLowSamplingRate = 1003,

    kIndoorAtlasErrorMapNotFound = 3003,
    kIndoorAtlasErrorNotSupported = 3005,

    kIndoorAtlasErrorUnknown = 0,
} IndoorAtlasErrorCode;

/* vim: set ts=8 sw=4 tw=0 ft=objc :*/
