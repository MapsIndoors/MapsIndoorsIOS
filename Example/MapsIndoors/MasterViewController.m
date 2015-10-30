//
//  MasterViewController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "Global.h"
#import "MasterViewController.h"
#import "SearchViewController.h"
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UINavigationController+TransparentNavigationController.h"
#import "UISearchBar+AppSearchBar.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController


- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
        
    }
    self.objects = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.tableView setContentInset:UIEdgeInsetsMake(-64,0,0,0)];
    
    //self.detailViewController = (UITableViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.searchBar.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(solutionDataReady:) name:@"SolutionDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationsReady:) name:@"LocationsDataReady" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if (indexPath) {
            MPType *object = self.objects[indexPath.row];
            MPLocationQuery* query = [[MPLocationQuery alloc] init];
            query.types = @[object.name];
            query.solutionId = Global.solutionId;
            query.max = 25;
            [Global.poiData getLocationsUsingQueryAsync:query language:@"en"];
        } else {
            //Reset query
            Global.poiData.locationQuery.query = @"";
            Global.poiData.locationQuery.types = nil;
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.objects) return self.objects.count;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __unsafe_unretained UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    MPType *object = self.objects[indexPath.row];
    cell.textLabel.text = [object name];
    
    
    NSURL* url = [NSURL URLWithString:object.icon];
    //NSURLRequest* req = [NSURLRequest requestWithURL:url];
    
    [cell.imageView setImageWithURL: url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

- (void)solutionDataReady:(NSNotification*)notification {
    Global.solution = notification.object;
    [self.objects removeAllObjects];
    [self.objects addObjectsFromArray:Global.solution.types];
    [self.tableView reloadData];
}

- (void)onLocationsReady:(NSNotification*)notification {
    if ([self.navigationController.visibleViewController isEqual:self] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (indexPath) [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self performSegueWithIdentifier: @"SearchSegue" sender: self];
    return NO;
}

@end
