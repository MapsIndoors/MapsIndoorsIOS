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
#import "UINavigationController+TransparentNavigationController.h"
#import "UISearchBar+AppSearchBar.h"
#import "UIViewController+Custom.h"
#import "LocalizedStrings.h"
#import "LocalizationSystem.h"
#import "UIColor+AppColor.h"

@import AFNetworking;
@import VCMaterialDesignIcons;
@import MaterialControls;

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController {
    MPAppDataProvider* _appDataProvider;
    MPAppData* _appData;
    MPCategoriesProvider* _categoriesProvider;
    NSMutableArray* _categories;
    MDSnackbar* _bar;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
        
    }
    
    _appDataProvider = [[MPAppDataProvider alloc] init];
    _categoriesProvider = [[MPCategoriesProvider alloc] init];
    _objects = [NSMutableArray array];
    _categories = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVenueChange:) name:@"VenueChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSolutionReady:) name:@"SolutionDataReady" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.tableView setContentInset:UIEdgeInsetsMake(-64,0,0,0)];
    
    //self.detailViewController = (UITableViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 600, 140);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f] CGColor], nil];
    gradient.startPoint = CGPointMake(0, .5f);
    gradient.endPoint = CGPointMake(0, 1.0f);
    [self.headerImageView.layer insertSublayer:gradient atIndex:0];
    
    UIImage* downImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_caret_down fontSize:20.0f].image;
    [self.venueButton setImage:downImg forState:UIControlStateNormal];
    [self.venueButton setTitle:Global.venue.name forState:UIControlStateNormal];
    [self.venueButton addTarget:self action:@selector(openVenueSelector) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = kLangSearch;
    
    [_appDataProvider getAppDataAsync:Global.solutionId language:LocalizationGetLanguage completionHandler:^(MPAppData *appData, NSError *error) {
        if (error && !_bar.isShowing) {
            _bar = [[MDSnackbar alloc] initWithText:kLangCouldNotFindContent actionTitle:@"" duration:4.0];
            [_bar show];
        }
        else if (appData) {
            _appData = appData;
            [self.objects removeAllObjects];
            for (NSDictionary* item in [appData.menuInfo objectForKey:@"mainmenu"]) {
                NSError* err;
                MPMenuItem* menuItem = [[MPMenuItem alloc] initWithDictionary:item error:&err];
                if (err == nil)
                    [self.objects addObject:menuItem];
            }
            
            [self.tableView reloadData];
        }
    }];
    
    _categoriesProvider.delegate = self;
    [_categoriesProvider getCategoriesAsync:Global.solutionId locale:LocalizationGetLanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationsReady:) name:@"LocationsDataReady" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
    NSString* headerImageUrl = [_appData.venueImages objectForKey:Global.venue.venueKey];
    if (headerImageUrl != nil) {
        [self.headerImageView setImageWithURL:[NSURL URLWithString:headerImageUrl]];
    }
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
            MPMenuItem *object = self.objects[indexPath.row];
            SearchViewController* svc = segue.destinationViewController;
            svc.headerImageUrl = object.menuImageUrl;
            
            MPLocationQuery* query = [[MPLocationQuery alloc] init];
            query.categories = @[object.categoryKey];
            query.solutionId = Global.solutionId;
            query.max = 25;
            [Global.poiData getLocationsUsingQueryAsync:query language:LocalizationGetLanguage];
        } else {
            //Reset query
            Global.poiData.locationQuery.query = @"";
            Global.poiData.locationQuery.categories = nil;
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (Global.solution.availableLanguages.count > 1) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.objects) return self.objects.count;
        else return 0;
    } else if (section == 1) {
        return Global.solution.availableLanguages.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __unsafe_unretained UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (indexPath.section == 0) {
        MPMenuItem *object = self.objects[indexPath.row];
        cell.textLabel.text = [self categoryNameForKey:object.categoryKey];
        
        
        NSURL* url = [NSURL URLWithString:object.iconUrl];
        //NSURLRequest* req = [NSURLRequest requestWithURL:url];
        
        [cell.imageView setImageWithURL: url placeholderImage:[UIImage imageNamed:@"placeholder1"]];
    } else if (indexPath.section == 1) {
        NSString* lId = [Global.solution.availableLanguages objectAtIndex:indexPath.row];
        if ([LocalizationGetLanguage isEqualToString:lId]) {
            VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_check_square fontSize:22.0];
            [icon addAttribute:NSForegroundColorAttributeName value:[UIColor appSecondaryTextColor]];
            cell.imageView.image = icon.image;
        } else {
            VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_square_o fontSize:22.0];
            [icon addAttribute:NSForegroundColorAttributeName value:[UIColor appSecondaryTextColor]];
            cell.imageView.image = icon.image;
        }
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:lId];
        NSString *language = [locale displayNameForKey:NSLocaleIdentifier
                                                 value:[locale localeIdentifier]];
        NSString* capitalisedLanguage = [language stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                  withString:[[language substringToIndex:1] capitalizedString]];

        cell.textLabel.text = capitalisedLanguage;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kLangCategories;
    } else if (section == 1) {
        return kLangLanguage;
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)onSolutionReady: (NSNotification*) notification {
    Global.solution = notification.object;
    [self.tableView reloadData];
}

- (void)onCategoriesReady:(NSArray *)categories {
    [_categories removeAllObjects];
    [_categories addObjectsFromArray:categories];
    [self.tableView reloadData];
    
}

- (NSString*) categoryNameForKey: (NSString*) categoryKey {
        for (MPDataField* field in _categories) {
            if ([field.key isEqualToString:categoryKey]) {
                return field.value;
            }
        }
    return categoryKey;
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

- (void) onVenueChange: (NSNotification*) notification {
    MPVenue* v = notification.object;
    [self.venueButton setTitle: v.name forState:UIControlStateNormal];
    NSString* headerImageUrl = [_appData.venueImages objectForKey:Global.venue.venueKey];
    if (headerImageUrl != nil) {
        [self.headerImageView setImageWithURL:[NSURL URLWithString:headerImageUrl]];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (self.tableView.indexPathForSelectedRow.section == 1) {
        NSString* langId = [Global.solution.availableLanguages objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        LocalizationSetLanguage(langId);
        [_categoriesProvider getCategoriesAsync:Global.solutionId locale:LocalizationGetLanguage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload" object:nil];
        return NO;
    }
    return YES;
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView* headerView = (UITableViewHeaderFooterView*)view;
    headerView.tintColor = [UIColor whiteColor];
    headerView.textLabel.textColor = [UIColor appPrimaryColor];
}

@end
