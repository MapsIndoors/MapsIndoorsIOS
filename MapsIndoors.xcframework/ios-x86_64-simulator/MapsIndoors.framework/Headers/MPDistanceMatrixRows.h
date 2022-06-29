#import <Foundation/Foundation.h> 
@import JSONModel;
#import "MPDistanceMatrixElements.h"


@protocol MPDistanceMatrixRows
@end


@interface MPDistanceMatrixRows : JSONModel
	@property (nonatomic, strong, nullable) NSArray<MPDistanceMatrixElements*><MPDistanceMatrixElements>* elements;
@end
