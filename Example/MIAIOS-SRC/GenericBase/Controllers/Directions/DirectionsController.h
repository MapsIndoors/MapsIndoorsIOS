//
//  DirectionsController.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 13/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>


@class DottedLine;
@class MDSwitch;


@class MPRoute;

@interface DirectionsController : UIViewController <MPRoutingProviderDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MPRoute*              currentRoute;

@property (nonatomic, weak) IBOutlet UIView*        tableFooter;

@property (nonatomic, weak) IBOutlet UIButton*      originButton;
@property (nonatomic, weak) IBOutlet UIButton*      destinationButton;

@property (nonatomic, weak) IBOutlet UISwitch*      avoidStairsSwitch;
@property (nonatomic, weak) IBOutlet UILabel*       avoidStairsLabel;
@property (nonatomic, strong) IBOutlet UIView*      directionsForm;
@property (nonatomic, weak) IBOutlet DottedLine*    line;

@property (nonatomic, weak) IBOutlet UIImageView*   originIconView;
@property (nonatomic, weak) IBOutlet UIImageView*   destinationIconView;
@property (nonatomic, weak) IBOutlet UIButton*      switchDirIconButton;

@property (nonatomic, weak) IBOutlet UILabel*       durationEstimate;
@property (nonatomic, weak) IBOutlet UIImageView*   travelModeIcon;

@property (weak, nonatomic) IBOutlet UILabel*       offlineMsg;
@property (weak, nonatomic) IBOutlet UILabel*       offlineMsgDetail;

@property (nonatomic) BOOL                          isLocationServicesOn;

@property (weak, nonatomic) IBOutlet UIButton*      locationServicesBtn;
@property (weak, nonatomic) IBOutlet UIImageView*   lightningImgView;

-(IBAction) pop;

#pragma mark - Route request configured externally
- (void) configureWithRouteFrom:(MPLocation*)originLocation to:(MPLocation*)toLocation travelMode:(NSString*)travelMode avoids:(NSArray<NSString*>*)avoids;

@end
