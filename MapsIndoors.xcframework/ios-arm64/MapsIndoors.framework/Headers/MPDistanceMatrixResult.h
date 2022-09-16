#import <Foundation/Foundation.h> 
#import "JSONModel.h"
#import "MPDistanceMatrixRows.h"

@interface MPDistanceMatrixResult : JSONModel

@property (nonatomic, strong, nullable) NSArray* destination_addresses;
@property (nonatomic, strong, nullable) NSArray* origin_addresses;
@property (nonatomic, strong, nullable) NSArray<MPDistanceMatrixRows*><MPDistanceMatrixRows>* rows;
@property (nonatomic, strong, nullable) NSString* status;
@property (nonatomic, strong, nullable) NSString<Optional>* venue;
@property (nonatomic, strong, nullable) NSString<Optional>* bestOrigin;
@property (nonatomic, strong, nullable) NSString<Optional>* bestDestination;
@property (nonatomic, strong, nullable) NSObject<Optional>* provider;

@end
