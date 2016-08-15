//
//  MPLocationCell.m
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 01/08/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import "MPLocationCell.h"
#import "UIColor+AppColor.h"
@import VCMaterialDesignIcons;

@implementation MPLocationCell

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

- (void)didMoveToSuperview {
    
    [self setupBuildingLabel];
    [self setupFloorLabel];
    [self setupDistanceLabel];
}

- (void)setupFloorLabel {
    [self.floorLabel setFont:[UIFont systemFontOfSize:13.0]];
    VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_swap_vertical fontSize:16.0f];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor appSecondaryTextColor]];
    self.floorIcon.image = icon.image;
}
- (void)setupBuildingLabel {
    [self.buildingLabel setFont:[UIFont systemFontOfSize:13.0]];
    VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_city fontSize:16.0f];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor appSecondaryTextColor]];
    self.buildingIcon.image = icon.image;
}
- (void)setupDistanceLabel {
    [self.distanceLabel setFont:[UIFont systemFontOfSize:9.0]];
    self.distanceLabel.textColor = [UIColor appPrimaryColor];
    VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_navigation fontSize:12.0f];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor appPrimaryColor]];
    self.distanceIcon.image = icon.image;
}

@end
