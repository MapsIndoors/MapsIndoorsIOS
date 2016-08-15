//
//  DirectionsControllerTableViewController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 13/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "DirectionsController.h"
#import "DirectionsCellView.h"
#import "UIColor+AppColor.h"
#import "RoutingData.h"
#import "Global.h"
#import "UIButton+AppButton.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "PlacePickerSearchController.h"
#import "UIViewController+Custom.h"
#import "LocalizationSystem.h"
#import "LocalizedStrings.h"

@import AFNetworking;
@import MaterialControls;
@import VCMaterialDesignIcons;

@interface DirectionsController ()
    
@end

@implementation DirectionsController {
    
    RoutingData* _routing;
    MDButton* _nextBtn;
    MDButton* _prevBtn;
    MDButton* _showBtn;
    
    UIBarButtonItem* _car;
    UIBarButtonItem* _bike;
    UIBarButtonItem* _train;
    UIBarButtonItem* _walk;
    
    NSArray* _avoids;
    
    NSString* _travelMode;
    
    MPLocation* _myLocation;
    
    MPVenueProvider* _venueProvider;
    NSMutableDictionary* _floors;
    UIActivityIndicatorView *_spinner;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    _routing = Global.routingData;
    
    _spinner = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:_spinner selector:@selector(startAnimating) name:@"RoutingRequestStarted" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteResultReady:) name:@"RoutingDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next:) name:@"ShowNextRouteLegInList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prev:) name:@"ShowPreviousRouteLegInList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"Reload" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.tableView.contentInset = UIEdgeInsetsMake(-64,0,0,0);
    //[self.tableView registerClass:[DirectionsCellView class] forCellReuseIdentifier:@"DirectionLegCell"];
    
    _venueProvider = [[MPVenueProvider alloc] init];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DirectionsCellView" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DirectionLegCell"];
    
    [self.destinationButton addTarget:self action:@selector(openDestinationSearch) forControlEvents:UIControlEventTouchDown];
    [self.originButton addTarget:self action:@selector(openOriginSearch) forControlEvents:UIControlEventTouchDown];
    
    self.originButton.layer.cornerRadius = 6.0f;
    self.destinationButton.layer.cornerRadius = 6.0f;
    
    self.originButton.backgroundColor = [UIColor appDarkPrimaryColor];
    self.destinationButton.backgroundColor = [UIColor appDarkPrimaryColor];
    
    self.originButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    self.destinationButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.line.thickness = 4.0f;
    self.line.color = [UIColor appLightPrimaryColor];
    self.line.dashedGap = 4.0f;
    self.line.dashedLength = 4.0f;
    
    UIImage* dirImage = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_swap_vertical fontSize:28.0f].image;
    [self.switchDirIconButton setImage:dirImage forState:UIControlStateNormal];
    [self.switchDirIconButton addTarget:self action:@selector(switchDir) forControlEvents:UIControlEventTouchUpInside];
    self.switchDirIconButton.tintColor = [UIColor whiteColor];
    
    UIImage* carImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_car fontSize:22.0f].image;
    _car = [[UIBarButtonItem alloc] initWithImage:carImg style:UIBarButtonItemStylePlain target:self action:@selector(transitMode:)];
    
    UIImage* bikeImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_bike fontSize:22.0f].image;
    _bike = [[UIBarButtonItem alloc] initWithImage:bikeImg style:UIBarButtonItemStylePlain target:self action:@selector(transitMode:)];
    
    UIImage* trainImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_bus fontSize:22.0f].image;
    _train = [[UIBarButtonItem alloc] initWithImage:trainImg style:UIBarButtonItemStylePlain target:self action:@selector(transitMode:)];
    
    UIImage* walkImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_walk fontSize:22.0f].image;
    _walk = [[UIBarButtonItem alloc] initWithImage:walkImg style:UIBarButtonItemStylePlain target:self action:@selector(transitMode:)];
    
    self.navigationItem.rightBarButtonItems = @[_car, _train, _bike, _walk];
    
    _walk.tintColor = [UIColor whiteColor];
    _train.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
    _car.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
    _bike.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
    
    _travelMode = @"walking";
    
    [self.avoidStairsSwitch addTarget:self action:@selector(avoidStairs) forControlEvents:UIControlEventValueChanged];
    self.avoidStairsSwitch.thumbOn = [UIColor whiteColor];
    self.avoidStairsSwitch.trackOn = [UIColor appDarkPrimaryColor];
    self.avoidStairsSwitch.thumbOff = [UIColor appLightPrimaryColor];
    self.avoidStairsSwitch.trackOff = [UIColor appDarkPrimaryColor];
    
    self.directionsForm.backgroundColor = [UIColor appPrimaryColor];
    self.avoidStairsLabel.text = kLangAvoidStairs;
    
    [self.tableView addSubview:_spinner];
    
    
}

