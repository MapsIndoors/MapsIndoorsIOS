//
//  NoCancelButtonSearchController.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 31/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "NoCancelButtonSearchController.h"
#import "NoCancelButtonSearchBar.h"


@interface NoCancelButtonSearchController ()

@property (nonatomic, strong) NoCancelButtonSearchBar*      noCancelButtonSearchBar;

@end

@implementation NoCancelButtonSearchController

- (NoCancelButtonSearchBar*) noCancelButtonSearchBar {

    if ( _noCancelButtonSearchBar == nil ) {
        _noCancelButtonSearchBar = [NoCancelButtonSearchBar new];
    }
    
    return _noCancelButtonSearchBar;
}

- (UISearchBar*) searchBar {
    
    return self.noCancelButtonSearchBar;
}

@end
