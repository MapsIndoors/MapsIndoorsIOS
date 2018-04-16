//
//  HorizontalRoutingController.h
//  MIAIOS
//
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>

#define kDirectionsContainerHeight              180
#define kDirectionsContainerHeightVerticalMode  360
#define kDirectionsContainerHeightSmall          44


@interface HorizontalRoutingController : UIViewController

@property (strong, nonatomic) MPRoute*              currentRoute;

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) MPLocation *destinationLocation;

@property (nonatomic) BOOL                          verticalMode;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)leftButtonTapped:(id)sender;
- (IBAction)rightButtonTapped:(id)sender;
- (void)clearData;

@end
