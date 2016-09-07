//
//  DetailViewController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//


#import "Global.h"
#import "DetailViewController.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "DirectionsController.h"
#import <MapsIndoors/MapsIndoors.h>
#import "UIColor+AppColor.h"
#import "UIButton+AppButton.h"
#import "UIViewController+Custom.h"
#import "AppDelegate.h"
#import "LocalizedStrings.h"
@import VCMaterialDesignIcons;
@import AFNetworking;
@import MaterialControls;

@interface DetailViewController ()

@end

@implementation DetailViewController {
    NSMutableArray* _fields;
    RoutingData* _routing;
    MPRoute* _route;
    MDButton* _routeBtn;
    MDButton* _showMapBtn;
    NSDictionary* _directionsItem;
    UIActivityIndicatorView *_spinner;
}

@synthesize location = _location;

- (void)awakeFromNib {
    [super awakeFromNib];
    _routing = Global.routingData;
    
    _spinner = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:_spinner selector:@selector(startAnimating) name:@"LocationsRequestStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationDetailsReady:) name:@"LocationDetailsReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteResultReady:) name:@"RoutingDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"Reload" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self presentCustomBackButton];
    
    UIImage* shareImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_share fontSize:28.0f].image;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:shareImg style:UIBarButtonItemStylePlain target:self action:@selector(shareLocation)];
    
    [self.navigationController presentTransparentNavigationBar];
    
}

- (void) pop: (id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onLocationDetailsReady:(NSNotification*)notification {
    [_spinner stopAnimating];
    _fields = [NSMutableArray arrayWithCapacity:0];
    
    if (_location != notification.object) {
        self.location = notification.object;
    }
}

- (void)shareLocation {
    //NSString* shareText = [NSString stringWithFormat:@"Let's meet here - %@ - %@ - Powered by MapsIndoors®", self.location.name, self.location.descr];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://clients.mapsindoors.com/sdu/%@/details/%@", Global.venue.venueId, self.location.locationId]];
    UIActivityViewController* shareCtrl = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:shareCtrl animated:YES completion:nil];
    [self toggleSidebar];
}

- (void)setLocation:(MPLocation *)location {
    _location = location;
    if (_location) {
        if (_location.descr) [_fields addObject:@{@"text": _location.descr}];
        
        MPLocation* from = [[MPLocation alloc] initWithPoint:Global.positionProvider.latestPositionResult.geometry andName:kLangMy_position];
        
        [_routing routingFrom: from to: _location by:@"walking" avoid:nil depart:nil arrive:nil];
        
        [self.iconImageView setImageWithURL:[NSURL URLWithString: [Global getIconUrlForType:_location.type]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        self.titleLabel.text = _location.name;
        //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"lounge"] forBarMetrics:UIBarMetricsDefault];
        
        if (_location.fields) {
            for (NSString* key in _location.fields.keyEnumerator) {
                MPLocationField* field = [_location.fields objectForKey:key];
                if (field.value && field.value.length > 1) {
                    if (!([[key lowercaseString] isEqualToString:@"imageurl"] || [key isEqualToString:@"image"])) {
                        //Not image
                        if ([key isEqualToString:@"openinghours"]) [_fields addObject:@{@"type": key, @"text": field.value, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_time]}];
                        if ([key isEqualToString:@"website"]) [_fields addObject:@{@"type": key, @"text": field.value, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_link]}];
                        if ([key isEqualToString:@"phone"]) [_fields addObject:@{@"type": key, @"text": field.value, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_phone]}];
                        if ([key isEqualToString:@"email"]) [_fields addObject:@{@"type": key, @"text": field.value, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_email]}];
                    } else {
                        //Image
                        [self.headerImageView setImageWithURL:[NSURL URLWithString:field.value] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                    }
                }
            }
        }
        
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 600, 184);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f] CGColor], nil];
    gradient.startPoint = CGPointMake(0, .5f);
    gradient.endPoint = CGPointMake(0, 1.0f);
    
    
    CAGradientLayer *gradientTop = [CAGradientLayer layer];
    gradientTop.frame = CGRectMake(0, 0, 600, 184);
    gradientTop.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f] CGColor], nil];
    gradientTop.startPoint = CGPointMake(0.2f, 0.4f);
    gradientTop.endPoint = CGPointMake(0, 0);
    
    
    [self.headerImageView.layer insertSublayer:gradient atIndex:0];
    [self.headerImageView.layer insertSublayer:gradientTop atIndex:1];
    
    //self.backIconView.image = [self.backIconView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backIconView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pop:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.backIconView addGestureRecognizer:singleTap];
    
    [self.tableView addSubview:_spinner];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_showMapBtn == nil) {
        _showMapBtn = [UIButton appRectButtonWithTitle:kLangShow_on_map target:self selector:@selector(showMapController:)];
        [_showMapBtn setTitleColor:[UIColor appSecondaryTextColor] forState:UIControlStateNormal];
        _showMapBtn.backgroundColor = [UIColor appTextAndIconColor];
        
        _routeBtn = [UIButton appRectButtonWithTitle:kLangGet_directions target:self selector:@selector(showDirectionsController:) xOffset:self.tableFooter.frame.size.width-120];
        
        [self.tableFooter addSubview:_showMapBtn];
        [self.tableFooter addSubview:_routeBtn];
        
//        [self.tableFooter removeFromSuperview];
//        [self.tableView.superview addSubview:self.tableFooter];
////        self.tableView.layer.zPosition = 1;
////        self.tableFooter.layer.zPosition = 999;
//        self.tableFooter.translatesAutoresizingMaskIntoConstraints = NO;
//        NSDictionary* viewsDictionary = @{@"footer":self.tableFooter};
//        NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[footer]-58-|"
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:viewsDictionary];
//        
//        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[footer]"
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:viewsDictionary];
//        
//        //self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height-200);
//        
//        [self.tableView.superview addConstraints:constraint_POS_V];
//        [self.tableView.superview addConstraints:constraint_POS_H];

    }
    
}

