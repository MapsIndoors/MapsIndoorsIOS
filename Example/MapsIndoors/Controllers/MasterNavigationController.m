//
//  MasterNavigationController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 30/09/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import "MasterNavigationController.h"
#import "DetailViewController.h"
#import "Global.h"
#import "AppDelegate.h"

@interface MasterNavigationController ()

@end

@implementation MasterNavigationController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailSegue"] && sender == self) {
        DetailViewController* dvc = segue.destinationViewController;
        dvc.location = nil;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMapLocationTapped:) name:@"MapLocationTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationOpened:) name:@"LocationOpen" object:nil];
    
}


- (void)onMapLocationTapped:(NSNotification*)notification {
    
    
    MPLocation* loc = notification.object;
    
    [self openLocationWithId:loc.locationId];
    
    
}

- (void)onLocationOpened:(NSNotification*)notification {
    
    
    NSString* locId = notification.object;
    
    [self openLocationWithId:locId];
    
    
}

- (void)openLocationWithId:(NSString*)locationId {
    [self popToRootViewControllerAnimated:NO];
    
    [self performSegueWithIdentifier:@"DetailSegue" sender:self];
    
    UIBarButtonItem* btn = self.splitViewController.displayModeButtonItem;
    [[UIApplication sharedApplication] sendAction:btn.action
                                               to:btn.target
                                             from:nil
                                         forEvent:nil];
    
    [Global.poiData getLocationDetailsAsync:Global.solutionId withId:locationId language:@"en"];
}

@end
