#import <Foundation/Foundation.h> 
#import "MPJSONModel.h"
#import "MPDistanceMatrixElements.h"


@protocol MPDistanceMatrixRows
@end


@interface MPDistanceMatrixRows : MPJSONModel
	@property (strong) NSArray<MPDistanceMatrixElements*><MPDistanceMatrixElements>* elements;
@end
