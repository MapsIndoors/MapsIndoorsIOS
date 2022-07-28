//
//  MPAppData+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 31/01/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import "MPAppData.h"
#import "MPLocationDisplayRuleset.h"
#import "MPLoggingConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPAppData (Private)

@property (strong, nonatomic, nullable) MPLocationDisplayRuleset<Ignore>*                               displayRuleset;
@property (nonatomic, strong, nullable, readwrite)  MPLoggingConfig*                                    loggingConfig;

@end

NS_ASSUME_NONNULL_END
