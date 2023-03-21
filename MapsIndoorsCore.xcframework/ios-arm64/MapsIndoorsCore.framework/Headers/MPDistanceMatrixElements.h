#import <Foundation/Foundation.h>
#import "MPRoutePropertyInternal.h"
#import "JSONModel.h"

@protocol MPDistanceMatrixElements
@end

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDistanceMatrixElements : JSONModel

@property (nonatomic, strong, nullable) MPRoutePropertyInternal* distance;
@property (nonatomic, strong, nullable) MPRoutePropertyInternal* duration;
@property (nonatomic, strong, nullable) NSString* status;

@end
