//
//  VenueSelectorCell.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 23/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "VenueSelectorCell.h"
#import "UIImageView+MPCachingImageLoader.h"


@interface VenueSelectorCell ()

@property (weak, nonatomic) IBOutlet UIImageView*   venueImageView;
@property (weak, nonatomic) IBOutlet UILabel*       venueNameLabel;
@property (weak, nonatomic) IBOutlet UIView*        venueNameBackgroundEffectView;

@property (weak, nonatomic) MPVenue*                venue;
@property (strong, nonatomic) NSString*             imageUrl;

@end


@implementation VenueSelectorCell

- (void)configureWithVenue:(MPVenue *)venue imageUrl:(NSString *)imageUrl {
    
    self.venue = venue;
    self.imageUrl = imageUrl;

    NSString*   imageName = [imageUrl lastPathComponent];
    
    [self.venueImageView mp_setImageWithURL:imageUrl placeholderImageName:imageName];
    self.venueNameLabel.text = self.venue.name;
    self.venueNameLabel.font = [UIFont boldSystemFontOfSize:18];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    self.venueImageView.image = nil;
    self.venueNameLabel.text = nil;
}

@end
