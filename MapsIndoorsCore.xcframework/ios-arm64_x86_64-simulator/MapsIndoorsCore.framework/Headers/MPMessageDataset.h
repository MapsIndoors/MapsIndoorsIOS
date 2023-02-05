//
//  MPMessageDataset.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "MPMessage.h"

/**
 Empty protocol specification
 */
@protocol MPMessage
@end

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Dataset that holds Messages, searched results and a filter.
 */
@interface MPMessageDataset : JSONModel
/**
 Main Message array in the data set.
 */
@property (nonatomic, strong, nullable) NSArray<MPMessage> *list;

@end
