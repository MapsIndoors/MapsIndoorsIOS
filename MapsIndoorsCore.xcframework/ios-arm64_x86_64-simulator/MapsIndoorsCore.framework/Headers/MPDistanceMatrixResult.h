#import <Foundation/Foundation.h> 
#import "JSONModel.h"
#import "MPDistanceMatrixRows.h"

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDistanceMatrixResult : JSONModel

@property (nonatomic, strong, nullable) NSArray* destination_addresses;
@property (nonatomic, strong, nullable) NSArray* origin_addresses;
@property (nonatomic, strong, nullable) NSArray<MPDistanceMatrixRows*><MPDistanceMatrixRows>* rows;
@property (nonatomic, strong, nullable) NSString* status;
@property (nonatomic, strong, nullable) NSString* venue;
@property (nonatomic, strong, nullable) NSString* bestOrigin;
@property (nonatomic, strong, nullable) NSString* bestDestination;
@property (nonatomic, strong, nullable) NSObject* provider;

@end
