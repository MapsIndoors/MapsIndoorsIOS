//
//  AppInformationViewController.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 11/10/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "AppInformationViewController.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "UIViewController+Custom.h"
#import "UIColor+AppColor.h"
#import "Global.h"
#import "AppInfoHeaderTableViewCell.h"
#import "AppInfoTextTableViewCell.h"
#import <MapsIndoors/MPVersion.h>
#import "AppInfoAcknowledgementViewController.h"
#import "AppInfoOtherInfoViewController.h"
#import "LocalizedStrings.h"
#import <sys/utsname.h>
#import "AppPositionProvider.h"


typedef NS_ENUM(NSUInteger, AppInfoSection) {
    AppInfoSection_BaseInfo,
    AppInfoSection_OtherInfo,
    AppInfoSection_AppVersions,
    AppInfoSection_Supplier,
    AppInfoSection_Credits,
    
    AppInfoSection_Count
};

typedef NS_ENUM(NSUInteger, AppInfoVersion) {
    AppInfoVersion_App,
    AppInfoVersion_SDK,
    AppInfoVersion_PositioningProvider,

    AppInfoVersion_Count
};


@interface AppInformationViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView*           tableView;
@property (weak, nonatomic) IBOutlet UIView*                feedbackContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint*    feedbackDistanceFromBottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView*           actionsTableView;
@property (weak, nonatomic) IBOutlet UIButton*              logoutButton;


@property (nonatomic, strong) NSString*                     feedbackUrl;
@property (nonatomic, strong) NSString*                     helpUrl;
@property (nonatomic, strong) NSString*                     providerHomepageUrl;
@property (nonatomic, strong) NSString*                     supplierHomepageUrl;

@property (nonatomic) NSUInteger numberOfActionsTableViewRows;

@property (nonatomic, strong) NSArray<NSDictionary*>*       licenses;
@property (nonatomic, strong) NSMutableDictionary*          otherInfo;

@property (nonatomic) BOOL                                  havePositioningProviderInfo;

@end


@implementation AppInformationViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString( @"App Information", );
    [self presentCustomBackButton];

    self.tableView.tableFooterView = [UIView new];  // A little trick for removing the cell separators
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.providerHomepageUrl = [Global getPropertyFromPlist: @"AppProviderUrl"];
    self.supplierHomepageUrl = [Global getPropertyFromPlist: @"AppSupplierUrl"];
    
    self.actionsTableView.dataSource = self;
    self.actionsTableView.delegate = self;

    self.havePositioningProviderInfo = [MapsIndoors.positionProvider conformsToProtocol:@protocol(AppPositionProvider)];

//    [self.feedbackButton setTitleColor:[UIColor appLightPrimaryColor] forState:UIControlStateNormal];
//
//    self.feedbackImageView.image = [[UIImage imageNamed:@"info_white_48dp"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    self.feedbackImageView.tintColor = [UIColor appDarkPrimaryColor];
    
    
    self.feedbackUrl = [Global.appData.appSettings objectForKey: @"feedbackUrl"];
    self.helpUrl = [Global.appData.appSettings objectForKey: @"helpUrl"];
    self.numberOfActionsTableViewRows = 0;
    if ( self.feedbackUrl.length > 0 ) {
        self.numberOfActionsTableViewRows++;
    }
    if ( self.helpUrl.length > 0 ) {
        self.numberOfActionsTableViewRows++;
    }
    self.feedbackDistanceFromBottomConstraint.constant = 32 + self.numberOfActionsTableViewRows * 44;
    
    // Locate acknowledgement plist:
    NSString*           pathToAcknowledgementsPlist;
    NSArray<NSString*>* paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"plist" inDirectory:nil];
    
    for ( NSString* path in paths ) {
        NSString*   filename = [[path lastPathComponent] lowercaseString];
        
        // Avoid having to know the app name here by only matching other parts of the filename:
        // /var/containers/Bundle/Application/.../XYZ Maps.app/Pods-XYZ Maps-acknowledgements.plist
        if ( [filename hasPrefix:@"pods-"] && [filename hasSuffix:@"-acknowledgements.plist"] ) {
            pathToAcknowledgementsPlist = path;
            break;
        }
    }
    
    NSDictionary*   ackDict = [NSDictionary dictionaryWithContentsOfFile:pathToAcknowledgementsPlist];
    
    self.licenses = [ackDict[@"PreferenceSpecifiers"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDictionary* _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return evaluatedObject[@"License"] != nil;
    }]];
    
    self.otherInfo = [NSMutableDictionary dictionary];
    
    [self addOtherInfo:@"privacy"];
    [self addOtherInfo:@"impressum"];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController resetNavigationBar];
}

- (void)addOtherInfo:(NSString *)otherResource {
    NSBundle* b = [NSBundle mainBundle];
    NSURL* url = [b URLForResource:otherResource withExtension:@"txt"];
    
    if (url) {
        self.otherInfo[otherResource] = url;
    }
}

#pragma mark - Actions

- (void) helpCellTapped {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.helpUrl] options:@{} completionHandler:nil];
}

