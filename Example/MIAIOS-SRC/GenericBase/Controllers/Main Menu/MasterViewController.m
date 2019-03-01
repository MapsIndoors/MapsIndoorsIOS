//
//  MasterViewController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "MasterViewController.h"
#import "SearchViewController.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "UISearchBar+AppSearchBar.h"
#import "UIViewController+Custom.h"
#import "LocalizedStrings.h"
#import "LocalizationSystem.h"
#import "UIColor+AppColor.h"
#import "MPMenuItemCell.h"
#import "UIImageView+MPCachingImageLoader.h"
#import "Tracker.h"
#import "Global.h"
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"
#import "TCFKA_MDSnackbar.h"

@import VCMaterialDesignIcons;
@import MaterialControls;


@interface MasterViewController ()

@property (nonatomic) NSInteger     venueCount;

@end


@implementation MasterViewController {
    
    MPAppDataProvider* _appDataProvider;
    MPCategoriesProvider* _categoriesProvider;
    
    NSMutableArray* _categories;
    NSMutableArray* _objects;
    UIActivityIndicatorView* _spinner;
    
    TCFKA_MDSnackbar* _bar;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.venueCount = -1;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        self.clearsSelectionOnViewWillAppear = NO;
    }
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    _appDataProvider = [[MPAppDataProvider alloc] init];
    _categoriesProvider = [[MPCategoriesProvider alloc] init];
    
    _spinner.hidesWhenStopped = YES;
    
    _objects = [NSMutableArray array];
    _categories = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVenueChange:) name:@"VenueChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSolutionReady:) name:@"SolutionDataReady" object:nil];

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-statusBarHeight -navBarHeight,0,0,0)];
    
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
    
    self.venueLabel.font = AppFonts.sharedInstance.headerTitleFont;

    self.venueButtonItem.target = self;
    self.venueButtonItem.action = @selector(openVenueSelector);
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = kLangSearch;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MPMenuItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MenuItemCell"];
    
    [_spinner startAnimating];
    
    [_objects removeAllObjects];
    
    [_appDataProvider getAppDataWithCompletion:^(MPAppData *appData, NSError *error) {
        
        [_spinner stopAnimating];
        
        if (error && !_bar.isShowing) {
            
            _bar = [[TCFKA_MDSnackbar alloc] initWithText:kLangCouldNotFindContent actionTitle:nil duration:4.0];
            [_bar show];
        }
        else if (appData) {
            
            Global.appData = appData;
            
            self.venueLabel.text = Global.venue.name;
            
            NSString* headerImageUrl = [Global.appData.venueImages objectForKey:Global.venue.venueKey];
            if (headerImageUrl != nil) {
                [self.headerImageView mp_setImageWithURL:headerImageUrl];
            }
            
            _objects = [NSMutableArray array];  // Start out with a clean array, so we dont double up on menuitems.
            for (NSDictionary* item in [appData.menuInfo objectForKey:@"mainmenu"]) {
                NSError* err;
                MPMenuItem* menuItem = [[MPMenuItem alloc] initWithDictionary:item error:&err];
                
                if (err == nil) {
                    [_objects addObject:menuItem];
                }
            }
            
            [self.tableView reloadData];
        }
    }];
    
    [self.tableView reloadData];
    
    _categoriesProvider.delegate = self;
    
    [_categoriesProvider getCategories];
    
    _spinner.frame = CGRectMake(16, 240, _spinner.frame.size.width, _spinner.frame.size.height);
    
    [self.tableView addSubview:_spinner];
    
    self.navigationItem.leftBarButtonItem.accessibilityHint = kLangSelectVenueAccHint;
    self.venueLabel.accessibilityHint = kLangCurrentVenueAccHint;
    
    self.navigationItem.rightBarButtonItem.accessibilityLabel = kLangShowAppInfo;

    self.navigationItem.rightBarButtonItem.image = [self.navigationItem.rightBarButtonItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem.image = [self.navigationItem.leftBarButtonItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    __weak typeof(self)weakSelf = self;
    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        weakSelf.venueLabel.font = AppFonts.sharedInstance.headerTitleFont;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:@"SearchSegue" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [Tracker trackScreen:@"Main Menu"];
    
    [self.navigationController presentTransparentNavigationBar];

    NSString* headerImageUrl = [Global.appData.venueImages objectForKey:Global.venue.venueKey];
    if (headerImageUrl != nil) {
        [self.headerImageView mp_setImageWithURL:headerImageUrl placeholderImageName:[headerImageUrl lastPathComponent]];
    }
    
    if ( self.venueCount < 0 ) {
        MPVenueProvider*    vp = [MPVenueProvider new];
        [vp getVenuesWithCompletion:^(MPVenueCollection *venueCollection, NSError *error) {
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    self.venueCount = venueCollection.venues.count;
                    
                    if ( self.venueCount == 1 ) {
                        [self configureAppForVenue:venueCollection.venues.firstObject];
                    }
                });
            }
        }];
    }
    
    [self.tableView reloadData];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        if (indexPath) {
            
            MPMenuItem *object = _objects[indexPath.row];
            SearchViewController* svc = segue.destinationViewController;
            
            Global.locationQuery.categories = @[object.categoryKey];
            Global.locationQuery.venue = Global.venue.venueKey;
            Global.locationQuery.orderBy = @"name";
            
            svc.category = [self categoryForKey: object.categoryKey];
            
        } else {
            //Reset query
            Global.locationQuery.query = @"";
            Global.locationQuery.categories = nil;
            Global.locationQuery.venue = nil;
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_objects) return _objects.count;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MPMenuItemCell *cell = (MPMenuItemCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuItemCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MPMenuItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    MPMenuItem *object = _objects[indexPath.row];
    
    cell.textLabel.text = [self categoryForKey:object.categoryKey].value;
    cell.textLabel.textColor = [UIColor appPrimaryTextColor];
    [cell.imageView mp_setImageWithURL: object.iconUrl placeholderImageName:@"placeholder"];

    cell.accessibilityHint = kLangShowCategoryAccHint;
    
    return cell;
}

