//
//  VenueSelectorCell.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 23/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>

@class MPVenue;


@interface VenueSelectorCell : UITableViewCell

- (void) configureWithVenue:(MPVenue*)venue imageUrl:(NSString*)imageUrl;

@end
