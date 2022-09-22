//
//  MPLocationDisplayRuleDelegate.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 10/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPLocationDisplayRuleDelegate <NSObject>

- (void) displayRuleWasUpdated:(MPLocationDisplayRule*)rule;

@end
