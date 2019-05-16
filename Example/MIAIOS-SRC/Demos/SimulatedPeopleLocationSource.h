//
//  SimulatedPeopleLocationSource.h
//  kpmg-testbed
//
//  Created by Michael Bech Hansen on 27/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>


NS_ASSUME_NONNULL_BEGIN

@interface SimulatedPeopleLocationSource : NSObject <MPLocationSource>

@property (class, nonatomic, readonly) MPLocationDisplayRule*    peopleDisplayRule;
@property (class, nonatomic, readonly) MPLocationDisplayRule*    currentUserDisplayRule;

@end

NS_ASSUME_NONNULL_END
