//
//  MPDirectionsStepViewModel.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 15/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPDirectionsStepViewModel : NSObject

@property (nonatomic, strong, readonly) NSString*       stepDescription;
@property (nonatomic, strong, readonly) NSString*       stepDetail;
@property (nonatomic, strong, readonly) NSString*       stepManuever;
@property (nonatomic, readonly)         BOOL            isStairs;

+ (instancetype) newWithDescription:(NSString*)desc details:(NSString*)details manuever:(NSString*)manuever isStairs:(BOOL)isStairs;
- (instancetype) initWithDescription:(NSString*)desc details:(NSString*)details manuever:(NSString*)manuever isStairs:(BOOL)isStairs;
- (instancetype)init NS_UNAVAILABLE;

@end
