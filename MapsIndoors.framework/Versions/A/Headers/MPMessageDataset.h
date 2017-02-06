//
//  MPMessageDataset.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "MPMessage.h"

/**
 * Empty protocol specification
 */
@protocol MPMessage
@end

/**
 * Dataset that holds Messages, searched results and a filter.
 */
@interface MPMessageDataset : JSONModel
/**
 * Main Message array in the data set.
 */
@property (nonatomic, strong) NSArray<MPMessage> *list;

@end