- (void) showMapController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseRouting" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationDetailsReady" object:_location];
    
    UIBarButtonItem* btn = self.splitViewController.displayModeButtonItem;
    [[UIApplication sharedApplication] sendAction:btn.action
                                               to:btn.target
                                             from:nil
                                         forEvent:nil];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}

- (void) showDirectionsController:(id)sender {
    if ([self shouldPerformSegueWithIdentifier:@"DirectionsSegue" sender:self]) {
        [self performSegueWithIdentifier:@"DirectionsSegue" sender:self];
    }
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
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
    // Return the number of rows in the section.
    return _fields.count;
}

- (UIImage*) materialIcon:(NSString*)iconCode {
    // create icon with Material Design code and font size
    // font size is the basis for icon size
    VCMaterialDesignIcons *icon = [VCMaterialDesignIcons iconWithCode:iconCode fontSize:30.f];
    
    // add attribute to icon
    ;
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor appPrimaryColor]];
    
    // the icon will be drawn to UIImage in a given size
    return [icon image];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];

    NSDictionary* dict = [_fields objectAtIndex:indexPath.row];
    
    if ([dict objectForKey:@"icon"])
        cell.imageView.image = [dict objectForKey:@"icon"];
    else cell.imageView.image = nil;
    cell.textLabel.text = [dict objectForKey:@"text"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dict = [_fields objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailFieldTapped" object:dict];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (self.tableView.indexPathForSelectedRow) {
        NSDictionary* dict = [_fields objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        if (![[dict objectForKey:@"type"] isEqualToString:@"directions"]) {
            return NO;
        }
    }
    return YES;
}


- (void)onRouteResultReady:(NSNotification *)notification {
    _route = notification.object;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSDictionary* directionsItem = @{@"type": @"directions", @"text": [NSString stringWithFormat: kLangMinutes_walk, (int)ceil([_route.duration floatValue] / 60.0f)], @"icon": [self materialIcon:VCMaterialDesignIconCode.md_walk]};
    if (_directionsItem == nil) {
        _directionsItem = directionsItem;
        [mutableArray addObject:_directionsItem];
    } else {
        _directionsItem = directionsItem;
    }
    [mutableArray addObjectsFromArray:_fields];
    _fields = mutableArray;
    [self.tableView reloadData];
}


@end
