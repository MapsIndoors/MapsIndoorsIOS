//
//  PlacePickerSearchController.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 23/06/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+SystemFontOverride.h"
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>


typedef void(^mpLocationSelectBlockType)(MPLocation* location);

@protocol PlacePickerDelegate

@required
- (void) onLocationSelected: (MPLocation*) location;
@end

@interface PlacePickerSearchController : UITableViewController<UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (weak) id placePickerDelegate;
@property (strong, nonatomic) MPLocation *myLocation;

- (void) placePickerSelectCallback: (mpLocationSelectBlockType)selectCallbackFn;

@end
