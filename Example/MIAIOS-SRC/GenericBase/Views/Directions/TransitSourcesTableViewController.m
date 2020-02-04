//
//  TransitSourcesTableViewController.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 07/08/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "TransitSourcesTableViewController.h"
#import "UIViewController+Custom.h"
@import MaterialControls;
#import "Tracker.h"
#import "UIColor+AppColor.h"
#import "LocalizedStrings.h"
#import "TCFKA_MDSnackbar.h"


@implementation TransitSourcesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString( @"Tickets and information", );
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [Tracker trackScreen:@"TransitSources"];
    
    [self presentCustomBackButton];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.transitSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    MPTransitAgency*    agency = section < self.transitSources.count ? self.transitSources[section] : nil;
    NSInteger           numRows = 0;
    
    if ( agency.url.length ) {
        ++numRows;
    }
// Removed for now, since the Google data for agency phonenumbers contain a prefixed "011" which makes all return phonenumbers invalid.
// The "011" seems to be International Direct Dialling, see https://en.wikipedia.org/wiki/List_of_international_call_prefixes.
// The process of going from a number with IDD to a callable number seems non-trivial.
// https://github.com/googlei18n/libphonenumber looks promising.
// For now, we just bail and do not display phonenumbers.
//
//    if ( agency.phone.length ) {
//        ++numRows;
//    }
    
    return numRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return section < self.transitSources.count ? self.transitSources[section].name : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    MPTransitAgency*    agency = section < self.transitSources.count ? self.transitSources[section] : nil;
    CGRect              r = CGRectMake( 0, 0, tableView.bounds.size.width, 44 );
    UILabel*            hdr = [[UILabel alloc] initWithFrame:r];
    
    hdr.font = [UIFont boldSystemFontOfSize:16];
    hdr.textColor = [UIColor blackColor];
    hdr.backgroundColor = [UIColor colorWithWhite:0.93 alpha:0.5];
    hdr.text = [@"    " stringByAppendingString: agency.name];        // Lazy man's padding solution on UILabel ;-)
    
    return hdr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*    cell = [tableView dequeueReusableCellWithIdentifier:@"transitSourceCellId" forIndexPath:indexPath];
    MPTransitAgency*    agency = indexPath.section < self.transitSources.count ? self.transitSources[indexPath.section] : nil;
    
    NSString*   title;
    NSString*   subTitle;
    
    if ( (indexPath.row == 0) && agency.url.length ) {
        title = kLangWebsite;
        
        NSURLComponents*    urlComponents = [NSURLComponents componentsWithString:agency.url];
        subTitle = urlComponents.host ?: agency.url;
        cell.detailTextLabel.textColor = [UIColor appPrimaryColor];
    }
    
    if ( title == nil ) {
        title = kLangPhone;
        subTitle = agency.phone;
    }

    cell.textLabel.text = title;
    cell.detailTextLabel.text = subTitle;

    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell*    cell = [tableView cellForRowAtIndexPath:indexPath];
    MPTransitAgency*    agency = indexPath.section < self.transitSources.count ? self.transitSources[indexPath.section] : nil;
    
    if ( [cell.textLabel.text isEqualToString:kLangWebsite] ) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:kLangOpenInSafariQ
                                                    message: [NSString stringWithFormat:@"\n%@\n", agency.url]
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction*  openBtn = [UIAlertAction actionWithTitle:kLangOpen style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            // Using SFSafariViewController here leads to layout issues when returning to the "Sources" view...
            // So for now, avoid that problem by launching external Safari.app.
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:agency.url] options:@{} completionHandler:nil];
        }];
        [openBtn setValue:[UIColor redColor] forKey:@"titleTextColor"];
        
        UIAlertAction*  CancelBtn = [UIAlertAction actionWithTitle:kLangCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
        
        [alert addAction:openBtn];
        [alert addAction:CancelBtn];
        
        [self presentViewController:alert animated:YES completion:nil];

    } else {
    
        NSCharacterSet* nonDigitCharSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSString*   cleanedUpPhonenumber = [[agency.phone componentsSeparatedByCharactersInSet:nonDigitCharSet] componentsJoinedByString:@""];
        NSString*   telString = [NSString stringWithFormat:@"tel:%@", cleanedUpPhonenumber];
        NSURL*      telUrl = [NSURL URLWithString:telString];
        
        if ( [[UIApplication sharedApplication] canOpenURL:telUrl] ) {
            [[UIApplication sharedApplication] openURL:telUrl options:@{} completionHandler:nil];
        } else {
            [UIPasteboard generalPasteboard].string = agency.phone;
            
            TCFKA_MDSnackbar* s = [[TCFKA_MDSnackbar alloc] initWithText:kLangPhoneNumberCopiedToClipboard actionTitle:@"" duration:1];
            [s show];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
