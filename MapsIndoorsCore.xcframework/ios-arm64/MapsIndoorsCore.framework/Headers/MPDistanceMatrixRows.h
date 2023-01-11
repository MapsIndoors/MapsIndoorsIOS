#import <Foundation/Foundation.h> 
#import "JSONModel.h"
#import "MPDistanceMatrixElements.h"


@protocol MPDistanceMatrixRows
@end


@interface MPDistanceMatrixRows : JSONModel
	@property (nonatomic, strong, nullable) NSArray<MPDistanceMatrixElements*><MPDistanceMatrixElements>* elements;
@end
