#import <Foundation/Foundation.h> 
#import <JSONModel/JSONModel.h>
#import "MPDistanceMatrixRows.h"

@interface MPDistanceMatrixResult : JSONModel

@property (strong) NSArray* destination_addresses;
@property (strong) NSArray* origin_addresses;
@property (strong) NSArray<MPDistanceMatrixRows>* rows;
@property (strong) NSString* status;
@property (strong) NSString<Optional>* venue;
@property (strong) NSString<Optional>* bestOrigin;
@property (strong) NSString<Optional>* bestDestination;
@property (strong) NSObject<Optional>* provider;

@end