- (void) feedbackCellTapped {

    NSString*   feedbackUrl = self.feedbackUrl;
    
#if DEBUG
    if ( [self.feedbackUrl hasPrefix:@"mailto:"] ) {
        NSURL*                      url = [NSURL URLWithString:feedbackUrl];
        NSURLComponents*            urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        NSArray<NSURLQueryItem*>*   mailBody = [urlComponents.queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSURLQueryItem* _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject.name isEqualToString:@"body"];
        }]];
        if ( mailBody.count < 1 ) {
            NSString*   version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            NSString*   buildNumber = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
            NSString*   presentedVersion = [NSString stringWithFormat:@"%@ (%@)", version, buildNumber];

            struct utsname systemInfo;
            uname(&systemInfo);
            
            NSString*   deviceType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

            NSMutableString*    info = [@"\n\n\n==== App info ====\n" mutableCopy];
            [info appendFormat:@"App Version: %@\n", presentedVersion];
            [info appendFormat:@"%@ %@\n", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
            [info appendFormat:@"Screensize: %@x%@ @%@x\n", @([UIScreen mainScreen].bounds.size.width), @([UIScreen mainScreen].bounds.size.height), @((int)[UIScreen mainScreen].scale)];
            [info appendFormat:@"Device: %@", deviceType];

            urlComponents.queryItems = [urlComponents.queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"body" value:info]];
            
            feedbackUrl = urlComponents.URL.absoluteString;
        }
    }
#endif
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:feedbackUrl] options:@{} completionHandler:nil];
}

- (void) onAppProviderNameTapped {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.providerHomepageUrl] options:@{} completionHandler:nil];
}

