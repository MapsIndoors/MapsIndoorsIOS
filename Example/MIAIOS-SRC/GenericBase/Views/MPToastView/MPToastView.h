//
//  MPToastView.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 05/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPToastView;
typedef void    (^MPToastViewButtonClickBlockType)( MPToastView* toastView );


@interface MPToastView : UIView

@property (nonatomic, strong) NSString*                         message;
@property (nonatomic, strong) NSString*                         buttonTitle;
@property (nonatomic, copy) MPToastViewButtonClickBlockType     buttonClickHandler;

+ (instancetype) newWithMessage:(NSString*)msg;
+ (instancetype) newWithMessage:(NSString*)msg buttonTitle:(NSString*)buttonTitle buttonClickHandler:(MPToastViewButtonClickBlockType)buttonClickHandler;

- (instancetype) initWithMessage:(NSString*)msg buttonTitle:(NSString*)buttonTitle buttonClickHandler:(MPToastViewButtonClickBlockType)buttonClickHandler;
- (instancetype) init NS_UNAVAILABLE;

@end
