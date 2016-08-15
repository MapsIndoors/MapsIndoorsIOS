//
//  HorizontalDirectionsController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 04/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "HorizontalDirectionsController.h"

#import "DirectionsCellView.h"
#import "UIColor+AppColor.h"
#import "RoutingData.h"
#import "Global.h"
@import AFNetworking;
@import MaterialControls;
#import "UIButton+AppButton.h"
#import "LocalizationSystem.h"
#import "LocalizedStrings.h"

@interface HorizontalDirectionsController ()

@end

@implementation HorizontalDirectionsController{
    RoutingData* _routing;
    MDButton* _nextBtn;
    MDButton* _prevBtn;
    MPVenueProvider* _venueProvider;
}

- (instancetype)init {
    self = [super init];
    
    _venueProvider = [[MPVenueProvider alloc] init];
    _routing = Global.routingData;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteResultReady:) name:@"RoutingDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next:) name:@"ShowNextRouteLegInList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prev:) name:@"ShowPreviousRouteLegInList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"Reload" object:nil];
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeTableView];
    
    self.headerTitle.text = kLangShowing_route;
    
}

- (void) initializeTableView {
    self.tableView = [[EasyTableView alloc] initWithFrame:CGRectMake(16, 44, 640, 73) numberOfColumns:4 ofWidth:186];
    self.tableView.delegate = self;
    [self.view addSubview: self.tableView];
    
    
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableView.separatorColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_nextBtn == nil) {
        _prevBtn = [UIButton appRectButtonWithTitle:kLangPrev target:self selector:@selector(prev:)];
        [_prevBtn setTitleColor:[UIColor appSecondaryTextColor] forState:UIControlStateNormal];
        _prevBtn.backgroundColor = [UIColor appTextAndIconColor];
        _prevBtn.enabled = NO;
        
        _nextBtn = [UIButton appRectButtonWithTitle:kLangNext target:self selector:@selector(next:) xOffset:self.tableFooter.frame.size.width-120];
        
        [self.tableFooter addSubview:_prevBtn];
        [self.tableFooter addSubview:_nextBtn];
        
        self.tableHeader.backgroundColor = [UIColor appPrimaryColor];
    }
}

- (void)next:(id)sender {
    NSInteger nextIndex = self.tableView.selectedIndexPath.row + 1;
    if (nextIndex < self.currentRoute.legs.count) {
        [self.tableView selectCellAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0] animated:YES];
    }
    [self updateUI];
}

- (void)prev:(id)sender {
    NSInteger nextIndex = self.tableView.selectedIndexPath.row - 1;
    if (nextIndex >= 0) {
        [self.tableView selectCellAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0] animated:YES];
    }
    [self updateUI];
    
}

- (void) updateUI {
    _prevBtn.enabled = YES;
    _nextBtn.enabled = YES;
    _prevBtn.layer.opacity = 1;
    _nextBtn.layer.opacity = 1;
    if (self.tableView.selectedIndexPath.row == 0) {
        _prevBtn.enabled = NO;
        _prevBtn.layer.opacity = 0.4;
    }
    if (self.tableView.selectedIndexPath.row == self.currentRoute.legs.count - 1) {
        _nextBtn.enabled = NO;
        _nextBtn.layer.opacity = 0.4;
    }
}

- (NSUInteger)numberOfSectionsInEasyTableView:(EasyTableView *)easyTableView {
    return 1;
}

- (NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section {
    if (self.currentRoute) return self.currentRoute.legs.count;
    return 0;
}

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
    //DirectionsCellView *cell = (DirectionsCellView *)[tableView.tableView dequeueReusableCellWithIdentifier:@"DirectionLegCell" forIndexPath:indexPath];
    //if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HorizontalDirectionsCellView" owner:self options:nil];
        DirectionsCellView *cell = [nib objectAtIndex:0];
        cell.layer.opacity = 0.4;
    //}
    return cell;
}

- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath {
    MPRouteLeg* leg = [self.currentRoute.legs objectAtIndex:indexPath.row];
    NSInteger rowIndex = indexPath.row;
    
    MPRouteStep* firstStep = [leg.steps firstObject];
    MPRouteStep* lastStep = [leg.steps lastObject];
    MPRouteStep* nextLegFirstStep;
    if (indexPath.row < self.currentRoute.legs.count - 1) {
        nextLegFirstStep = [((MPRouteLeg*)[self.currentRoute.legs objectAtIndex:indexPath.row + 1]).steps firstObject];
    }
    
    DirectionsCellView *cell = (DirectionsCellView *)view;
    
    cell.layer.opacity = 0.4;
    
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
        cell.firstIcon.image = [UIImage imageNamed:@"Mylocation"];
    } else if (rowIndex == self.currentRoute.legs.count - 1) {
        cell.lineBottom.hidden = YES;
        cell.secondLabel.text = _routing.destination.name;
        [cell.secondIcon setImageWithURL:[NSURL URLWithString: [Global getIconUrlForType:_routing.destination.type]] placeholderImage:[UIImage imageNamed:@"placeholder2"]];
    }
    
    if (self.currentRoute.legs.count == 1) {
        cell.lineBottom.hidden = YES;
    }
    
}

- (void)easyTableView:(EasyTableView *)easyTableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)indexPath deselectedView:(UIView *)deselectedView {
    
    DirectionsCellView* deselecedCell = (DirectionsCellView*)deselectedView;
    DirectionsCellView* cell = (DirectionsCellView*)selectedView;
    
    [UIView animateWithDuration:0.4 animations:^{
        deselecedCell.lineBottom.layer.opacity = 1;
        deselecedCell.lineTop.layer.opacity = 1;
        
        deselectedView.layer.opacity = 0.4;
        selectedView.layer.opacity = 1;
        
        cell.lineBottom.layer.opacity = 0.4;
        cell.lineTop.layer.opacity = 0.4;
    }];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RouteLegSelected" object:@(indexPath.row)];
    
    NSLog(@"%tu / %f", indexPath.row, self.currentRoute.legs.count-0.9999f);
    
    //[self.tableView setScrollFraction: 0.5f animated:YES];
    //[self.tableView setScrollFraction:(indexPath.row/(self.currentRoute.legs.count-0.9999f)) animated:YES];
    
    [self updateUI];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onRouteResultReady:(NSNotification *)notification {
    self.currentRoute = notification.object;
    [self.tableView removeFromSuperview];
    [self initializeTableView];
    if ([self viewVisible]) {
        [self performSelector:@selector(selectFirstCell) withObject:nil afterDelay:0.5];
    }
    if (self.currentRoute.legs.count < 2) {
        self.tableFooter.hidden = YES;
    } else {
        self.tableFooter.hidden = NO;
    }
}

- (void) selectFirstCell {
    [self.tableView selectCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
}

- (void)closeRouting {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenDirectionsSettings" object:nil];
    self.currentRoute = nil;
    [self.tableView reloadData];
}

- (BOOL)viewVisible {
    return (self.view.frame.origin.y < [UIScreen mainScreen].applicationFrame.size.height);
}

@end
