//
//  UIViewController+VenueOpener.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 06/07/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import "UIViewController+Custom.h"
#import "VenueSelectorController.h"
#import "Global.h"
@import VCMaterialDesignIcons;
#import "MasterViewController.h"


@implementation UIViewController (Custom)

- (void) openVenueSelector {
    
    if ( self.navigationController.viewControllers.firstObject == self ) {

        VenueSelectorController* vsc = [VenueSelectorController new];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vsc];
        
        __weak typeof(nav)weaknav = nav;    // Avoid circular ref: UINavigationController -> VenueSelectorController -> vsc.venueSelectCallback -> UINavigationController
        [vsc venueSelectCallback:^(MPVenue *venue) {
            if (venue) {
                [[NSUserDefaults standardUserDefaults] setObject: venue.venueId forKey:@"venue"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"VenueChanged" object:venue];
            }
            [weaknav dismissViewControllerAnimated:YES completion:^{
            }];
        }];
        
        nav.modalTransitionStyle   = UIModalTransitionStyleCoverVertical;
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:nav animated:YES completion:nil];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) popToMasterViewControllerAnimated:(BOOL)animated {
    
    UIViewController*   targetViewController;
    
    for ( UIViewController* vc in self.navigationController.viewControllers ) {
        if ( [vc isKindOfClass:[MasterViewController class]] ) {
            targetViewController = vc;
            break;
        }
    }
    
    if ( targetViewController ) {
        [self.navigationController popToViewController:targetViewController animated:animated];
    }
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


@end