- (void)onSolutionReady: (NSNotification*) notification {
    [self.tableView reloadData];
}

- (void)onCategoriesReady:(NSArray *)categories {
    [_categories removeAllObjects];
    [_categories addObjectsFromArray:categories];
    [self.tableView reloadData];
}

- (MPDataField*) categoryForKey: (NSString*) categoryKey {
    for (MPDataField* field in _categories) {
        if ([field.key isEqualToString:categoryKey]) {
            return field;
        }
    }
    return nil;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (indexPath) [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self performSegueWithIdentifier: @"SearchSegue" sender: self];
    return NO;
}

- (void) onVenueChange: (NSNotification*) notification {
    
    MPVenue* v = notification.object;
    
    self.venueLabel.text = v.name;
    
    NSString* headerImageUrl = [Global.appData.venueImages objectForKey:Global.venue.venueKey];
    if (headerImageUrl != nil) {
        [self.headerImageView mp_setImageWithURL:headerImageUrl];
    }
    if (MapsIndoors.positionProvider.latestPositionResult == nil) {
        MapsIndoors.positionProvider.latestPositionResult = [[MPPositionResult alloc] init];
        MapsIndoors.positionProvider.latestPositionResult.geometry = [[MPPoint alloc] initWithLat:v.anchor.lat lon:v.anchor.lng zValue:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}


- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView* headerView = (UITableViewHeaderFooterView*)view;
    headerView.tintColor = [UIColor whiteColor];
    headerView.textLabel.textColor = [UIColor appPrimaryColor];
}


#pragma mark -

- (void)setVenueCount:(NSInteger)venueCount {
    
    if ( _venueCount != venueCount ) {
        _venueCount = venueCount;
        
        self.venueButtonItem.enabled = venueCount > 1;
    }
}

- (void) configureAppForVenue:(MPVenue*)venue {
    
    if ( venue ) {
        [[NSUserDefaults standardUserDefaults] setObject: venue.venueId forKey:@"venue"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VenueChanged" object:venue];
    }
}

@end
