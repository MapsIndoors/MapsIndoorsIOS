//
//  UIViewController+VenueOpener.m
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 06/07/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import "UIViewController+Custom.h"
#import "VenueSelectorController.h"
#import "Global.h"
@import VCMaterialDesignIcons;

@implementation UIViewController (Custom)

- (void) openVenueSelector {
    VenueSelectorController* vsc = [[VenueSelectorController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vsc];
    [vsc venueSelectCallback:^(MPVenue *venue) {
        if (venue) {
            [[NSUserDefaults standardUserDefaults] setObject:[venue toJSONString] forKey:@"venue"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VenueChanged" object:venue];
        }
        [nav dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    
    nav.modalTransitionStyle   = UIModalTransitionStyleCoverVertical;
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void) presentCustomBackButton {
    UIImage* backImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_arrow_left fontSize:28.0f].image;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
}

- (void) pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toggleSidebar {
    UIBarButtonItem* btn = self.splitViewController.displayModeButtonItem;
    [[UIApplication sharedApplication] sendAction:btn.action
                                               to:btn.target
                                             from:nil
                                         forEvent:nil];
}

- (void) reload {
    [self viewDidLoad];
    [self viewWillAppear:NO];
}

@end