- (void) onAppSupplierNameTapped {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.supplierHomepageUrl] options:@{} completionHandler:nil];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.actionsTableView) {
        return self.numberOfActionsTableViewRows;
    }
    
    NSInteger   numberOfRows = 0;
    
    switch ( (AppInfoSection)section ) {
        case AppInfoSection_BaseInfo:
        case AppInfoSection_Supplier:
            numberOfRows = 1;
            break;
        case AppInfoSection_OtherInfo:
            numberOfRows = self.otherInfo.count;
            break;
        case AppInfoSection_AppVersions:
            numberOfRows = AppInfoVersion_Count;
            if ( !self.havePositioningProviderInfo ) {
                --numberOfRows;
            }
            break;
        case AppInfoSection_Credits:
            numberOfRows = self.licenses.count;
            break;
            
        case AppInfoSection_Count:
            break;
    }
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.actionsTableView) {
        return 1;
    }
    
    return AppInfoSection_Count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ( tableView == self.actionsTableView ) {
        return nil;
    }
    
    NSString*   title;
    
    switch ( (AppInfoSection)section ) {
        case AppInfoSection_BaseInfo:
        case AppInfoSection_OtherInfo:
            break;
        case AppInfoSection_AppVersions:
            title = NSLocalizedString(@"App Version",);
            break;
        case AppInfoSection_Supplier:
            title = NSLocalizedString(@"Supplier",);
            break;
        case AppInfoSection_Credits:
            title = NSLocalizedString(@"Credits",);
            break;
        case AppInfoSection_Count:
            break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.actionsTableView) {
        return [self createActionCellForTableView:tableView indexPath:(NSIndexPath *)indexPath];
    }
    
    UITableViewCell*    cell;
    
    switch ( (AppInfoSection)indexPath.section ) {
        case AppInfoSection_BaseInfo:
            cell = [self createHeaderCellForTableView:tableView];
            break;
        case AppInfoSection_OtherInfo:
            cell = [self createInfoCellForTableView:tableView indexPath:indexPath];
            break;
        case AppInfoSection_AppVersions:
            switch ( (AppInfoVersion)indexPath.row ) {
                case AppInfoVersion_App:
                    cell = [self createAppVersionCellForTableView:tableView];
                    break;
                case AppInfoVersion_SDK:
                    cell = [self createSdkVersionCellForTableView:tableView];
                    break;
                case AppInfoVersion_PositioningProvider:
                    cell = [self createPositioningProviderVersionCellForTableView:tableView];
                    break;
                case AppInfoVersion_Count:
                    break;
            }
            break;
        case AppInfoSection_Supplier:
            cell = [self createSupplierCellForTableView:tableView];
            break;
        case AppInfoSection_Credits:
            cell = [self createCreditsCellForTableView:tableView indexPath:indexPath];
            break;
        case AppInfoSection_Count:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.actionsTableView) {
        if (indexPath.row == 0 && self.feedbackUrl.length > 0) {
            [self feedbackCellTapped];
        } else if (indexPath.row == 1 || self.helpUrl.length > 0) {
            [self helpCellTapped];
        }

    } else {

        switch ( (AppInfoSection)indexPath.section ) {
            case AppInfoSection_Supplier:
                [self onAppSupplierNameTapped];
                break;
            case AppInfoSection_OtherInfo: {
                NSUInteger      index = indexPath.row;
                NSURL*   file;
                if ( index < self.otherInfo.count ) {
                    NSString* key = self.otherInfo.allKeys[index];
                    file = self.otherInfo[key];
                    NSString* title = NSLocalizedString(key,);
                    AppInfoOtherInfoViewController *vc = [[AppInfoOtherInfoViewController alloc] initWithTitle:(NSString*)title textFile:file];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
            }

            case AppInfoSection_Credits: {
                NSUInteger      index = indexPath.row;
                NSDictionary*   licenseDict;
                if ( index < self.licenses.count ) {
                    licenseDict = self.licenses[index];
                }

                AppInfoAcknowledgementViewController*   vc = [[AppInfoAcknowledgementViewController alloc] initWithAcknowledgementDict:licenseDict];
                [self.navigationController pushViewController:vc animated:YES];

                break;
            }

            case AppInfoSection_AppVersions: {
                if ( indexPath.row == AppInfoVersion_PositioningProvider ) {
                    if ( [MapsIndoors.positionProvider conformsToProtocol:@protocol(AppPositionProvider)] ) {
                        id<AppPositionProvider>     pp = (id<AppPositionProvider>)MapsIndoors.positionProvider;
                        pp.enableDebugInfo = pp.enableDebugInfo == NO;
                    }
                }
                break;
            }

            case AppInfoSection_BaseInfo:
            case AppInfoSection_Count:
                break;
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
    

#pragma mark - Cell creation

- (UITableViewCell*) createHeaderCellForTableView:(UITableView *)tableView {
    
    AppInfoHeaderTableViewCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"appInfoHeaderCell"];
    NSString* appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"] ?: [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
    NSString* appProviderName = [Global getPropertyFromPlist:@"AppProviderName"];
    
    void (^providerNameTapAction)(void) = nil;
    if ( self.providerHomepageUrl.length ) {
        __weak typeof(self)weakSelf = self;
        providerNameTapAction = ^{
            [weakSelf onAppProviderNameTapped];
        };
    }
    
    [headerCell configureWithAppName:appName providerName:appProviderName providerNameTapAction:providerNameTapAction];

    return headerCell;
}

- (UITableViewCell*) createVersionCellForTableView:(UITableView*)tableView name:(NSString*)name version:(NSString*)version {
    
    AppInfoTextTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appInfoTextCell"];
    [cell configureWithText:name detail:version];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (NSString*) appVersionForPresentation {

    NSString*   version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString*   buildNumber = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@ (%@)", version, buildNumber];
}

- (UITableViewCell*) createAppVersionCellForTableView:(UITableView*)tableView {

    NSString*   presentedVersion = [self appVersionForPresentation];
    return [self createVersionCellForTableView:tableView name:NSLocalizedString(@"App",) version:presentedVersion];
}

- (UITableViewCell*) createSdkVersionCellForTableView:(UITableView*)tableView {
    
    return [self createVersionCellForTableView:tableView name:NSLocalizedString(@"SDK",) version:[MPSDKVersion versionString]];
}


- (UITableViewCell*) createPositioningProviderVersionCellForTableView:(UITableView*)tableView {

    UITableViewCell*    cell;

    if ( self.havePositioningProviderInfo ) {
        id<AppPositionProvider>     pp = (id<AppPositionProvider>)MapsIndoors.positionProvider;

        cell = [self createVersionCellForTableView:tableView name:pp.name version:pp.version ?: [self appVersionForPresentation]];
    }

    return cell;
}


- (UITableViewCell*) createSupplierCellForTableView:(UITableView*)tableView {
    
    NSString* appSupplierName = [Global getPropertyFromPlist:@"AppSupplierName"];
    AppInfoTextTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appInfoTextCell"];
    [cell configureWithText:appSupplierName detail:@"" selectable:YES];
    return cell;
}

- (UITableViewCell*) createCreditsCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    
    NSUInteger  index = indexPath.row;
    NSString*   licenseName = @"";
    if ( index < self.licenses.count ) {
        licenseName = self.licenses[index][@"Title"];
    }
    
    AppInfoTextTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appInfoTextCell"];
    [cell configureWithText:licenseName detail:@"" selectable:NO];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCell*) createInfoCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    NSString* infoKey = self.otherInfo.allKeys[indexPath.row];
    AppInfoTextTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appInfoTextCell"];
    [cell configureWithText:NSLocalizedString(infoKey,) detail:@"" selectable:NO];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCell*) createActionCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [UITableViewCell new];
    cell.textLabel.tintColor = [UIColor appLightPrimaryColor];
    cell.imageView.tintColor = [UIColor appDarkPrimaryColor];
    if (indexPath.row == 0 && self.feedbackUrl.length > 0) {
        cell.textLabel.text = kLangFeedback;
        cell.imageView.image = [[UIImage imageNamed:@"baseline_error_outline_white_36pt"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else if (indexPath.row == 1 || self.helpUrl.length > 0) {
        cell.textLabel.text = kLangHelp;
        cell.imageView.image = [[UIImage imageNamed:@"baseline_help_outline_white_36pt"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return cell;
}

@end
