//
//  HorizontalRoutingController.m
//  MIAIOS
//
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "HorizontalRoutingController.h"
#import "UIColor+AppColor.h"
#import "RoutingData.h"
#import "Global.h"
#import "MPDirectionsView.h"
#import "SectionModel.h"
#import "Tracker.h"
#import "LocalizedStrings.h"
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"


#define kDirectionsContainerHeight 180


@interface HorizontalRoutingController () <MPDirectionsViewDelegate>

@property (nonatomic, strong) RoutingData*              routing;
@property (nonatomic, strong) MPVenueProvider*          venueProvider;
@property (nonatomic) NSInteger                         selectedIndex;

@property (nonatomic, strong) NSMutableArray*           modelArray;
@property (nonatomic, strong) NSString*                 originType;
@property (nonatomic, strong) NSString*                 destinationType;

@property (weak, nonatomic) IBOutlet UISwitch*          viewTypeSwitch;
@property (weak, nonatomic) IBOutlet MPDirectionsView*  directionsView;

@end


@implementation HorizontalRoutingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.venueProvider = [[MPVenueProvider alloc] init];
    self.routing = Global.routingData;
    self.selectedIndex = 0;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteResultReady:) name:@"RoutingMapDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightButtonTapped:) name:@"ShowNextRouteLegInList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftButtonTapped:) name:@"ShowPreviousRouteLegInList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToCurrentLeg:) name:kNotificationShowSelectedLegInList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationTrackingOccured:) name:kNotificationLocationTrackingOccurred object:nil];
    
    self.directionsView.delegate = self;
    self.directionsView.shouldHighlightFocusedRouteSegment = NO;
    
    self.leftButton.accessibilityLabel = kLangPrev;
    self.rightButton.accessibilityLabel = kLangNext;
    self.backButton.accessibilityLabel = kLangBackAccHint;

    __weak typeof(self)weakSelf = self;
    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {

        [weakSelf.directionsView loadRoute:nil withModels:nil routingData:self->_routing];
        [weakSelf.directionsView onDynamicContentSizeChanged];
        [weakSelf.directionsView loadRoute:weakSelf.currentRoute withModels:weakSelf.modelArray routingData:weakSelf.routing];
    }];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [Tracker trackScreen:@"Show Route on Map"];
    
    self.viewTypeSwitch.hidden = YES;
}

- (void)onRouteResultReady:(NSNotification *)notification {
    self.currentRoute = notification.object;
    self.modelArray = notification.userInfo[@"models"];
    self.originType = notification.userInfo[@"origin"];
    self.destinationType = notification.userInfo[@"destination"];
    
    [self.directionsView loadRoute:self.currentRoute withModels:self.modelArray routingData:_routing];
    [self updateUI];
}

// Actions

- (void) updateUI {
    
    self.leftButton.enabled = self.directionsView.canFocusPrevRouteSegment;
    self.leftButton.layer.opacity = self.leftButton.enabled ? 1 : 0.4;
    self.rightButton.enabled = self.directionsView.canFocusNextRouteSegment;
    self.rightButton.layer.opacity = self.rightButton.enabled ? 1 : 0.4;
}

- (void)locationTrackingOccured:(NSNotification *)notification {
    NSInteger legIndex = [notification.userInfo[kLegIndex] integerValue];
    NSInteger stepIndex = [notification.userInfo[kStepIndex] integerValue];
    for (NSInteger i = 0; i < self.modelArray.count; i++) {
        SectionModel* model = [self.modelArray objectAtIndex:i];
        if (model.legIndex == legIndex && (model.stepIndex == stepIndex || model.stepIndex == -1)) {
            [self moveToLegWithIndex:i];
            break;
        }
    }
}

- (void)moveToLegWithIndex:(NSInteger)index {
    if (index < self.modelArray.count) {
        _selectedIndex = index;
    }
    
    self.directionsView.focusedRouteSegment = _selectedIndex;
    [self updateUI];
}

- (void)moveToCurrentLeg:(NSNotification *)notification {
    
    id  sender = notification.userInfo[kNotificationSender];
    SectionModel *model = (SectionModel *)notification.object;
    
    if ( model && (sender != self) ) {
        NSInteger index = [notification.userInfo[kRouteSectionIndex] integerValue];
        
        [self moveToLegWithIndex:index];
    }
}

