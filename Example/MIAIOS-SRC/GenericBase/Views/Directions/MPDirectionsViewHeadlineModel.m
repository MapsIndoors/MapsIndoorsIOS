//
//  MPDirectionsViewHeadlineModel.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 06/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPDirectionsViewHeadlineModel.h"

@implementation MPDirectionsViewHeadlineModel

- (NSString *)debugDescription {

    return [NSString stringWithFormat:@"<MPDirectionsViewHeadlineModel %p: text='%@', headsign='%@', color=%@, imageUrl=%@, icon=%@>",
            self, self.text, self.primaryTextRight, self.color, self.imageUrl, self.materialDesignIconCode];
}

@end
