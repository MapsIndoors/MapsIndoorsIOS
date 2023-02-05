//
//  MPGeometry.h
//  
//
//  Created by Daniel Nielsen on 9/9/13.
//
//

#import "JSONModel.h"

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Basic geometry class holding one or more coordinate sets
 */
@interface MPGeometry : JSONModel

/**
 Type of data (equals Geometry)
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>*   type;

/**
 Array holding one or more coordinate sets (if so, the array will be an array of arrays)
 */
@property (nonatomic, strong, nullable, readonly) NSArray *coordinates;

/**
 Optional bounding box for the geometry object.
 If present, it contains two coordinates: [ longitude1, latitude1, longitude2, latitude2 ]
 */
@property (nonatomic, strong, nullable, readonly) NSArray<NSNumber*><Optional>*    bbox;

@end
