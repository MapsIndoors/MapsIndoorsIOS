#import <Foundation/Foundation.h>
#import "MPRouteProperty.h"
#import "MPJSONModel.h"

@protocol MPDistanceMatrixElements
@end

@interface MPDistanceMatrixElements : MPJSONModel
	@property (nonatomic, strong, nullable) MPRouteProperty<Optional>* distance;
	@property (nonatomic, strong, nullable) MPRouteProperty<Optional>* duration;
	@property (nonatomic, strong, nullable) NSString* status; 
@end
