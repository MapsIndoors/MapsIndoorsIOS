//
//  MPGeometry.h
//  
//
//  Created by Daniel Nielsen on 9/9/13.
//
//

#import "MPJSONModel.h"

/**
 Basic geometry class holding one or more coordinate sets
 */
@interface MPGeometry : MPJSONModel

/**
 Type of data (equals Geometry)
 */
@property (nonatomic, strong, nullable) NSString<Optional>*   type;

/**
 Array holding one or more coordinate sets (if so, the array will be an array of arrays)
 */
@property (nonatomic, strong, nullable) NSArray *coordinates;

/**
 Optional bounding box for the geometry object.
 If present, it contains two coordinates: [ longitude1, latitude1, longitude2, latitude2 ]
 */
@property (nonatomic, strong, nullable) NSArray<NSNumber*><Optional>*    bbox;

@end
