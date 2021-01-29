//
//  MPToastView.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 05/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPToastView.h"
#import <PureLayout/PureLayout.h>
#import "UIColor+AppColor.h"
#import "AppFonts.h"
#import "NSObject+ContentSizeChange.h"


@interface MPToastView ()

@property (nonatomic, weak) UIStackView*    stackView;
@property (nonatomic, weak) UILabel*        messageLabel;
@property (nonatomic, weak) UIButton*       actionButton;

@end


@implementation MPToastView

+ (instancetype) newWithMessage:(NSString*)msg {
    
    return [[MPToastView alloc] initWithMessage:msg buttonTitle:nil buttonClickHandler:nil];
}


+ (instancetype) newWithMessage:(NSString*)msg buttonTitle:(NSString*)buttonTitle buttonClickHandler:(MPToastViewButtonClickBlockType)buttonClickHandler {

    return [[MPToastView alloc] initWithMessage:msg buttonTitle:buttonTitle buttonClickHandler:buttonClickHandler];
}


- (instancetype) initWithMessage:(NSString*)msg buttonTitle:(NSString*)buttonTitle buttonClickHandler:(MPToastViewButtonClickBlockType)buttonClickHandler {
    
    self = [super init];
    
    if (self) {
        
        self.message = msg;
        self.buttonTitle = buttonTitle;
        self.buttonClickHandler = buttonClickHandler;
        self.backgroundColor = [UIColor appToastBackgroundColor];
        
        BOOL    shouldShowButton = buttonTitle.length && buttonClickHandler;
        
        UIStackView*    sv = [[UIStackView alloc] initForAutoLayout];
        self.stackView = sv;
        [self addSubview:sv];
        [sv autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake( 4, 16, 4, 16)];
        sv.axis = UILayoutConstraintAxisHorizontal;
        sv.distribution = UIStackViewDistributionFill;
        
        UILabel*    messageLabel = [[UILabel alloc] initForAutoLayout];
        self.messageLabel = messageLabel;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.font = [AppFonts sharedInstance].infoMessageFont;
        messageLabel.text = msg;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = shouldShowButton ? NSTextAlignmentLeft : NSTextAlignmentCenter;
        [self.stackView addArrangedSubview:messageLabel];

        UIButton*   actionButton;
        if ( shouldShowButton ) {
            actionButton = [[UIButton alloc] initForAutoLayout];
            self.actionButton = actionButton;
            [actionButton setTitle:buttonTitle forState:UIControlStateNormal];
            [actionButton setTitleColor:[UIColor appTertiaryHighlightColor] forState:UIControlStateNormal];
            actionButton.titleLabel.font = [AppFonts sharedInstance].buttonFont;
            [actionButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.stackView addArrangedSubview:actionButton];
            [self.actionButton addTarget:self action:@selector(callButtonClickHandler) forControlEvents:UIControlEventTouchDown];
        }

        [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
            messageLabel.font = [AppFonts sharedInstance].infoMessageFont;
            actionButton.titleLabel.font = [AppFonts sharedInstance].buttonFont;
        }];
        
        return self;
    }
    
    return self;
}


- (void) callButtonClickHandler {
    
    if ( self.buttonClickHandler ) {
        self.buttonClickHandler( self );
    }
}

@end
