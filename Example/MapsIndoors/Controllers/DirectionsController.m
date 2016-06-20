//
//  DirectionsControllerTableViewController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 13/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "DirectionsController.h"
#import "DirectionsCellView.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "UIColor+AppColor.h"
#import "RoutingData.h"
#import "Global.h"
@import AFNetworking;
@import MaterialControls;
#import "UIButton+AppButton.h"


@interface DirectionsController ()
    
@end

@implementation DirectionsController {
    
    RoutingData* _routing;
    MDButton* _nextBtn;
    MDButton* _prevBtn;
}

- (void) reload {
    [self viewDidLoad];
    [self viewWillAppear:NO];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _routing = Global.routingData;
    
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
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64,0,0,0);
    //[self.tableView registerClass:[DirectionsCellView class] forCellReuseIdentifier:@"DirectionLegCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DirectionsCellView" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DirectionLegCell"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
    
    MPLocation* from = [[MPLocation alloc] initWithPoint:Global.positionProvider.latestPositionResult.geometry andName:kYouAreHere];
    
    [_routing routingFrom: from to: _routing.destination by:@"walking" avoid:nil depart:nil arrive:nil];
    
    if (_nextBtn == nil) {
        _prevBtn = [UIButton appRectButtonWithTitle:@"Previous" target:self selector:@selector(prev:)];
        [_prevBtn setTitleColor:[UIColor appSecondaryTextColor] forState:UIControlStateNormal];
        _prevBtn.backgroundColor = [UIColor appTextAndIconColor];
        
        _nextBtn = [UIButton appRectButtonWithTitle:@"Next" target:self selector:@selector(next:) xOffset:self.tableFooter.frame.size.width-120];
        
        [self.tableFooter addSubview:_prevBtn];
        [self.tableFooter addSubview:_nextBtn];
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
    MPRouteStep* nextLegFirstStep;
    if (indexPath.row < self.currentRoute.legs.count - 1) {
        nextLegFirstStep = [((MPRouteLeg*)[self.currentRoute.legs objectAtIndex:indexPath.row]).steps firstObject];
    }
    
    NSInteger rowIndex = indexPath.row;
    
    MPRouteStep* firstStep = [leg.steps firstObject];
    MPRouteStep* lastStep = [leg.steps lastObject];
    
    cell.lineMiddle.hidden = NO;
    cell.lineMiddle.thickness = kLineWidth;
    cell.lineMiddle.color = [UIColor appPrimaryColor];
    cell.lineMiddle.dashedGap = 0;
    cell.lineMiddle.dashedLength = 100;
    
    if (leg.start_address) {
        cell.firstLabel.text = leg.start_address;
    } else {
        cell.firstLabel.text = [NSString stringWithFormat:@"Level %@", lastStep.start_location.zLevel];
    }
    if (leg.end_address) {
        cell.secondLabel.text = leg.end_address;
    } else {
        cell.secondLabel.text = [NSString stringWithFormat:@"Level %@", lastStep.end_location.zLevel];
    }
    
    cell.firstIcon.image = [UIImage imageNamed:@"empty_icon"];
    cell.secondIcon.image = [UIImage imageNamed:@"empty_icon"];
    
    if ([firstStep.highway isEqualToString:@"steps"]) {
        cell.firstIcon.image = [UIImage imageNamed:@"stairs"];
    } else if ([firstStep.highway isEqualToString:@"elevator"]) {
        cell.firstIcon.image = [UIImage imageNamed:@"elevator"];
    }
    
    if (nextLegFirstStep) {
        if ([nextLegFirstStep.highway isEqualToString:@"steps"]) {
            cell.secondIcon.image = [UIImage imageNamed:@"stairs"];
        } else if ([nextLegFirstStep.highway isEqualToString:@"elevator"]) {
            cell.secondIcon.image = [UIImage imageNamed:@"elevator"];
        }
    }
    
    
    if (rowIndex == 0) {
        
        cell.lineTop.hidden = YES;
        cell.lineBottom.hidden = NO;
        cell.lineBottom.thickness = kLineWidth;
        cell.lineBottom.dashedLength = kDashSize;
        cell.lineBottom.color = [UIColor appPrimaryColor];
        cell.lineBottom.dashedGap = kDashSize;
        cell.firstLabel.text = _routing.origin.name;
        cell.firstIcon.image = [UIImage imageNamed:@"Mylocation"];
        
    } else if (rowIndex == self.currentRoute.legs.count - 1) {
        
        cell.lineBottom.hidden = YES;
        cell.lineTop.hidden = NO;
        cell.lineTop.thickness = kLineWidth;
        cell.lineTop.dashedLength = kDashSize;
        cell.lineTop.color = [UIColor appPrimaryColor];
        cell.lineTop.dashedGap = kDashSize;
        cell.secondLabel.text = _routing.destination.name;
        [cell.secondIcon setImageWithURL:[NSURL URLWithString: [Global getIconUrlForType:_routing.destination.type]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
    }
    
    if (self.currentRoute.legs.count == 1) {
        cell.lineBottom.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RouteLegSelected" object:@(indexPath.row)];
    [self updateUI];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)onRouteResultReady:(NSNotification *)notification {
    self.currentRoute = notification.object;
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    //[self performSegueWithIdentifier:@"DirectionsSegue" sender:nil];
}

@end
