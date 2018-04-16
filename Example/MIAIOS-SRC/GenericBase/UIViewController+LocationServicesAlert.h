//
//  UIViewController+LocationServicesAlert.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 19/04/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LocationServicesAlert)

- (UIAlertController*) alertControllerForLocationServicesState;

@end