- (void) transitMode:(id)sender {
    if (sender) {
        UIBarButtonItem* newSender = sender;
        _walk.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
        _train.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
        _car.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
        _bike.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
        newSender.tintColor = [UIColor whiteColor];
        if ([newSender isEqual:_car]) _travelMode = @"driving";
        if ([newSender isEqual:_train]) _travelMode = @"transit";
        if ([newSender isEqual:_bike]) _travelMode = @"cycling";
        if ([newSender isEqual:_walk]) _travelMode = @"walking";
        [self updateRouting];
    }
}

- (void) avoidStairs {
    if (self.avoidStairsSwitch.on) {
        _avoids = @[@"stairs"];
    } else {
        _avoids = nil;
    }
    [self updateRouting];
}

- (void) switchDir {
    MPLocation* tempDest = _routing.destination;
    
    _routing.destination = _routing.origin;
    _routing.origin = tempDest;
    
    [self updateRouting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self presentCustomBackButton];
    
    [self.navigationController presentTransparentNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _myLocation = [[MPLocation alloc] initWithPoint:Global.positionProvider.latestPositionResult.geometry andName:kLangMy_position];
    _myLocation.displayRule.icon = [UIImage imageNamed:@"Mylocation"];
    
    if (_routing.origin == nil) {
        _routing.origin = _myLocation;
    }
    [self updateRouting];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    
        if (_nextBtn == nil) {
            _prevBtn = [UIButton appRectButtonWithTitle:kLangPrev target:self selector:@selector(prev:)];
            [_prevBtn setTitleColor:[UIColor appSecondaryTextColor] forState:UIControlStateNormal];
            _prevBtn.backgroundColor = [UIColor appTextAndIconColor];
            
            _nextBtn = [UIButton appRectButtonWithTitle:kLangNext target:self selector:@selector(next:) xOffset:self.tableFooter.frame.size.width-120];
            
            [self.tableFooter addSubview:_prevBtn];
            [self.tableFooter addSubview:_nextBtn];
        }
        
    } else {
        
        if (_showBtn == nil) {
            _showBtn = [UIButton appRectButtonWithTitle:kLangShow_on_map target:self selector:@selector(reloadDirectionsOnMap) xOffset:self.tableFooter.frame.size.width-120];
            
            [self.tableFooter addSubview:_showBtn];
        }
        
    }
    
    [self updateUI];
}

- (void)next:(id)sender {
    NSInteger nextIndex = self.tableView.indexPathForSelectedRow.row + 1;
    if (nextIndex < self.currentRoute.legs.count) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow: nextIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    [self updateUI];
}

- (void)prev:(id)sender {
    NSInteger nextIndex = self.tableView.indexPathForSelectedRow.row - 1;
    if (nextIndex >= 0) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow: nextIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    [self updateUI];
}

- (void) updateUI {
    _prevBtn.enabled = YES;
    _nextBtn.enabled = YES;
    if (self.tableView.indexPathForSelectedRow.row == 0) {
        _prevBtn.enabled = NO;
    }
    if (self.tableView.indexPathForSelectedRow.row == self.currentRoute.legs.count - 1) {
        _nextBtn.enabled = NO;
    }
}