- (void) clearData {
    
    self.currentRoute = nil;
    self.selectedIndex = 0;
    [self updateUI];
}

- (IBAction)backButtonTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenDirectionsSettings" object:nil];
    [self updateUI];
}

- (IBAction)leftButtonTapped:(id)sender {
    if (self.directionsView.canFocusPrevRouteSegment) {
        self.selectedIndex--;
        SectionModel *currentModel = [self.modelArray objectAtIndex:_selectedIndex];

        [self postDrawRouteLegNotificationWithLegIndex:currentModel.legIndex
                                          currentModel:currentModel
                                         withStepIndex:currentModel.stepIndex
                                    accessibilityLabel:[self.directionsView accessibilityLabelForRouteSegmentAtIndex:_selectedIndex]
        ];

        [self.directionsView focusPrevRouteSegment];
        [self updateUI];
        
        [self notifySelectedRouteSegment];
    }
}

- (IBAction)rightButtonTapped:(id)sender {
    if (self.directionsView.canFocusNextRouteSegment) {
        
        _selectedIndex++;
        SectionModel *currentModel = [self.modelArray objectAtIndex:_selectedIndex];
        [self postDrawRouteLegNotificationWithLegIndex:currentModel.legIndex
                                          currentModel:currentModel
                                         withStepIndex:currentModel.stepIndex
                                    accessibilityLabel:[self.directionsView accessibilityLabelForRouteSegmentAtIndex:_selectedIndex]
        ];

        [self.directionsView focusNextRouteSegment];
        [self updateUI];
        
        [self notifySelectedRouteSegment];
    }
}

// Post Notification with Index

- (void)postDrawRouteLegNotificationWithLegIndex:(NSInteger)legIndex
                                    currentModel:(SectionModel *)model
                                   withStepIndex:(NSInteger )stepIndex
                              accessibilityLabel:(NSString*)accessibilityLabel
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRouteLegSelected
                                                        object:model
                                                      userInfo:@{ kLegIndex: @(legIndex)
                                                                , kStepIndex: @(stepIndex)
                                                                , kRouteSectionAccessibilityLabel: accessibilityLabel
                                                                }];

}

- (void) notifySelectedRouteSegment {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowSelectedLegInList
                                                        object:nil
                                                      userInfo:@{ kRouteSectionIndex: @(self.directionsView.focusedRouteSegment),
                                                                  kNotificationSender: self}
    ];
}

#pragma mark - MPDirectionsViewDelegate

- (void)directionsView:(MPDirectionsView *)directionsView didSelectRouteSegmentAtIndex:(NSUInteger)index sectionModel:(SectionModel *)sectionModel {
    NSLog( @"MPDirectionsView:didSelectRouteSegmentAtIndex:%@", @(index) );
    
    [self postDrawRouteLegNotificationWithLegIndex:sectionModel.legIndex
                                      currentModel:sectionModel
                                     withStepIndex:sectionModel.stepIndex
                                accessibilityLabel:[self.directionsView accessibilityLabelForRouteSegmentAtIndex:index]
    ];
    directionsView.focusedRouteSegment = index;
    
    [self notifySelectedRouteSegment];
    
    float segmentPositionFactor = ((float) index +1) / (float)directionsView.numberOfRouteSegments;
    [Tracker trackEvent:@"Directions_Route_Segment_Selected" parameters:@{ @"Segment_Position_Factor" : @(segmentPositionFactor),
                                                                           @"Directions_Layout" : @"Horizontal"
                                                                           }];
}

- (void) directionsView:(MPDirectionsView*)directionsView didChangeFocusedRouteSegment:(NSUInteger)routeSegmentIndex {
    
    if ( self.selectedIndex != routeSegmentIndex ) {
        self.selectedIndex = routeSegmentIndex;
        [self updateUI];
    }
}

- (void)directionsView:(MPDirectionsView *)directionsView didSelectDirectionsForRouteSegmentAtIndex:(NSUInteger)index sectionModel:(SectionModel *)sectionModel {
    // empty impl.
}


#pragma mark - Development stuffz

- (IBAction)onChangeViewType:(UISwitch*)sender {

    [UIView animateWithDuration:0.3 animations:^{
        self.directionsView.verticalLayout = self.verticalMode = sender.on;
    }];
}

@end
