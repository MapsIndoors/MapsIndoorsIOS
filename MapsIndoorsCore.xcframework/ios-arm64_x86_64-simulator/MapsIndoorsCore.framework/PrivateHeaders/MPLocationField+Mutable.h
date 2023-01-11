//
//  MPLocationField+Mutable.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPLocationField.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLocationField ()

@property (nonatomic, strong, nullable, readwrite) NSString* type;
@property (nonatomic, strong, nullable, readwrite) NSString* text;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* value;

@end

NS_ASSUME_NONNULL_END
