//
//  MPJSONModelError.h
//  MPJSONModel
//

#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////////////////////
typedef NS_ENUM(int, kMPJSONModelErrorTypes)
{
    kMPJSONModelErrorInvalidData = 1,
    kMPJSONModelErrorBadResponse = 2,
    kMPJSONModelErrorBadJSON = 3,
    kMPJSONModelErrorModelIsInvalid = 4,
    kMPJSONModelErrorNilInput = 5
};

/////////////////////////////////////////////////////////////////////////////////////////////
/** The domain name used for the MPJSONModelError instances */
extern NSString *const MPJSONModelErrorDomain;

/**
 * If the model JSON input misses keys that are required, check the
 * userInfo dictionary of the MPJSONModelError instance you get back -
 * under the kMPJSONModelMissingKeys key you will find a list of the
 * names of the missing keys.
 */
extern NSString *const kMPJSONModelMissingKeys;

/**
 * If JSON input has a different type than expected by the model, check the
 * userInfo dictionary of the MPJSONModelError instance you get back -
 * under the kMPJSONModelTypeMismatch key you will find a description
 * of the mismatched types.
 */
extern NSString *const kMPJSONModelTypeMismatch;

/**
 * If an error occurs in a nested model, check the userInfo dictionary of
 * the MPJSONModelError instance you get back - under the kMPJSONModelKeyPath
 * key you will find key-path at which the error occurred.
 */
extern NSString *const kMPJSONModelKeyPath;

/////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Custom NSError subclass with shortcut methods for creating
 * the common MPJSONModel errors
 */
@interface MPJSONModelError : NSError

@property (strong, nonatomic) NSHTTPURLResponse *httpResponse;

@property (strong, nonatomic) NSData *responseData;

/**
 * Creates a MPJSONModelError instance with code kMPJSONModelErrorInvalidData = 1
 */
+ (id)errorInvalidDataWithMessage:(NSString *)message;

/**
 * Creates a MPJSONModelError instance with code kMPJSONModelErrorInvalidData = 1
 * @param keys a set of field names that were required, but not found in the input
 */
+ (id)errorInvalidDataWithMissingKeys:(NSSet *)keys;

/**
 * Creates a MPJSONModelError instance with code kMPJSONModelErrorInvalidData = 1
 * @param mismatchDescription description of the type mismatch that was encountered.
 */
+ (id)errorInvalidDataWithTypeMismatch:(NSString *)mismatchDescription;

/**
 * Creates a MPJSONModelError instance with code kMPJSONModelErrorBadResponse = 2
 */
+ (id)errorBadResponse;

/**
 * Creates a MPJSONModelError instance with code kMPJSONModelErrorBadJSON = 3
 */
+ (id)errorBadJSON;

/**
 * Creates a MPJSONModelError instance with code kMPJSONModelErrorModelIsInvalid = 4
 */
+ (id)errorModelIsInvalid;

/**
 * Creates a MPJSONModelError instance with code kMPJSONModelErrorNilInput = 5
 */
+ (id)errorInputIsNil;

/**
 * Creates a new MPJSONModelError with the same values plus information about the key-path of the error.
 * Properties in the new error object are the same as those from the receiver,
 * except that a new key kMPJSONModelKeyPath is added to the userInfo dictionary.
 * This key contains the component string parameter. If the key is already present
 * then the new error object has the component string prepended to the existing value.
 */
- (instancetype)errorByPrependingKeyPathComponent:(NSString *)component;

/////////////////////////////////////////////////////////////////////////////////////////////
@end
