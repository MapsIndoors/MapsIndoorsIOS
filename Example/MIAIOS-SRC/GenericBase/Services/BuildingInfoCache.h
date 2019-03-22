//
//  BuildingInfoCache.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 21/09/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPBuilding;


@interface BuildingInfoCache : NSObject

+ (instancetype) sharedInstance;

@property (nonatomic, strong, readonly) NSArray<MPBuilding*>*   buildings;

- (void) fetchBuildings;
- (MPBuilding*) buildingFromAdministrativeId:(NSString*)administrativeId;

@end