- (void)pop {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseRouting" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentRoute) return self.currentRoute.legs.count;
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DirectionsCellView *cell = (DirectionsCellView *)[tableView dequeueReusableCellWithIdentifier:@"DirectionLegCell" forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DirectionsCellView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    MPRouteLeg* leg = [self.currentRoute.legs objectAtIndex:indexPath.row];
    NSInteger rowIndex = indexPath.row;
    
    MPRouteStep* firstStep = [leg.steps firstObject];
    MPRouteStep* lastStep = [leg.steps lastObject];
    MPRouteStep* nextLegFirstStep;
    if (indexPath.row < self.currentRoute.legs.count - 1) {
        nextLegFirstStep = [((MPRouteLeg*)[self.currentRoute.legs objectAtIndex:indexPath.row + 1]).steps firstObject];
    }
    
    cell.lineMiddle.hidden = NO;
    cell.lineTop.hidden = NO;
    cell.lineBottom.hidden = NO;
    
    for (DottedLine* line in @[cell.lineTop, cell.lineBottom]) {
        line.thickness = kLineWidth;
        line.dashedLength = kDashSize;
        line.color = [UIColor appPrimaryColor];
        line.dashedGap = kDashSize;
    }
    
    cell.lineMiddle.thickness = kLineWidth;
    cell.lineMiddle.color = [UIColor appPrimaryColor];
    cell.lineMiddle.dashedGap = 0;
    cell.lineMiddle.dashedLength = 100;
    
    
    
    cell.firstLabel.text = leg.start_address;
    cell.secondLabel.text = leg.end_address;
    
    
    cell.firstIcon.image = [UIImage imageNamed:@"empty_icon"];
    cell.secondIcon.image = [UIImage imageNamed:@"empty_icon"];
    
    if ([firstStep.highway isEqualToString:@"steps"]) {
        cell.firstIcon.image = [UIImage imageNamed:@"Stairs"];
    } else if ([firstStep.highway isEqualToString:@"elevator"]) {
        cell.firstIcon.image = [UIImage imageNamed:@"Elevator"];
    }
    
    if (nextLegFirstStep) {
        if ([nextLegFirstStep.highway isEqualToString:@"steps"]) {
            cell.secondIcon.image = [UIImage imageNamed:@"Stairs"];
        } else if ([nextLegFirstStep.highway isEqualToString:@"elevator"]) {
            cell.secondIcon.image = [UIImage imageNamed:@"Elevator"];
        }
    }
    
    if (rowIndex == 0) {
        cell.lineTop.hidden = YES;
        cell.firstLabel.text = _routing.origin.name;
        if (_routing.origin.type) {
            [cell.firstIcon setImageWithURL:[NSURL URLWithString: [Global getIconUrlForType:_routing.origin.type]] placeholderImage:[UIImage imageNamed:@"placeholder2"]];
        } else {
            cell.firstIcon.image = [UIImage imageNamed:@"Mylocation"];
        }
    } else if (rowIndex == self.currentRoute.legs.count - 1) {
        cell.lineBottom.hidden = YES;
        cell.secondLabel.text = _routing.destination.name;
        if (_routing.destination.type) {
            [cell.secondIcon setImageWithURL:[NSURL URLWithString: [Global getIconUrlForType:_routing.destination.type]] placeholderImage:[UIImage imageNamed:@"placeholder2"]];
        } else {
            cell.secondIcon.image = [UIImage imageNamed:@"Mylocation"];
        }
    }
    
    if (self.currentRoute.legs.count == 1) {
        cell.lineBottom.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RouteLegSelected" object:@(indexPath.row)];
    [self updateUI];
    [self openDirectionsOnMap];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)onRouteResultReady:(NSNotification *)notification {
    self.currentRoute = notification.object;
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [_spinner stopAnimating];
    
    //[self performSegueWithIdentifier:@"DirectionsSegue" sender:nil];
}

- (void)reloadDirectionsOnMap {
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHorizontalDirections" object:nil];
        [_routing routingFrom:_routing.origin to:_routing.destination by:_travelMode avoid:_avoids depart:nil arrive:nil];
        //Hide side menu/master view
        [self toggleSidebar];
    }
}

- (void)openDirectionsOnMap {
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHorizontalDirections" object:nil];
        [self toggleSidebar];
    }
}

- (void)openOriginSearch {
    PlacePickerSearchController* ppsc = [[PlacePickerSearchController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ppsc];
    ppsc.myLocation = _myLocation;
    [ppsc placePickerSelectCallback:^(MPLocation *location) {
        _routing.origin = location;
        [self updateRouting];
        [nav dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)openDestinationSearch {
    PlacePickerSearchController* ppsc = [[PlacePickerSearchController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ppsc];
    ppsc.myLocation = _myLocation;
    [ppsc placePickerSelectCallback:^(MPLocation *location) {
        _routing.destination = location;
        [self updateRouting];
        [nav dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void) updateRouting {
    if (_routing.origin && _routing.destination){
        [self.originButton setTitle:[Global getAddressForLocation:_routing.origin] forState:UIControlStateNormal];
        [self.destinationButton setTitle:[Global getAddressForLocation:_routing.destination] forState:UIControlStateNormal];
        [_routing routingFrom: _routing.origin to: _routing.destination by:_travelMode avoid:_avoids depart:nil arrive:nil];
    }
}

@end
