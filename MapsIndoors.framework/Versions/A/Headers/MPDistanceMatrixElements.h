#import <Foundation/Foundation.h>
#import "MPRouteProperty.h"
#import "MPJSONModel.h"

@protocol MPDistanceMatrixElements
@end

@interface MPDistanceMatrixElements : MPJSONModel
	@property (strong) MPRouteProperty<Optional>* distance;
	@property (strong) MPRouteProperty<Optional>* duration;
	@property (strong) NSString* status; 
@end
