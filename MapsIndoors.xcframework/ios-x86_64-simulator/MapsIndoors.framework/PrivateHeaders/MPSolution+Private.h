//
//  MPSolution+Private.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 28/06/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPSolution.h"

@interface MPSolution ()

@property (nonatomic)                               BOOL                                                whiteLabel;
@property (nonatomic, strong, nullable)             NSString*                                           solutionId;
@property (nonatomic, strong, nullable, readwrite)  NSDictionary<NSString*,NSDictionary*><Optional>*    positionProviderConfigs;

@end
