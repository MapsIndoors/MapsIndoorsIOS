#import <Foundation/Foundation.h>
#import "MPRouteProperty.h"
#import "JSONModel.h"

@protocol MPDistanceMatrixElements
@end

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDistanceMatrixElements : JSONModel
	@property (nonatomic, strong, nullable) MPRouteProperty<Optional>* distance;
	@property (nonatomic, strong, nullable) MPRouteProperty<Optional>* duration;
	@property (nonatomic, strong, nullable) NSString* status; 
@end
