#import <Foundation/Foundation.h> 
#import "JSONModel.h"
#import "MPDistanceMatrixElements.h"


@protocol MPDistanceMatrixRows
@end


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDistanceMatrixRows : JSONModel
	@property (nonatomic, strong, nullable) NSArray<MPDistanceMatrixElements*><MPDistanceMatrixElements>* elements;
@end
