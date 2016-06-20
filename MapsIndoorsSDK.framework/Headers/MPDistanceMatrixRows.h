#import <Foundation/Foundation.h> 
@import JSONModel;
#import "MPDistanceMatrixElements.h"

@protocol MPDistanceMatrixRows
@end

@interface MPDistanceMatrixRows : JSONModel
	@property (strong) NSArray<MPDistanceMatrixElements>* elements;
@end