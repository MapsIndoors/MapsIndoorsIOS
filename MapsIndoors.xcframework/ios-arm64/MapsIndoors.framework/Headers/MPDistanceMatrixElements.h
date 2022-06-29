#import <Foundation/Foundation.h>
#import "MPRouteProperty.h"
@import JSONModel;

@protocol MPDistanceMatrixElements
@end

@interface MPDistanceMatrixElements : JSONModel
	@property (nonatomic, strong, nullable) MPRouteProperty<Optional>* distance;
	@property (nonatomic, strong, nullable) MPRouteProperty<Optional>* duration;
	@property (nonatomic, strong, nullable) NSString* status; 
@end
