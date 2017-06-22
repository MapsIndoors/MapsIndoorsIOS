#import <Foundation/Foundation.h> 
#import "JSONModel.h"
#import "MPDistanceMatrixElements.h"

@protocol MPDistanceMatrixRows
@end

@interface MPDistanceMatrixRows : JSONModel
	@property (strong) NSArray<MPDistanceMatrixElements>* elements;
@end
