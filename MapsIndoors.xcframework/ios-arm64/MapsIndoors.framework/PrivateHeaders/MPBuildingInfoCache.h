//
//  MPBuildingInfoCache.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 06/12/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@class MPBuilding;
@class MPBuildingInfoCache;


typedef void (^BuildingInfoCompletion)(MPBuildingInfoCache* bic);


@interface MPBuildingInfoCache : NSObject

@property (nonatomic, strong, readonly, nullable) NSString*                               solutionId;
@property (nonatomic, strong, readonly, nullable) NSString*                               language;

@property (nonatomic, strong, readonly, nullable) NSError*                                error;
@property (nonatomic, strong, readonly, nullable) NSArray<MPBuilding*>*                   buildings;
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString*,MPBuilding*>*    buildingFromBuildingId;
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSNumber*,NSString*>*      floorNameFromFloorNumber;

+ (nullable instancetype) newWithSolutionId:(NSString*)solutionId language:(NSString*)language completion:(BuildingInfoCompletion)completion;
- (nullable instancetype) initWithSolutionId:(NSString*)solutionId language:(NSString*)language completion:(BuildingInfoCompletion)completion NS_DESIGNATED_INITIALIZER;
- (nullable instancetype) init NS_UNAVAILABLE;

- (void) setupWithSolutionId:(NSString *)solutionId language:(NSString *)language completion:(BuildingInfoCompletion)completion;

@end


NS_ASSUME_NONNULL_END
