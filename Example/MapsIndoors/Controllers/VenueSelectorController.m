//
//  VenueSelectorController.m
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 05/07/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import "VenueSelectorController.h"
#import "Global.h"
#import "UIColor+AppColor.h"
#import "LocalizationSystem.h"
#import "LocalizedStrings.h"
@import VCMaterialDesignIcons;

static NSString* cellIdentifier = @"venueTableCell";

@interface VenueSelectorController ()

@end

@implementation VenueSelectorController {
    NSArray* _venues;
    MPVenueProvider* _venueProvider;
    mpVenueSelectBlockType _venueSelectCallback;
    UINavigationBar* _navigationBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor clearColor];
    refreshControl.backgroundColor = [UIColor clearColor];
    [refreshControl addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    
    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor =[UIColor appPrimaryColor];
    
    self.title = [NSString stringWithFormat:@"SDU Map - %@", kLangSelect_venue];
    
    UIImage* backImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_arrow_left fontSize:28.0f].image;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    _venueProvider = [[MPVenueProvider alloc] init];
    [_venueProvider getVenuesAsync:Global.solutionId language: LocalizationGetLanguage completionHandler:^(MPVenueCollection *venueCollection, NSError *error) {
        
        _venues = [venueCollection.venues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [((MPVenue*)obj1).venueKey caseInsensitiveCompare:((MPVenue*)obj2).venueKey];
        }];
        [self.tableView reloadData];
    }];

    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_venues != nil) {
        return _venues.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    MPVenue* venue = [_venues objectAtIndex:indexPath.row];
    
    cell.textLabel.text = venue.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MPVenue* venue = [_venues objectAtIndex:indexPath.row];
    if (self.venueSelectDelegate) {
        [self.venueSelectDelegate onVenueSelected:venue];
    }
    if (_venueSelectCallback) {
        _venueSelectCallback(venue);
    }
}

- (void)venueSelectCallback:(mpVenueSelectBlockType)selectCallbackFn {
    _venueSelectCallback = selectCallbackFn;
}


- (void) backPressed {
    if (_venues.count) {
        //MPVenue* venue = [_venues objectAtIndex:0];
        if (self.venueSelectDelegate) {
            [self.venueSelectDelegate onVenueSelected:nil];
        }
        if (_venueSelectCallback) {
            _venueSelectCallback(nil);
        }
    }
}

@end
