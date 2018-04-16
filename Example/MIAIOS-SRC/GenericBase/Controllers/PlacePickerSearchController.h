//
//  PlacePickerSearchController.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 23/06/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+SystemFontOverride.h"
#import <MapsIndoors/MapsIndoors.h>


typedef void(^mpLocationSelectBlockType)(MPLocation* location);

@protocol PlacePickerDelegate

@required
- (void) onLocationSelected: (MPLocation*) location;
@end

@interface PlacePickerSearchController : UITableViewController<UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) UISearchController*   searchController;
@property (weak) id                                 placePickerDelegate;
@property (strong, nonatomic) MPLocation*           myLocation;
@property (strong, nonatomic) MPLocation*           selectedLocation;
@property (nonatomic) BOOL                          isOriginSearch;

- (void) placePickerSelectCallback: (mpLocationSelectBlockType)selectCallbackFn;

@end
