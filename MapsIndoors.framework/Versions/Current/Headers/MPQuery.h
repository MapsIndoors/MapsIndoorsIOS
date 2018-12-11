//
//  MPLocationsQuery.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPQuery : NSObject

@property (nonatomic) NSArray<NSString*>* queryProperties;

@property (nonatomic) NSString* query;

@property (nonatomic) MPPoint* near;

- (void) addOrderingWithProperty:(NSString*) property ascending: (BOOL) ascending;
- (void) setOrderingWithProperty:(NSString*) property ascending: (BOOL) ascending;

@end

NS_ASSUME_NONNULL_END
