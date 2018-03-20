#import <Foundation/Foundation.h> 
#import "MPJSONModel.h"
#import "MPDistanceMatrixRows.h"

@interface MPDistanceMatrixResult : MPJSONModel

@property (strong) NSArray* destination_addresses;
@property (strong) NSArray* origin_addresses;
@property (strong) NSArray<MPDistanceMatrixRows*><MPDistanceMatrixRows>* rows;
@property (strong) NSString* status;
@property (strong) NSString<Optional>* venue;
@property (strong) NSString<Optional>* bestOrigin;
@property (strong) NSString<Optional>* bestDestination;
@property (strong) NSObject<Optional>* provider;

@end
