#import <Foundation/Foundation.h>
#import "MPRouteProperty.h"
#import "JSONModel.h"

@protocol MPDistanceMatrixElements
@end

@interface MPDistanceMatrixElements : JSONModel
	@property (strong) MPRouteProperty<Optional>* distance;
	@property (strong) MPRouteProperty<Optional>* duration;
	@property (strong) NSString* status; 
@end
