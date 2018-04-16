//
//  AppInfoHeaderTableViewCell.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 11/10/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppInfoHeaderTableViewCell : UITableViewCell

- (void) configureWithAppName:(NSString*)appName providerName:(NSString*)providerName providerNameTapAction:(void(^)(void))providerNameTapAction;

@end
